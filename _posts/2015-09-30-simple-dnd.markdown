---
layout: post
title:  "Simple DnD file upload without js libraries"
date:   2015-09-30 22:06:45
comments: true
categories:
description: Simple implementation of drag-and-drop component based on basic 'input type="file"' HTML tag without any js libraries. 
tags: 
- html
- css
---

{% include dndCSS.html %}

## Introduction

For one of the projects I was working on I needed to have drag-and-drop component, but ideally without using any js libraries. I discovered that default html tag for uploading files (`<input type="file">`) supports drag-and-drop action. So if you drag file and drop it into this element it will be uploaded. Unfortunately this feature doesn't work in Internet Explorer. So idea is to change this component so it would look like dnd component in Chrome and Firefox and look like default component in IE. So let's start.

Create `<input type="file">` element like this:

{% highlight html %}
<div>
 <form>
    <input type="file">
  </form>
</div>
{% endhighlight html %}

Which will look like following way by default:

<div>
 <form>
    <input type="file">
  </form>
</div>

Now let's play with css. The idea is to 
 
 - set size of div - it will be the size of upload area;
 - increase the area of input element by increasing padding, it should cover whole parent div; 
 - make this input invisible;
 - add label on top.

Implementing these rules in following html:

{% highlight html %}
<div style="margin-top: 20px">
  <div id="dnd-container">
    <span id="dnd-label">Drag & Drop File Here</span>
    <form id="dnd-form">
      <input type="file" id="dnd-input">
    </form>
  </div>
</div>
{% endhighlight html %}

and css:

{% highlight css %}
#dnd-input{
  filter: alpha(opacity=0);      /* hides input */
  opacity: 0;                    /* hides input */
  padding: 25px 26px 25px 26px;  /* 'increases' input area */
  cursor: pointer;               /* cursor: pointer :) */
}
#dnd-container{  
  border: 2px dashed #333;       /* border */
  -webkit-border-radius: 10px;   /* radius - safari, chrome */
  -moz-border-radius: 10px;      /* radius - firefox */
  border-radius: 10px;           /* radius */
  text-align: center;            /* aligns label */ 
  font-size: 20px;               /* size of a label */
  background-color: #999;        /* background color */
  width: 60%;                    /* width of a upload area */
  margin: 0 auto;                /* centers the upload div */
}  
#dnd-label{  
  position: relative;            /* allows moving span */
  top: 25px;                     /* moves span */
  display: block;                /* allows apply height attr. */
  height: 0;                     /* makes span sizeless */
}  
#dnd-form{  
  margin:0;                      /* removes margins */
}
{% endhighlight css %}

We'll have this element - which supports drag&drop upload as well as uploading by clicking on it:

<style type="text/css">
  #dndUploadLbl{display: none }
  #file-upload-input{
    filter: alpha(opacity=100);
    opacity: 1;
    padding: 5px 10px 5px 10px;
  }
  #attachment-note{
    padding: 10px 0px 10px 0px;
  }
</style>

<!-- IE 10, 11 -->
<style type="text/css">
  @media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {
    #dndUploadLbl {display: none}
    #file-upload-input{
      filter: alpha(opacity=100);
      opacity: 1;
      padding: 5px 10px 5px 10px;
    }
    #attachment-note{
      padding: 10px 0px 10px 0px;
    }
  }
</style>

<div style="margin-top: 20px">
  <div id="dnd-container">
    <span id="dnd-label">Drag & Drop File Here</span>
    <form id="dnd-form">
      <input id="dnd-input" type="file">
    </form>
  </div>
</div>

## Internet Explorer

In IE dnd functionality is not supported by browser, so for IE we can just leave the default element by providing different css style. To do so here is conditional comments where this can be specified:

{% highlight html %}
<!-- IE 7, 8, 9 -->
<!--[if IE]>
<style type="text/css">
  #dndUploadLbl{display: none }
  #file-upload-input{
    filter: alpha(opacity=100);
    opacity: 1;
    padding: 5px 10px 5px 10px;
  }
  #attachment-note{
    padding: 10px 0px 10px 0px;
  }
</style>
<![endif]-->

<!-- IE 10, 11 -->
<style type="text/css">
  @media all and (-ms-high-contrast: none), (-ms-high-contrast: active) {
    #dndUploadLbl {display: none}
    #file-upload-input{
      filter: alpha(opacity=100);
      opacity: 1;
      padding: 5px 10px 5px 10px;
    }
    #attachment-note{
      padding: 10px 0px 10px 0px;
    }
  }
</style>
{% endhighlight html %}

So it would look like this:

<div style="margin-top: 20px">
  <div id="dnd-container-ie">
    <span id="dnd-label-ie">Drag & Drop File Here</span>
    <form id="dnd-form-ie">
      <input id="dnd-input-ie" type="file">
    </form>
  </div>
</div>