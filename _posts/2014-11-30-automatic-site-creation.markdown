---
layout: post
title:  "Automatic site creation"
date:   2014-11-30 16:48:45
comments: true
categories:
description: During development I quite often purge Alfresco database and after each purge I need to manually recreate all the content that has been deleted such as sites, peoples, folders and so on. In this post I'd like to show how to create sites automatically with a simple webscript.
tags: 
- alfresco
---

Usually when you develop some new features for Alfresco quite often you need to completely clean the project and purge database. Which is not so good since you will loose all manually created things such us folders, users or sites. With sites it could be quite complicate to manually recreate them. In this post I'll to show how to create sites automatically using webscript. So instead of creating sites one by one, manually insert names and privacy settings you'll just need to call a webscript. And also with this method you could be sure that all your sites are in place.

I found few tutorials on how to do this, but some of them were too complicated, some just didn't work. First thing which probably could do the work is `siteService` in repo project. But the problem with it that it only creates site on repo side. So share wouldn't know anything about it. Another approach which worked for me is to use `create-site` webscript. It is a POST webscript, so you'll need to pass all the site parameters to it. 

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
  String createSiteUrl = UrlUtil.getShareUrl(sysAdminParams) + "/service/modules/create-site";

  JSONObject site1 = prepareSite("someTitle", "someShortName", "someDescription", "site-dashboard");
  JSONObject site2 = prepareSite("anotherTitle", "anotherShortName", "anotherDescription", "site-dashboard");

  // Login to share
  String loginUrl = UrlUtil.getShareUrl(sysAdminParams) + "/page/dologin";
  String adminUserName = AuthenticationUtil.getAdminUserName();
  makePostCall(client, loginUrl, "username=" + adminUserName + "&password=" + ADMIN_PASSWORD, CONTENT_TYPE_FORM);

  // Create sites
  makePostCall(client, createSiteUrl, site1.toString(), CONTENT_TYPE_JSON, getToken(client));
  makePostCall(client, createSiteUrl, site2.toString(), CONTENT_TYPE_JSON, getToken(client));
      
} catch (Exception e) {
  e.printStackTrace();
}
{% endhighlight java %}

## CSRF Policy

In the latest versions of Alfresco (4+ versions) developers introduced CSRF Policy, more details here: [Introducing the CSRFPolicy in Alfresco Share]. For this site creation method it means that you'll need to pass one more parameter in post request header which you can get from `HTTPClient` after login. 

{% highlight java %}
private String getToken(HttpClient client) throws UnsupportedEncodingException{
  Cookie[] cookies = client.getState().getCookies();
  for (Cookie cookie : cookies){
    if (cookie.getName().equals("Alfresco-CSRFToken")){
      return URLDecoder.decode(cookie.getValue(), "UTF-8");
    }
  }
  return null;
}
{% endhighlight java %}

Please also notice that token you get is encoded, so you need to decode it:

{% highlight java %}
URLDecoder.decode(cookie.getValue(), "UTF-8");
{% endhighlight java %}

Done! So now you'll just need to run the webscript by going to [http://localhost:8080/alfresco/service/org/init/create-sites](http://localhost:8080/alfresco/service/org/init/create-sites) and your site is created. 

## Some problems

For the moment there is one problem with this method which I still cannot resolve. For some reason the first post request of site creation is ignored. So in my example only one site will be created.

Working project you can find on my [github].

[Introducing the CSRFPolicy in Alfresco Share]: http://blogs.alfresco.com/wp/ewinlof/2013/03/11/introducing-the-new-csrf-filter-in-alfresco-share/
[github]: https://github.com/streetturtle/Alfresco/tree/master/AutomaticSiteCreation
