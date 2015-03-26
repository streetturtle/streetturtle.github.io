---
layout: post
title:  "Customize drag-and-drop component"
date:   2015-03-05 16:23:45
categories:
description: Probably you even didn't have enough time to have a look on pop-up window because in case of successfull upload it immediately hides. Which is quite sad because it could show a bit more to the user than just a status of upload. I will show how to improve this component and get a bit more from it. This article is split in two parts. This one covers the UI changes. The second one will show how to extend functionality of upload webscript. I'll post a link to it here when it would be written.   
tags: 
- alfresco
- alfresco share
---

Out of the box drag-and drop component is quite nice. But I had a strong feeling that it could be a bit nicer. Here is the things which I want to show how to improve:

* Add some info about uploaded document. It could be a folder where it went, link to the uploaded file or something else. In case of exception could be useful (since usually error message is quite big for such small window) to shrink it a bit.
* Don't hide window when documents uploaded successfully. 
* Increase size of the pop-up window. Since we'll add some info message to each uploaded document it in case of uploading quite a lot of them would be usefull to increase size of the window, to prevent user scroll to much.
* Customize colors. Of course it is a matter of personal taste, but some users complained that original colors which are shown during the upload procedure are a bit misleading. When document is uploading the color of status bar is dark green, but when it's uploaded the status bar becomes light green which psyhologically feels less confident. Would be nice to swap then, so that while document is uploading the status bar is light green and when it finished it becomes a dark green.  

Here I will show how to implement last three goals, regaring the first one it worth to write a separate article, since it is quite tricky to do. I'll post link to it here when I write it.

So let's start.

## Customize colors

The easiest one is to change colors. You should add your custom .css file to the upload folder TODO. Let's name it `dnd-upload-custom.css`. If you check the original file - `dnd-upload.css` you'll notice that names of classes TODO we are interesting in are TODO and TODO. So let's swap them in just created files:

{% highlight css %}
{% endhighlight css%}

To include this file in alfresco copy-paste `dnd-upload.html.ftl` and it to css dependencies:

{% highlight xml %}
asdasdasd
{% endhighlight xml %}

Done!

## Increase window size

It could be done in css. TODO

## Do not hide window after successfull upload

Copy-paste `dnd-upload.js` to upload folder TODO and check the `TODO` function. There is an if statement which should be commented.

{% highlight javascript %}
TODO
{% endhighlight javascript %}

Done!

