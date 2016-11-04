---
layout: post
title:  "Polymer based PDF viewer component"
date:   2016-03-28 10:23:45
comments: true
share: true
description: 
tags: 
- polymer
---

> This post is a copy of the readme file of the [pdf-element](https://github.com/streetturtle/pdf-element) project 
{:.note}

[Polymer](https://www.polymer-project.org/1.0/) based web component which allows to view PDF files.

Features:

 - Next/Previous page
 - Zoom
 - Download
 - Compatible with Polymer 1.0
 - Dynamically change document without page reloading
 - Looks nice :)
 
![pdf-element]({{site.url}}/images/pdf-element.png)
 
# Installation
 
{% highlight bash %}
git clone https://github.com/streetturtle/pdf-element.git
cd ./pdf-element
npm install
bower install
gulp serve
{% endhighlight bash %}
 
# Usage

Include element:

{% highlight html %}
<link rel="import" href="./pdf-reader.html">
{% endhighlight html %}

And then simply use it:

{% highlight html %}
<pdf-reader src="../pdf.pdf" width=720 height=400></pdf-reader>
{% endhighlight html %}

To dynamically change the file just use bound url property:

{% highlight html %}
{% raw %}
<pdf-reader src="{{selectedPdf.path}}" width=720 height=400></pdf-reader>
{% endraw %}
{% endhighlight html %}

More details with demo could be found at the project [site](http://pavelmakhov.com/pdf-element/).
