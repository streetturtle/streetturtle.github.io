---
layout: post
title:  "Alfresco custom document library site page"
date:   2014-10-23 19:17:52
description: Here I'll show how to create a custom page for alfresco site which points on some folder inside document library.
categories: jekyll update
---

Here I want to explain how to create a custom page for a site which points to any folder you want inside your repository. It will have kind of the same bejaviour as My Files button, but more intelligent =). For example let's pretend that inside site's document library each user has a user's folder which name matches the user's name.

The idea is to create a custom site page with the same components as the document library site, but with widgets which call a Java-backed WebScript to search for a specific folder inside repository. It's as simple as it sounds, but when you do it for the first time it seems quite hard, especially when you are not an Alfresco ninja. We can split the task in three simple steps:

1. Create a custom page. 
2. Create a webscript which returns the NodeRef of the folder.
3. Link Page and webscript together.

Let's start.

## Create Page

By default inside any Alfresco site you have three pages: Dashboard, Document library, Site members. To create a new page you can use this Alfresco tutorial: [Add a new page to Alfresco Share][add-page-tutorial] or follow this steps. Please don't forget that these steps should be done in share project. Create these files:

* **Page definition** - /alfresco/web-extension/site-data/pages/_my-document-library.xml_

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

* **Template-Instance definition** - /alfresco/web-extension/site-data/template-instances/_my-document-library.xml_. For the moment you can just copy it from `documentlibrary.xml` template-instance. 

* **FreeMaker template** - /alfresco/web-extension/site-data/template/my-document-library.ftl.
Copy this one from `documentlibrary.ftl` as well.

That's it! The page is created, you can view it on http://localhost:8081/share/page/my-document-library. Since we copied templates from documentlibrary it will look exactly the same as Document Library page. But with broken title, which would be something like `page.myDocLib.title`, to fix it update the properties:

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

And then from site-customization page just drag and drop created page from Availabe Site Pages to Current Site Pages.

First step is done!

## Create Java-Backed WebScript

Please have a look [Alfresco-wiki page][webscript-wiki] for more information about webscripts.

This WebScript will search for the folder you are looking for and return it's nodeRef.

First we need to create a webscript description file. Let's call the webscript getNodeRef.

{% highlight xml%}
<webscript>
  <shortname>Returns nodeRef of the folder</shortname>
  <description>Returns nodeRef of some folder</description>
  <format default="json"/>
  <lifecycle>draft_public_api</lifecycle>
  <url>/api/mywebscript/getnoderef?username={username}</url>
  <authentication>user</authentication>
</webscript>
{% endhighlight xml%}

Finally Java. Create GetNodeRef class in /src/main/java/org/alfresco/mywebscript/. The whole class you can find on gitHub, here I'll write just the main method which do all the work:

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

And let's add some Spring magic which will link your class with webscript. In `service-context.xml` add new bean:

{% highlight xml %}
<bean id="webscript.getNodeRef.get" class="org.alfresco.mywebscript.GetNodeRef" parent="webscript">
  <property name="serviceRegistry" ref="ServiceRegistry"/>
</bean>
{% endhighlight xml %}

Now you can test webscript, just go to  http://localhost:8080/alfresco/s/api/mywebscript/getnoderef?param=admin and you should have a response with a nodeRef. Please don't forget to create the folders inside site's document library.

## Link Page and webscript together

To link them we need to rewrite myfiles component. This component will call a webscript and show the folder with nodeRef which webscript returned.

Copy following files:

* myfiles.get.desc.xml
* myfiles.get.html.ftl
* myfiles.get.js

to the **site-webscripts/components/myDocumentLibrary** folder and rename them to *myDocumentLibrary* for example.

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

* **myDocumentLibrary.get.js**

Add a method which will call a webscript.

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

The last step is to modify the widget, so that it will call a new one. In the template-instance, created on the first step change the documentlist_v2 component:

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

And that's it! The whole project you can find on the github.

Cheers!

[add-page-tutorial]: http://docs.alfresco.com/4.1/tasks/tutorial-share-add-page.html
[webscript-wiki]: https://wiki.alfresco.com/wiki/Web_Scripts