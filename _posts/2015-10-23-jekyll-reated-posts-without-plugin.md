---
layout: post
title: "Related posts (by tag) without plugin for jekyll"
date: 2015-10-23 16:25:06
comments: true
tags:
 - jekyll
description: I'd like to share with pretty awesome stuff here! I'll show how to select and display posts, which have same tags as currently opened post...without any plugins!
comments: true
---

Let's create the same section as you can see on the right: Related By Tags. To do it we'll use [liquid](https://docs.shopify.com/themes/liquid-documentation/basics):

>Liquid is an open-source, Ruby-based template language created by Shopify. It is the backbone of Shopify themes and is used to load dynamic content on storefronts.

The main idea is to go through all the posts, take tags from each post and compare them with tags from currently opened post. If they match add link to post to the list.  

Below you can find how the whole section will look like:

{% highlight html linenos %}
{% raw %}
{% if page.tags.size == 1 %}
  <h2>Related By Tag</h2>
{% elsif page.tags.size > 1 %}
  <h2>Related By Tags</h2>
{% endif %}
<ul>
  {% assign posts = site.posts | sort: 'title' %}  <!-- sort all posts -->
  {% for post in posts %}
    {% assign isAdded = false %}       <!-- used to prevent duplicates -->  
    {% for tagAll in post.tags %}      <!-- all posts's tags -->
      {% for tag in page.tags %}       <!-- current post's tags -->
        {% if tagAll == tag and page.title != post.title and isAdded == false %}
          <li><a href="{{ post.url | prepend: site.url }}">{{ post.title }}</a></li>
          {% assign isAdded = true %}
        {% endif %}
      {% endfor %}
    {% endfor %}
  {% endfor %}
</ul>
{% endraw %}
{% endhighlight html %}

I think this piece of code is self explanatory. In case of any doubts please pm me or left a comment.

And (just in case) here is how to create a sorted list of all used tags:

{% highlight html %}
{% raw %}
<h1>Tags</h1>
<ul>
  {% assign tags = (site.tags | sort:0) %}
  {% for tag in tags %}
    <li><a href="/tag/{{ tag[0] }}">{{ tag[0] }}</a></li>
  {% endfor %}
</ul>
{% endraw %}
{% endhighlight html %}

Cheers!
