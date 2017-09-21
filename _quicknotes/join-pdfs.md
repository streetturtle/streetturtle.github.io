---
layout: post
title:  "Join PDF files"
date:   2017-09-17 10:47:45
comments: true
tags:
 - notes
---

IF you have several PDF documents, say scans, you can easily merge them into one PDF file using handy [`pdftk`](https://www.pdflabs.com/docs/pdftk-cli-examples/) tool:

{% highlight bash %}
$ ls
1.pdf  2.pdf  3.pdf
$ pdftk 1.pdf 2.pdf 3.pdf output joined.pdf
$ ls
1.pdf  2.pdf  3.pdf  joined.pdf
{% endhighlight %}

It also could be used for many other PDF manipulations, `man` for it.