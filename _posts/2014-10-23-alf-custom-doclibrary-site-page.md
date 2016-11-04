---
layout: post
title:  "Custom document library site page"
date:   2014-10-23 19:17:52
comments: true
description: Here I'll show how to create a custom page for alfresco site which points to some folder inside document library.
categories: jekyll update
tags: 
- alfresco
---

Here I want to explain how to create a custom site page:

![My helpful screenshot]({{ site.url }}/images/MyPersLibrary.jpg){:.center-image}

which points to any folder you want inside your repository. It will have kind of the same behaviour as My Files button. For example let's pretend that each user has it's own folder which name matches the username.

The idea is to copy a document library page and change some components to make them open a folder inside document library. To get the name of this folder we will use a Java-backed webscript which will search for it inside document library and return it's nodeRef. It's as simple as it sounds, but when you do it for the first time it seems quite hard, especially if you are not an Alfresco ninja. We can split the task in three simple steps:

1. Create a custom page. 
2. Create a webscript which returns the NodeRef of the folder.
3. Link page and webscript together.

Let's start.

## Create Page

By default inside any Alfresco site you have three visible pages: Dashboard, Document library, Site members. To create a new page you can use an Alfresco tutorial: [Add a new page to Alfresco Share][add-page-tutorial] or follow these steps. Please don't forget that it should be done in share project. Create following files:

* **Page definition** - /share-amp/src/main/amp/config/alfresco/web-extension/site-data/pages/_my-document-library.xml_

{% highlight xml%}
<page>
  <title>My Document Library</title>
  <title-id>page.myDocLib.title</title-id>
  <description>My Document Library</description>
  <description-id>page.myDocLib.description</description-id>
  <template-instance>my-document-library</template-instance>
  <authentication>user</authentication>
</page>
{% endhighlight xml%}

* **Template-Instance definition** - /share-amp/src/main/amp/config/alfresco/web-extension/site-data/template-instances/_my-document-library.xml_. For the moment you can just copy it from `documentlibrary.xml` template-instance. 

* **FreeMaker template** - /share-amp/src/main/amp/config/alfresco/web-extension/site-data/template/_my-document-library.ftl_.
Copy this one from `documentlibrary.ftl` as well.

At the end the folder structure should look like this:

![My helpful screenshot]({{ site.url }}/images/customPage.png){:.center-image}

That's it! The page is created, you can view it on [http://localhost:8080/share/page/my-document-library](http://localhost:8080/share/page/my-document-library). 

Since we copied templates from documentlibrary it will look exactly the same as Document Library page. But with broken title, which would be something like `page.myDocLib.title`, to fix it update the properties file:

{% highlight properties%}
#My Personal Library
page.myDocLib.title=My Personal Library
{% endhighlight properties%}

But this page is not linked to your site yet. To link it add this part to `share-config-custom.xml`:

{% highlight xml%}
<!-- Add a custom page type -->
<config evaluator="string-compare" condition="SitePages">
  <pages>
    <page id="my-document-library">my-document-library</page>
  </pages>
</config>
{% endhighlight xml%}

And then on site-customization page just drag and drop created page from Available Site Pages to Current Site Pages.

First step is done!

## Create Java-Backed WebScript

Please have a look [Alfresco-wiki page][webscript-wiki] for more information about webscripts.

This WebScript will be called by created page and return the nodeRef of the folder which name is the same as the username of logged user.

First we need to create a webscript description file: /repo-amp/src/main/amp/config/alfresco/extension/templates/webscripts/getUserNodeRefWS.get.desc.xml with following content:

{% highlight xml%}
<webscript>
  <shortname>Returns nodeRef of some folder</shortname>
  <description>Returns nodeRef of some folder</description>
  <format default="json"/>
  <lifecycle>draft_public_api</lifecycle>
  <url>/api/mywebscript/getnoderef?username={username}</url>
  <authentication>user</authentication>
