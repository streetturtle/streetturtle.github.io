---
layout: post
title: Lockscreen for AwesomeWM
date: 2018-11-17 14:25
comments: true
description: A few-liner lock screen for Awesome WM using i3lock.
tags:
- awesome wm
---


Here is how to create following screen lock in Awesome:

<video controls style="width:100%">
    <source src='{{'/images/2018/screenlock.mp4' | relative_url }}' type='video/webm'  media="all and (max-width:480px)"/>
</video>

Basically everything is done in the script below:

{% highlight bash %}
#!/bin/bash

LOCKSCREENIMG='/tmp/lockscreen.png'

pgrep i3lock || ffmpeg  -loglevel panic -f x11grab -video_size $(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/') -y -i :0.0+$1,20 -i ~/Pictures/tmnt_small.png -filter_complex "boxblur=9,overlay=(main_w-overlay_w)/3:(main_h-overlay_h)/2" -vframes 1 $LOCKSCREENIMG

i3lock -i $LOCKSCREENIMG
{% endhighlight %}
