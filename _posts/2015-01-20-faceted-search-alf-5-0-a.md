---
layout: post
title:  "Custom facets in alfresco 5.0.a"
date:   2015-01-20 9:53:52
comments: true
description: Alfresco 5.0.a is the first version with faceted search support. By default it supports 7 facets. Here I'll show how to add custom facets on custom metadata.
categories: 
tags: 
- alfresco
---

In the project I'm working on I had a task to add custom facets to the search. Since version 5.0.a is the first one which supports faceted search the support for custom facets wasn't there, at least I couldn't find it. It seems that in further version of alfresco it is in place, but in the project I'm working on we had a strict requirement to use 5.0.a version. The solution I discovered is a bit "dirty" because instead of overriding the facet configuration component using aikau framework I just overwritten it. Another negative point is that it probably won't work with further Alfresco versions, so you'll need to update the code. But hopefully adding new facets would be easier in latest versions so this change won't be to big.
Let's start!
All the changes are done in share project.

## Register extension

Create file: `/web-extension/site-data/extensions/com/yourcomp/faceted-search-custom.xml` file with following context:

{% highlight xml %}
<extension>
  <modules>
    <module>
      <id>EP faceted search</id>
      <auto-deploy>true</auto-deploy>
      <version>1.0</version>
      <customizations>
        <customization>
          <targetPackageRoot>
            org.alfresco.share.pages.faceted-search
          </targetPackageRoot>
          <sourcePackageRoot>
            com.yourcomp.pages.faceted-search
          </sourcePackageRoot>
        </customization>
      </customizations>
    </module>
  </modules>
</extension>
{% endhighlight xml %}

Please note that `<auto-deploy>true</auto-deploy>` allows to automatically deploy created module instead of manually deploy it each time after you purge database.

##Extension implementation##

Next step is overwrite `faceted-search.get.js`. Copy it to `web-extension/site-webscripts/com/yourcomp/pages/faceted-search/` and scroll down to ~120 line where the `facets` array is constructed. Feels free to remove some facets or to add new ones, in my case I added custom metadata field, which refers to the type of document:

{% highlight javascript %}
...
id: "FCTSRCH_FACET_DOCUMENT_TYPE",
    name: "alfresco/search/FacetFilters",
    config: {
      label: "Document Type",
      facetQName: "{http://www.mycompname.com/model/efiles/1.0}typeName.__.u",
      sortBy: "ALPHABETICALLY",
      hitThreshold: 1,
      minFilterValueLength: 5,
      maxFilters: 10,
      useHash: false
    }
...
{% endhighlight javascript %}

To check the config parameters refer to the documentation: [FacetFilters config parameters].

In my case the document type name is several words split by space. To make solr search for the whole phrase and create whole prhase facet you need to add this part `.__.u` to the facet Qname. And also make sure that tokenised in the content model is set to `false` or `both`, so that the string is not tokenised before being indexed:

{% highlight xml %}
<property name="ef:typeName">
  <type>d:mltext</type>
  <mandatory>true</mandatory>
  <index enabled="true">
    <atomic>true</atomic>
    <stored>false</stored>
    <tokenised>both</tokenised>
  </index>
</property>
{% endhighlight xml %}

[FacetFilters config parameters]: http://dev.alfresco.com/resource/docs/jsdoc-haiku/FacetFilters.html