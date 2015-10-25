---
layout: post
title: "CMIS path query"
date: 2015-10-25 16:25:06
comments: true
tags: 
 - CMIS
 - alfresco
description: Query for path in CMIS is quite powerful tool to get folders/documents from repository. Here is some useful examples/tricks.   
comments: true
---

## Search by path

Search by path is very convenient, you can return all documents/folders from folder:

{% highlight sql %}
select * 
from cmis:document 
where contains('PATH:\"/app:company_home/st:sites/cm:MySite/cm:documentLibrary/cm:MyFolder/*"')
{% endhighlight sql%}

Or if you have something similar to the following structure:

{% highlight bash %}
MySite
├── MyFolder1
│   ├── Document1.pdf
│   ├── Document2.pdf
│   └── Document3.pdf
├── MyFolder2
│   ├── Document4.pdf
│   ├── Document5.pdf
│   └── Document6.pdf
└── MyFolder3
    ├── Document7.pdf
    └── Document8.pdf
{% endhighlight bash %}

and want to get all documents from those 3 folders, you can easily skip them by replacing their names with `*`:

{% highlight sql %}
select * 
from cmis:document 
where contains('PATH:\"/app:company_home/st:sites/cm:documentLibrary/cm:MySite/*/*"')
{% endhighlight sql%}

## How to test

Sometimes it is needed to run/test some query before putting it in code. Alfresco provides very convenient tool for that - Node Browser (in Admin Tools window). But there is limit on how many results it can return. In case your query returns more you can use following GET webscript, changing `maxResults` parameter:

{% highlight bash %}
https://localhost:8080/share/proxy/alfresco/slingshot/node/search?q=query&lang=cmis-alfresco&store=workspace%3A%2F%2FSpacesStore&maxResults=1000
{% endhighlight bash %}

## Space and other special character problem

The tricky part here is when you have space in your folder name. Running query without escaping it (for example for 'My Folder') will bring following exception:

{% highlight java %}
ERROR [solr.core.SolrCore] [http-bio-8080-exec-7] org.apache.solr.common.SolrException: org.apache.solr.search.SyntaxError: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'Folder'
	...
Caused by: org.apache.solr.search.SyntaxError: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'Folder'
	...
Caused by: org.apache.lucene.queryparser.classic.ParseException: Failed to parse XPath...
Unexpected 'Folder'
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
