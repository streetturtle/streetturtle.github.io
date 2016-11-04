---
layout: post
title: "Different image styles in Jekyll"
date: 2015-12-10 11:09:06
comments: true
tags: 
  - jekyll
  - markdown
description: Using markdown for writing posts is very convenient and easy, but since markdown converts to html there is not much ways to customize styles of some elements in result html, like styles of an image. Here I'll show how it could be solved.
comments: true
---

In my case I would like to split images in two types: 

 * inline images, which are usually quite small and could be shown just in the text, 
 like this one: ![Awesome-screenshot]({{site.url}}/images/awesome_scrnsht.png);
 * and big images, which should be shown inside a paragraph aligned by center of the page:
 
![insta-bears]({{site.url}}/images/insta-bears.jpg){:.center-image}

Of course you can insert html `img` tag directly in the markdown file. But it's not so cool as a plain markdown :)

Here is the markdown for the images above:

{% highlight bash %}
![Awesome-screenshot]({{site.url}}/images/awesome_scrnsht.png);
![insta-bears]({{site.url}}/images/insta-bears.jpg){:.center-image}
{% endhighlight bash %}

> This approach will work with **kramdown** converter, **redcarpet** does not support this feature.
{: .note}

So idea here is to provide a css class just after the image in curly brackets with colon: `{:<css-class-name>}`. In my case `.center-image` defined like this:

{% highlight css %}
.center-image
{
  margin: 0 auto;
  display: block;
}
{% endhighlight css %}

And the output html would be:

{% highlight html %}
<img src="http://localhost:4000/images/insta-bears.jpg" alt="insta-bears" class="center-image">
{% endhighlight html %}

With this approach you can use as many image styles as you want just by defining css class and providing it after the image. You can read more about this kramdown feature in [quick reference](http://kramdown.gettalong.org/quickref.html#block-attributes). 

By the way those bears are from [Madrid Zoo](http://zoomadrid.com/en), I really recommend to visit them :)
