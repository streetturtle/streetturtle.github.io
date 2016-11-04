---
layout: post
title:  "Battery and Sound volume widget for Awesome WM"
date:   2015-07-16 16:23:45
comments: true
categories:
description: Very simple widgets for Awesome - battery widget which shows status of the battery and also includes a popup message when you have less than 15% of power left and a volume widget which shows an icon which represents the sound volume.
tags: 
- awesome wm
- ubuntu
---

## Batter widget

Simple and easy-to-install widget for Awesome Window Manager.

This widget consists of:

 - an icon which shows the battery status: ![Battery Widget]({{ site.url }}/images/batWid1.png)
 
 - a pop-up window, which shows up when you hover over it: ![Battery Widget]({{ site.url }}/images/batWid2.png)
 
 - a pop-up warning message which appears when battery level is less that 15%: ![Battery Widget]({{ site.url }}/images/batWid3.png)

### Installation

This widget uses the output of acpi tool.

- install `acpi` tool:

{% highlight bash %}
sudo apt-get install acpi
{% endhighlight bash %}

- clone/copy battery.lua file and battery-icons folder to your ~/home/username/.config/awesome/ folder;

- include `battery.lua` and add battery widget to your wibox in rc.lua:

{% highlight lua %}
require("battery")
right_layout:add(batteryIcon)
{% endhighlight lua %}

## Volume widget

Simple and easy-to-install widget for Awesome Window Manager.

This widget represents the sound level: ![Volume Widget]({{ site.url }}/images/volWid.png)

### Installation

- clone/copy volume.lua file and volume-icons folder to your `~/home/username/.config/awesome/` folder;

- change path to the icons in `volume.lua`:

{% highlight lua %}
widget:set_image("/home/<username>/.config/awesome/volume-icons/" .. volumeLevel .. ".png")
{% endhighlight lua %}


- include `volume.lua` and add volume widget to your wibox in rc.lua:

{% highlight lua %}
require("volume")
right_layout:add(volume_widget)
{% endhighlight lua %}
