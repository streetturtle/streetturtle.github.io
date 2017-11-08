---
layout: post
title:  "Useful Alfresco SQL queries"
date:   2017-09-27 10:47:45
comments: true
description:
tags:
- alfresco
---

## Total number of documents

The following query allows to have the total number of nodes of _cm:content_ type:

{% highlight sql %}
SELECT count(1) AS docs_total
FROM alf_node AS an
  JOIN alf_qname AS aq ON an.type_qname_id = aq.id
  JOIN alf_namespace AS ans ON aq.ns_id = ans.id
WHERE aq.local_name = 'content'
      AND ans.uri = 'http://www.alfresco.org/model/content/1.0';
+------------+
| docs_total |
+------------+
|     100658 |
+------------+
1 row in set (0.03 sec)
{% endhighlight %}

If you want to know number of folders (nodes of type _cm:folder_) then just change the `aq.local_name` parameter from _content_ to _folder_. In case of custom content type, use the namespace and the type name of your custom content type.

But there is a tricky thing in the query above, you may see that total number of documents could be a bit bigger than expected. The reason for that is versions. In case you are using versionable aspect you may have multiple versions of the same document, which means that there are different nodes with the same name but different metadata.
To ignore such nodes the query below has a dirty hack, it counts number of document names distinctively:

{% highlight sql %}
SELECT count(1)
FROM (
       SELECT DISTINCT anp.string_value
       FROM alf_node AS an
         JOIN alf_node_properties AS anp ON an.id = anp.node_id
         JOIN alf_qname AS aq ON an.type_qname_id = aq.id
         JOIN alf_namespace AS ans ON aq.ns_id = ans.id
       WHERE aq.local_name = 'content'
             AND ans.uri = 'http://www.alfresco.org/model/content/1.0'
             AND anp.qname_id IN (SELECT id
                                  FROM alf_qname
                                  WHERE local_name = 'name')) AS tt;
{% endhighlight %}

## Number of documents of each type / extension

{% highlight sql linenos %}
SELECT
  tt.extension,
  count(tt.name)
FROM (
       SELECT
         DISTINCT
         anp.string_value                                   AS name,
         lower(substring_index(anp.string_value, '\.', -1)) AS extension
       FROM alf_node AS an
         JOIN alf_node_properties AS anp ON an.id = anp.node_id
         JOIN alf_qname AS aq1 ON an.type_qname_id = aq1.id
         JOIN alf_namespace AS ans ON aq1.ns_id = ans.id
       WHERE aq1.local_name = 'content'
             AND ans.uri = 'http://www.alfresco.org/model/content/1.0'
             AND anp.qname_id IN (SELECT id
                                  FROM alf_qname
                                  WHERE local_name = 'name')) AS tt
GROUP BY tt.extension
ORDER BY 2 DESC
LIMIT 5;
{% endhighlight sql %}

Which would give following result:

{% highlight bash %}
+-----------+----------------+
| extension | count(tt.name) |
+-----------+----------------+
| pdf       |          20584 |
| odt       |           6447 |
| jpg       |           1214 |
| xml       |           1024 |
| ods       |            782 |
+-----------+----------------+
5 rows in set (5.25 sec)
{% endhighlight bash %}
