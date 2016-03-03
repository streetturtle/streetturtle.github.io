---
layout: post
title:  "Customize alfresco footer (Aikau)"
date:   2016-02-28 10:23:45
comments: true
description: Here I'm showing how to change footer for pages created with Aikau framework, like Search result page.
tags: 
- alfresco
---

# Introduction

In my previous post I've shown how to change footer for pages made without Aikau, but since I am using Alfresco 5.0.c, footer haven't changed on search result page.
Let's change it! The idea is to make it as it is in my previous [post]({{site.url}}/2016/02/customize-alfresco-footer/) (3 columns: copyright, application version and link to the ticket system):

![Custom Alfresco footer]({{site.url}}/images/alfCustomFooter.png)

# Extension

First of all let's register extension module which will add new packages:

>widget-extension.xml
{:.filename}
{% highlight xml %}
<extension>
  <modules>
    <module>
      <id>My custom widgets</id>
      <version>1.0</version>
      <auto-deploy>true</auto-deploy>
      <configurations>
        <config evaluator="string-compare" condition="WebFramework" replace="false">
          <web-framework>
            <dojo-pages>
              <packages>
                <package name="mycmpny" location="js/mycmpny"/>
              </packages>
            </dojo-pages>
          </web-framework>
        </config>
      </configurations>
    </module>
  </modules>
</extension>
{% endhighlight xml %}

# Footer

The idea of the customization is similar to the one in this article: [Aikau Mini Examples – Data List (part 1)](https://www.alfresco.com/blogs/developer/2014/09/30/aikau-mini-examples-data-list-part-1/). We will take Alfresco footer and override some fields. Before doing it I would suggest to spend few minutes and check **AlfShareFooter.js**. Actually it seems quite easy, we need to change footer template, css, add i18n files and add some custom variables, like already existing `copyrightLabel` or `licenseLabel`.

## Template

Template looks similar to the one for surf, except some ftl features. Current year (`currentYear`) and ticket message (`snowLabel`) will be added by js component later and application version (`version`) will work without any changes needed. Also we need to add [attach point](https://dojotoolkit.org/documentation/tutorials/1.6/templated/) - `footerParentNode` to the wrapper div:

{% highlight html %}
<div class="alfresco-footer-AlfShareFooter" data-dojo-attach-point="footerParentNode">
  <span class="copyrightMycmpny">
    <span><a href="http://home.mycmpny" target="_blank">MyCmpny</a> &copy; 2015-${currentYear}</span>
  </span>

  <span class="snow">
    <span>${snowLabel}</span>
  </span>

  <span class="version">
    <span>
      <a href="#" onclick="Alfresco.module.getAboutShareInstance().show(); return false;">
      Cool ECM app</a> (version ${version}) / 
    <a href="https://www.alfresco.com/">Alfresco</a> ${alfresco.client.war.version}
  </span>
</div>
{% endhighlight html %}

Put this snippet in **/resources/META-INF/js/mycmpny/footer/templates/my-footer.html**

## CSS

CSS style is almost the same as for the old footer except `.sticky-wraper` class should be renamed to `.wrapper`. Copy file from previous post and put it in **/footer/css/my-footer.css**

## i18n

Files are the same as for surf footer, should be in **/footer/i18n/myFooter.properties**. To add french language for example, add **myFooter_fr.properties** in the same folder.

## Widget

Finally widget, create **/footer/MyFooter.js** with following content, I think it's quite easy to understand what's happening here - we take existing widget `AlfShareFooter`, add css and i18n and in `postMixInProperties` override `templateString` and add some custom variables which are used in the template:

{% highlight javascript linenos %}
define(["dojo/_base/declare",
        "dojo/text!./templates/my-footer.html",
        "alfresco/footer/AlfShareFooter"],
       function (declare, template, AlfShareFooter) {
         return declare([AlfShareFooter],{
           cssRequirements: [{cssFile:"./css/my-footer.css"}],
           i18nRequirements: [{i18nFile: "./i18n/MyFooter.properties"}],

           postMixInProperties: function my_footer_AlfShareFooter__postMixInProperties(){
             this.inherited(arguments);
             this.templateString = template;
             this.snowLabel = this.message(this.snowLabel);
           }
         });
       });
{% endhighlight javascript %}

After these steps you'll have following folder structure which basically represents the widget:

{% highlight bash %}
js
└── mycmpny
    └── footer
        ├── MyFooter.js
        ├── css
        │   └── my-footer.css
        ├── i18n
        │   ├── myFooter.properties
        │   └── myFooter_fr.properties
        └── templates
            └── my-footer.html
{% endhighlight bash %}

# Add widget to the page

This is the usual step of changing widgets. Add these lines in **faceted-search.get.js** which should be somewhere like **/web-extension/site-webscripts/mycmpny/pages/faceted-search/faceted-search.get.js**:

{% highlight javascript %}
var footer = widgetUtils.findObject(model.jsonModel, "id", "ALF_STICKY_FOOTER");

footer.config.widgetsForFooter = [{
  name: "mycmpny/footer/MyFooter", config: {
    semanticWrapper: "footer",
    currentYear: new Date().getFullYear(),
    snowLabel: "label.snow"
  }
}];
{% endhighlight javascript %}

And after restart it should work! In case of any question don't hesitate to left a comment ;)