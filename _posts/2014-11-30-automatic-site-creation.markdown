---
layout: post
title:  "Automatic site creation"
date:   2014-11-30 16:48:45
categories:
description: In this post is described how to create an alfresco sites using simple webscript.
tags: 
- alfresco
---

Usually when you develop some new features for Alfresco you need to completely clean the project. Which is not so good since you will loose all manually created things such us users or sites. In case of users you can integrate Alfresco with () But for sites it could be quite complicated to manually recreate them, especially when you have more than 5 sites. In this post I'd like to show how to create sites automatically when Alfresco starts. So that you could be sure that your sites are in place.

I found few tutorials on how to do this, but some of them were too complicated, some just didn't work. First thing which probably could do the work is `siteService`. But the problem with it that it only creates site on Alfresco side. So you won't be able to use it on share. Another approach which worked for me is to use `create-site` webscript. It is a POST webscript, so you'll need to pass all the site parameters to it. Since I know the site names and types already I can just call this webscript from another one, in which I have all the site parameters hardcoded. 

## Create a webscript description:

{% highlight xml%}
<webscript>
  <shortname>Sites creation</shortname>
  <description>This webscript creates sites</description>
  <url>/org/init/create-sites</url>
  <authentication>admin</authentication>
  <lifecycle>draft_public_api</lifecycle>
</webscript>
{% endhighlight xml%}

## Implement the webscript. 

{% highlight java %}
try {
  HttpClient client = new HttpClient();

  JSONObject someSite = new JSONObject();
  someSite.put("visibility", "PUBLIC");
  someSite.put("title", "somenewsite");
  someSite.put("shortName", "somenewsite");
  someSite.put("description", "somenewsite");
  someSite.put("sitePreset", "site-dashboard");

  JSONObject anotherSite = new JSONObject();
  anotherSite.put("visibility", "PUBLIC");
  anotherSite.put("title", "Another Site");
  anotherSite.put("shortName", "anotherSite");
  anotherSite.put("description", "Autmatically created Site");
  anotherSite.put("sitePreset", "site-dashboard");

  makePostCall(client, CREATE_SITE_URL, someSite.toString(), CONTENT_TYPE_JSON, "Login");
  makePostCall(client, CREATE_SITE_URL, anotherSite.toString(), CONTENT_TYPE_JSON, "Create 1st site");
  makePostCall(client, CREATE_SITE_URL, anotherSite.toString(), CONTENT_TYPE_JSON, "Create 2nd site");
} catch (Exception e) {
  e.printStackTrace();
}
{% endhighlight java %}

## Create a webscript description file:

{% highlight xml %}
<webscript>
  <shortname>Sites creation</shortname>
  <description>This webscript creates sites</description>
  <url>/org/init/create-sites</url>
  <authentication>admin</authentication>
  <lifecycle>draft_public_api</lifecycle>
</webscript>
{% endhighlight xml %}

Done! So now you'll just need to run the webscript by going to [http://localhost:8080/alfresco/service/org/init/create-sites](http://localhost:8080/alfresco/service/org/init/create-sites) and your site is created. 

## Few problems

You will also need to disable CSRFPolicy in your share-config-custom.xml. I disabled it completely for test reason. But ideally would be to disable it for webscripts. Please refer to this article [Introducing the CSRFPolicy in Alfresco Share].

{% highlight xml %}
<config evaluator="string-compare" condition="CSRFPolicy" replace="true">
  <filter/>
</config>
{% endhighlight xml %}

For the moment there is one problem with this method which I still cannot resolve. For some reason the first post reqest of site creation is ignored. So in my example only one site will be created.

Working project you can find on my [github].

[Introducing the CSRFPolicy in Alfresco Share]: http://blogs.alfresco.com/wp/ewinlof/2013/03/11/introducing-the-new-csrf-filter-in-alfresco-share/
[github]: https://github.com/streetturtle/Alfresco/tree/master/AutomaticSiteCreation
