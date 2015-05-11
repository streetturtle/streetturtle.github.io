---
layout: post
title:  "Some useful Alfresco queries"
date:   2015-05-01 16:23:45
comments: true
categories:
description: I would like to share some of SQL queries for Alfresco database which could be useful.
tags: 
- alfresco
- database
---

## Why you may use SQL queries

The proper way to get information about your repo would be to create a Java or javascript webscript. To get info about documents you'll need to use [CMIS](http://docs.alfresco.com/4.2/concepts/intrans-metadata-query.html) query language in it. But sometimes more convenient way is to use SQL. For example in the project I'm working on we use [AppDynamics](https://www.appdynamics.com/) for monitoring. For one of the dashboards we would like to have a document counter and for AppDynamics it's more convenient to get a result from database rather than response from an Alfresco webscipt. So here we go!

First we need to connect to Alfresco database. You can refer to this post to do it: [Connect to alfresco database]({{ site.url }}/2015/02/13/connect-to-alfresco-db/).

## Total number of documents in repository

This query will return number of nodes which have _cm:content_ type:

{% highlight sql%}
select count(*) as cm_content_nodes
from alf_node nd, alf_qname qn, alf_namespace ns
where qn.ns_id = ns.id
  and nd.type_qname_id = qn.id
  and ns.uri = 'http://www.alfresco.org/model/content/1.0'
  and qn.local_name = 'content';
{% endhighlight sql%}

To get number of folders (which have _cm:folder_ type) replace `content` by `folder`. To see all available types run following queries:

{% highlight sql%}
select * from alf_namespace; -- namespaces
select * from alf_qname;     -- qnames
{% endhighlight sql%}

For custom types change qname and namespace.

## Document name - creator - date

This one will return human readable document name, username of creator and date when this document was created:

{% highlight sql %}
select nd.audit_creator as creator, np.string_value as document_name, nd.audit_created as created_on
from alf_node as nd, alf_node_properties as np, alf_namespace ns, alf_qname qn
where nd.id=np.node_id
and qn.ns_id = ns.id
and nd.type_qname_id = qn.id
and ns.uri = 'http://www.alfresco.org/model/content/1.0'
and qn.local_name = 'content'
and np.qname_id = 29
and nd.audit_created > '2015-05-06 14:59:00';
{% endhighlight sql %}

## Number of uploaded documents per person

This query returns list of users and number of documents uploaded by them:

{% highlight sql%}
select audit_creator as uploaded_by, count(*) as doc_uploads
from alf_node nd, alf_qname qn, alf_namespace ns
where qn.ns_id = ns.id
  and nd.type_qname_id = qn.id
  and ns.uri = 'http://www.alfresco.org/model/content/1.0'
  and qn.local_name = 'content'
group by audit_creator;
{% endhighlight sql%}

## Number of users

Total number of nodes with type `person` which is basically number of users:

{% highlight sql%}
select count(*)
from alf_node nd, alf_qname qn
where nd.type_qname_id = qn.id
  and qn.local_name = 'person';
{% endhighlight sql%}

## List of users

This query returns list of users from the Alfresco database:

{% highlight sql %}
select 
  np1.string_value as first_name, 
  np2.string_value as last_name, 
  np3.string_value as username
from 
  alf_node_properties np1, 
  alf_node_properties np2, 
  alf_node_properties np3
where np1.qname_id in (select id from alf_qname where local_name in ('firstName'))
  and np2.qname_id in (select id from alf_qname where local_name in ('lastName'))
  and np3.qname_id in (select id from alf_qname where local_name in ('userName'))
  and np1.node_id = np2.node_id
  and np1.node_id = np3.node_id
order by 1;
{% endhighlight sql %}

More queries are coming! Stay tuned =)