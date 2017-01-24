---
layout: post
title:  "Customize drag-and-drop component"
date:   2015-03-05 16:23:45
comments: true
categories:
description: Probably you even didn't have enough time to have a look on pop-up window because in case of successful upload it immediately hides. Which is quite sad because it could show a bit more to the user than just a status of upload. I will show how to improve this component and get a bit more from it. This article is split in two parts. This one covers the UI changes. The second one will show how to extend functionality of upload webscript. I'll post a link to it here when it would be written.
tags: 
- alfresco
---

Out of the box drag-and drop component is quite nice. But I had a strong feeling that it could be a bit nicer. Here is the things which I want to show how to improve:

* Add some info about uploaded document. It could be a folder where it went, link to the uploaded file or something else. In case of exception could be useful (since usually error message is quite big for such small window) to shrink it a bit.
* Don't hide window when documents uploaded successfully. 
* Customize colors. Of course it is a matter of personal taste, but some users complained that original colors which are shown during the upload procedure are a bit misleading. When document is uploading the color of status bar is dark green, but when it's uploaded the status bar becomes light green which psychologically feels less confident. Would be nice to swap then, so that while document is uploading the status bar is light green and when it finished it becomes a dark green.

Here I will show how to implement last two goals, regarding the first one it worth to write a separate article, since it is quite tricky to do. I'll post link to it here when I write it.

So let's start.

## Customize colors

The easiest one is to change colors. You should add your custom .css file to the upload folder _/src/main/resources/META-INF/components/upload/_. Let's name it `dnd-upload-custom.css`. If you check the original file - `dnd-upload.css` you'll notice that names of classes we are interesting in are `fileupload-progressSuccess-span` and `fileupload-progressFinished-span`. So let's swap them in just created files:

{% highlight css %}
.dnd-upload .fileupload-center-div .fileupload-progressSuccess-span
{
  background-color: #DCECCC;
}

.dnd-upload .fileupload-center-div .fileupload-progressFinished-span
{
  background-color: #9AC68C;
}
{% endhighlight css%}

To include this file in alfresco copy-paste `dnd-upload.html.ftl` to _src/main/amp/config/alfresco/web-extension/site-webscripts/org/alfresco/components/upload/_ and add to it css dependency:

{% highlight xml %}
<@markup id="css" >
<#-- CSS Dependencies -->
  <@link href="${url.context}/res/components/upload/dnd-upload.css" group="upload"/>
  <@link href="${url.context}/res/components/upload/dnd-upload-custom.css" group="upload"/>
</@>
{% endhighlight xml %}

Done!

## Do not hide window after successful upload

Copy-paste `dnd-upload.js` to upload folder _/src/main/resources/META-INF/components/upload/_ and check the `_adjustGuiIfFinished` function. There is an if statement which should be commented.

{% highlight javascript %}
if (objComplete.failed.length === 0){
  this.onCancelOkButtonClick();
}
{% endhighlight javascript %}

Done!

