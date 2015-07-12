---
layout: post
title:  "Battery widget for Awesome WM"
date:   2015-07-12 16:47:45
comments: true
categories:
description: Simple widget for Awesome window manager which shows battery status.   
tags: 
- ubuntu
- awesome wm
---

## Widet

Basically this widget consist of an icon which shows the battery status: ![Battery Widget]({{ site.url }}{{ site.baseurl }}/assets/batWid1.png)

And a pop-up window, which shows when you hover a mouse: ![Battery Widget]({{ site.url }}{{ site.baseurl }}/assets/batWid2.png)

## Installation

- install `acpi` tool:
{% highlight bash %}
sudo apt-get install acpi
{% endhighlight %}

- clone/copy battery.lua file and battery-icons folder in your ~/home/username/.config/awesome/ folder.
- add battery widget to your wibox in rc.lua

{% highlight lua%}
right_layout:add(batteryIcon)
{% endhighlight %}

## Under the hood

This widget uses the tool called `acpi`. 