</webscript>
{% endhighlight xml%}

Java. Create GetUserNodeRefWS.java class under /repo-amp/src/main/java/org/alfresco/webscript/. The whole class you can find on gitHub, here I'll just write the main method which does all the work:

{% highlight java %}
public void execute(WebScriptRequest req, WebScriptResponse res) {
  JSONObject json = new JSONObject();
  String userName = req.getParameter("username");
  NodeRef documentLibrary = siteService.getContainer("somesite", "documentlibrary");

  try  {
    if ("admin".equals(userName))
      json.put("nodeRef", documentLibrary.toString());
    else  {
      NodeRef userNodeRef = fileFolderService.searchSimple(documentLibrary, userName);
      json.put("nodeRef", userNodeRef.toString());
    }
    res.getWriter().write(json.toString());
  }
  catch (Exception e) {
    throw new WebScriptException("Unexpected exception", e);
  }
}
{% endhighlight java %}

And now let's add some Spring magic which will link your class with the webscript. In `service-context.xml` add a new bean:

{% highlight xml %}
<bean id="webscript.getNodeRef.get" class="org.alfresco.mywebscript.GetNodeRef" parent="webscript">
</bean>
{% endhighlight xml %}

Now you can test the webscript, just go to  http://localhost:8080/alfresco/s/api/mywebscript/getnoderef?param=admin and you should have a response with a nodeRef. Don't forget to create the folders inside site's document library otherwise you'll have an exception.

## Link Page and webscript together

To link them we need to rewrite *myfiles* component. This component will call a webscript and show the folder with nodeRef which webscript returned.

Copy following files:

* myFiles.get.desc.xml
* myFiles.get.html.ftl
* myFiles.get.js

to the **site-webscripts/components/myDocumentLibrary** folder and rename them to `myDocumentLibrary`.

 Now let's change them a bit.

* **myDocumentLibrary.get.desc.xml** - url refers to the component name:

{% highlight xml %}
<webscript>
  <shortname>My Document Library</shortname>
  <description>My Document Library</description>
  <url>/components/myDocumentLibrary/myDocumentLibrary</url>
</webscript>
{% endhighlight xml %}

* **myDocumentLibrary.get.html.ftl** - modify imports:

{% highlight xml %}
<#include "/org/alfresco/components/documentlibrary/include/documentlist_v2.lib.ftl" />
<#include "/org/alfresco/components/form/form.dependencies.inc">
{% endhighlight xml %}

* **myDocumentLibrary.get.js** - add a method which will call a webscript:

{% highlight javascript %}
function callWS(wsParamValue){
  wsParamValue = eval(wsParamValue);
  var url = "/api/mywebscript/getnoderef?param=" + wsParamValue;
  var result = remote.call(url);

  if (result.status == 200)  {
    var obj = eval('(' + result + ')');
  } else {
    status.setCode(result.status);
  }
  return obj.nodeRef;
}
{% endhighlight javascript %}

And pass it's value to the rootNode variable in the beginning of the file, which then pass to the docListToolbar and documentList constructors:

{% highlight javascript %}
var rootNode = callWS(user.name);
{% endhighlight javascript %}

The last step is to modify the widget call so that it will call a new one. In the template-instance created on the first step change the documentlist_v2 component:

{% highlight xml%}
<component>
  <region-id>documentlist_v2</region-id>
  <url>/components/myDocumentLibrary/myDocumentLibrary</url>
  <properties>
    <pagination>true</pagination>
    <dependencyGroup>documentlibrary</dependencyGroup>
  </properties>
</component>
{% endhighlight xml%}

And that's it! The whole project you can find on the [github].

Cheers!

[add-page-tutorial]: http://docs.alfresco.com/4.1/tasks/tutorial-share-add-page.html
[webscript-wiki]: https://wiki.alfresco.com/wiki/Web_Scripts
[github]: https://github.com/streetturtle/Alfresco/tree/master/PageSiteExample
