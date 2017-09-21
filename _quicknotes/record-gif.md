---
layout: post
title:  "Record GIF in Ubuntu"
date:   2017-07-20 10:47:45
comments: true
tags:
 - notes
---

Super fast and simple tool to record GIFs in Ubuntu. Below is an example command which created following GIF:

![gif](../images/notes/out.gif){:.center-image}

{% highlight bash %}
$ sudo apt-get install byzanz
$ byzanz-record --duration 10 --x 3600 --y 0 --width=150 --height=50 out.gif
{% endhighlight %}

> In case of two screens the `x` option of the second would be offset by the width of the first screen
{:.note}
