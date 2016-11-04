---
layout: post
title: "Jekyll Dark Clean Theme"
date: 2015-10-09 16:25:06 -0700
comments: true
tags: jekyll
description: Here I want to introduce you the dark theme for Jekyll. It was forked from Scotte's jekyll-clean theme and customized.
comments: true
---

## Introduction

Here is a sample post for Jekyll-Clean-Dark theme. 

* Get it from [github](https://github.com/streetturtle/jekyll-clean-dark).
* See the [live demo](http://pavelmakhov.com/jekyll-clean-dark).
* See it [in action on my blog](http://pavelmakhov.com).

This theme was created on top of [Jekyll Clean theme](https://scotte.github.io) by Scotte.

This theme uses some parts of Twitter Bootstrap, which allows it looks nice on a mobile devices using a collapsable nav bar and hiding the sidebar.

Here how it looks like on iPhone 5:

![My helpful screenshot]({{ site.baseurl | prepend:site.url}}/images/iphone_portrait.PNG)
![My helpful screenshot]({{ site.baseurl | prepend:site.url}}/images/iphone_landscape.PNG)

And on iPad mini:

![My helpful screenshot]({{ site.baseurl | prepend:site.url}}/images/ipad_portrait.PNG)

![My helpful screenshot]({{ site.baseurl | prepend:site.url}}/images/ipad_landscape.PNG)


Optionally you can use:

 - [Disqus](http://disqus.com) as a comments system;
 - [Google Analytics](http://www.google.com/analytics/);
 - [Yandex Metrika](http://metrica.yandex.com);
 - Blog tags.

Also you can have social icons which could lead to your social accounts.
Out-of-the box it has: 

<ul class="social-media">
    <li>
        <a title="{{ site.social.github }} on Github"
            href="https://github.com/{{ site.social.github }}"
            class="github wc-img-replace" target="_blank">Github</a>
    </li>
    <li>
        <a title="{{ site.social.stackoverflow }} on StackOverflow"
            href="http://stackoverflow.com/users/1252056/{{ site.social.stackoverflow }}"
            class="stackoverflow wc-img-replace" target="_blank">StackoverFlow</a>
    </li>
    <li>
        <a title="{{ site.social.github }} on LinkedIn"
            href="https://www.linkedin.com/in/{{ site.social.linkedin }}"
            class="linkedin wc-img-replace" target="_blank">LinkedIn</a>
    </li>
    <li>
        <a title="{{ site.social.instagram }} on Instagram"
            href="https://instagram.com/{{ site.social.instagram }}"
            class="instagram wc-img-replace" target="_blank">Instagram</a>
    </li>
    <li>
        <a title="{{ site.social.lastfm }} on LinkedIn"
            href="http://lastfm.com/user/{{ site.social.lastfm }}"
            class="lastfm wc-img-replace" target="_blank">LastFm</a>
    </li>
    <li>
        <a title="{{ site.social.careers }} on Careers"
            href="https://careers.stackoverflow.com/{{ site.social.careers }}"
            class="careers wc-img-replace" target="_blank">Careers</a>
    </li>
    <li>
        <a title="{{ site.social.rss }} RSS"
            href="{{site.url}}/{{ site.social.rss }}"
            class="rss wc-img-replace" target="_blank">RSS</a>
    </li>
</ul>

You can easily add more by putting svg images in a /css/social folder and adding css styles for them.

All these features could be set up in `_config.yml`.

## Installation

If you don't have your own blog you can clone this repository and put your articles in a `_posts` folder.
If you already have your own blog then I think you can clone this repository and copy-paste content keeping your `_posts` folder.

After you will have to set up your `_config.yml`

## License

The content of this theme is distributed and licensed under a [Creative Commons Attribution 4.0 License](https://creativecommons.org/licenses/by/4.0/legalcode)

    This license lets others distribute, remix, tweak, and build upon your work,
    even commercially, as long as they credit you for the original creation. This
    is the most accommodating of licenses offered. Recommended for maximum
    dissemination and use of licensed materials.

In other words: you can do anything you want with this theme on any site, just please
provide a link to the original theme on github.

This theme includes the following files which are the properties of their
respective owners:

* js/bootstrap.min.js - [bootstrap](http://getbootstrap.com)
* css/bootstrap.min.css - [bootstrap](http://getbootstrap.com)
* js/jquery.min.js - [jquery](https://jquery.com)