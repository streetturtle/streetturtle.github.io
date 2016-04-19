---
layout: post
title: "Polymer - DuplicateDefinitionError a type with name is already registered"
date: "2016-04-19 21:11:47 +0200"
comments: true
tags: polymer
---

# Problem

Recently I've faced quite annoying problem with Polymer. Just for info, I am developing a custom user interface for some application (Alfresco) using Polymer. So far I have around 10 custom elements which work quite good in Chrome. But when I tested the page in IE/EDGE/Firefox the page simply didn't open and browser just hanged after few second. The problem was in some dead loop - the console was filling up with some strange errors.  

# Solution

One of the first exception in console was:

{%  highlight javascript %}
File: webcomponents-lite.js, Line: 2244, Column: 7
DuplicateDefinitionError: a type with name 'dom-module' is already registered
{% endhighlight javascript %}

After reviewing my elements I've found out that **polymer.html** was included in the parent page and in some of my custom elements. But actually it should be in all the custom elements. And it shouldn't be in parent element. This partially solved the problem, next problem was similar:

{%  highlight javascript %}
File: webcomponents-lite.js, Line: 2244, Column: 7
DuplicateDefinitionError: a type with name 'iron-meta' is already registered
{% endhighlight javascript %}

This was solved by replacing import of **webcomponents-lite.js** by **webcomponents.js** in parent element and removing it from all the elements.  

Since I've just recently started with polymer here is two rules I learned1:

> 1. **polymer.html** should be in elements, but not in parent page
> 2. **webcomponents.js** should be in parent page, but not in elements
{:.note}
