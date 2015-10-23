---
layout: post
title: "Useful CMIS queries"
date: 2015-10-09 16:25:06 -0700
comments: true
tags: 
 - CMIS
 - alfresco
description: I would like to share some CMIS queries for people (like me) who are not very familiar with CMIS. 
comments: true
---

## Introduction

Sometimes it is needed to run/test some query before putting it in code. Alfresco provides very convenient tool for that - Node Browser (in Admin Tools window).

## Search by path

{% highlight sql linenos %}
select * 
from rma:recordCategory 
where contains('PATH:\"/app:company_home/st:sites/cm:rm/cm:documentLibrary/cm:HR/cm:MyFolder"')
{% endhighlight sql%}

The tricky part here is when you have space in your folder name. Running query without escaping it (for example for 'My Folder') will bring following exception:

{% highlight java %}
ERROR [solr.core.SolrCore] [http-bio-8080-exec-7] org.apache.solr.common.SolrException: org.apache.solr.search.SyntaxError: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'Folder'
	...
Caused by: org.apache.solr.search.SyntaxError: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'for_x0020_extraordinary_x0020_service_x0020_PAF'
	...
Caused by: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'for_x0020_extraordinary_x0020_service_x0020_PAF'
	at org.alfresco.solr.query.Solr4QueryParser.getFieldQuery(Solr4QueryParser.java:689)
	at org.alfresco.solr.query.Solr4QueryParser.getFieldQuery(Solr4QueryParser.java:212)
	at org.alfresco.solr.query.Lucene4QueryParserAdaptor.getFieldQuery(Lucene4QueryParserAdaptor.java:233)
	at org.alfresco.solr.query.Lucene4QueryParserAdaptor.getFieldQuery(Lucene4QueryParserAdaptor.java:48)
	at org.alfresco.repo.search.impl.querymodel.impl.lucene.functions.LuceneFTSPhrase.addComponent(LuceneFTSPhrase.java:77)
	at org.alfresco.repo.search.impl.querymodel.impl.lucene.LuceneFunctionalConstraint.addComponent(LuceneFunctionalConstraint.java:57)
	at org.alfresco.repo.search.impl.querymodel.impl.lucene.LuceneQuery.buildQuery(LuceneQuery.java:105)
	at org.alfresco.solr.AlfrescoSolrDataModel.getCMISQuery(AlfrescoSolrDataModel.java:2001)
	at org.alfresco.solr.query.CmisQParserPlugin$CmisQParser.parse(CmisQParserPlugin.java:189)
	... 23 more
{% endhighlight java %}

The problem here is that paths are stored in ISO9075 format. It won't affect most alphanumeric strings, but will affect spaces, some strings that starts with numeric characters. So we need to encode it. On Java side there is utility class `org.alfresco.util.ISO9075` which does it:

{% highlight java %}
String query = 
  "select * from rma:recordCategory " +
  "where contains" +
  "('PATH:\"/app:company_home/st:sites/cm:rm/cm:documentLibrary/cm:HR/*/cm:" + ISO9075.encode(folderName) + "\"')";
{% endhighlight java %}

For javascript you can use `ISO9075.encode(folderName)`.

For node browser you can 'encode' spaces manually replacing them by `_x0020_`.
