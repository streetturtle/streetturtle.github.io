---
layout: post
title:  "Customize alfresco footer (Surf)"
date:   2016-02-25 15:23:45
comments: true
description: Alfresco footer appears on every page of application and actually there is not much interesting there - logo, copyright and some links. Let's replace it with your application specific footer!
tags: 
- alfresco
---

# Introduction

Actually Alfresco documentation already has quite good [article](http://docs.alfresco.com/5.0/tasks/dev-extensions-share-tutorials-fm-temp-customize.html) on how to customize footer. But it took me some time to understand it and implement my version of footer, because I am not very familiar with Surf.
What I want to achieve is to remove Alfresco logo because it takes to much space, decrease footer size and add some useful information to it - like version of the deployed application, link to ticket system, version of Alfresco.

Let's see how to achieve following result:
![Custom Alfresco footer]({{site.url}}/images/alfCustomFooter.png)

> Unfortunately this approach doesn't work for pages which are built using Aikau (like Search results page)
{:.note}

# Extension

First thing to do is create **/web-extension/site-data/extensions/mycmpny/efiles/footer/footer.xml** and register extension there:

{% highlight xml %}
<extension>
  <modules>
    <module>
      <id>Customize Web Script Template for Footer</id>
      <version>1.0</version>
      <auto-deploy>true</auto-deploy>
      <customizations>
        <customization>
          <targetPackageRoot>org.alfresco.components.footer</targetPackageRoot>
          <sourcePackageRoot>com.mycmpny.footer</sourcePackageRoot>
        </customization>
      </customizations>
    </module>
  </modules>
</extension>
{% endhighlight xml %}

# Footer

I want to have three column footer displaying:

## copyright

Usually copyright is just a static text, like _MyCmpny &copy; 2013-2016_, but then you need to change the end year every year, since footer implementation is in *.ftl** file let's use some dynamic features. Like getting the current year: `${.now?string.yyyy}` and put it in span:

{% highlight html %}
<span class="copyrightMycmpny">
  <span><a href="http://home.mycmpny" target="_blank">MyCmpny</a> &copy; 2015-${.now?string.yyyy}</span>
</span>
{% endhighlight html %}

## version

Ftl (maybe Spring, not sure) provides access to the maven version of the application with simple `${version}` and also the version of Alfresco which is being used `${alfresco.client.war.version}`:

{% highlight html %}
<span class="version">
  <span>
    <a href="#" onclick="Alfresco.module.getAboutShareInstance().show(); return false;">
      Cool ECM app</a>
    (version ${version}) / 
    <a href="https://www.alfresco.com/">Alfresco</a> ${alfresco.client.war.version}
  </span>
</span>
{% endhighlight html %}

## link to ticket system

It would be just a link with text, but let's add multilanguage support. Add file **/web-extension/site-webscripts/mycmpny/efiles/footer/footer.get_en.properties** with `label.snow=Support is <a href="http://mySupportlink.com"> here`. To get the proper message ftl has `msg()` function which is used like this:

{% highlight html %}
<span class="snow">
  <span>${msg("label.snow")}</span>
</span>
{% endhighlight html %}

Put everything together in **/web-extension/site-webscripts/mycmpny/efiles/footer/footer.get.html.ftl**:

<script src="https://gist.github.com/streetturtle/b8823da9a6db7443fc1e.js"></script>

and style with some css in **src/main/resources/META-INF/components/footer/my-footer.css**:

{% highlight css %}
.snow{
  float: right;
  line-height: 20px;
  width: 33%;
  text-align: right;
  padding-right: 1em;
}
.copyrightMycmpny{
  float: left;
  line-height: 20px;
  padding-left: 1em;
  width: 33%;
  text-align: left;
}
.version{
  line-height: 20px;
  width: 33%;
  text-align: center;
}
.sticky-footer {
  height: 20px;
}
.sticky-wrapper{
  margin-bottom: -20px;
}
{% endhighlight css %}