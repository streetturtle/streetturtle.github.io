---
layout: post
title:  "Battery and Sound volume wiget for Awesome WM"
date:   2015-07-16 16:23:45
comments: true
categories:
description:
tags: 
- awesome wm
- ubuntu
---

## Batter widget

Simple and easy-to-install widget for Awesome Window Manager.

Basically this widget consists of an icon which shows the battery status: ![Battery Widget]({{ site.url }}/images/batWid1.png)

And a pop-up window, which shows up when you hover over it: ![Battery Widget]({{ site.url }}/images/batWid2.png)

### Installation

This widget uses the output of acpi tool.

- install `acpi` tool:

~~~~~~~
sudo apt-get install acpi
~~~~~~~

- clone/copy battery.lua file and battery-icons folder to your ~/home/username/.config/awesome/ folder;

- include `battery.lua` and add battery widget to your wibox in rc.lua:

~~~~~~~
require("battery")
right_layout:add(batteryIcon)
~~~~~~~

## Volume widget
Simple and easy-to-install widget for Awesome Window Manager.

This widget represents the sound level: ![Volume Wiget]({{ site.url }}/images/volWid.png)

### Installation

- clone/copy volume.lua file and volume-icons folder to your `~/home/username/.config/awesome/` folder;

- change path to the icons in `volume.lua`:

~~~~~~~
widget:set_image("/home/<username>/.config/awesome/volume-icons/" .. volumeLevel .. ".png")
~~~~~~~

- include `volume.lua` and add volume widget to your wibox in rc.lua:

~~~~~~~
require("volume")
right_layout:add(volumeWidget)
~~~~~~~