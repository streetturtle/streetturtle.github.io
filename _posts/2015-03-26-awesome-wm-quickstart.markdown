---
layout: post
title:  "Awesome wm quickstart"
date:   2015-03-26 16:23:45
comments: true
categories:
description: I am big fan of Ubuntu, but I've never liked the Unity shell, so I was using a Gnome shell mostly. But recently I decided to switch to the Awesome window manager. I watched few videos of it and I quite liked the idea of being able to control size and number of windows per workspace. So I've installed it and here want to share some of my problems with solutions.
tags:
- awesome wm
- ubuntu
---

### Installation and Configuration files

First of all you need to install it, note that in default repositries only version 3.4 available, but the latest one is 3.5.6:

{% highlight bash %}
sudo add-apt-repository ppa:klaus-vormweg/awesome
sudo apt-get update
sudo apt-get install awesome awesome-extra
{% endhighlight bash %}

 - `awesome` - basically awesome itself
 - `awesome extra` - some additional lua libraries with which you can create widgets for example

Then logout and login selecting Awesome wm in available shells.

Awesome uses `/etc/xdg/awesome/rc.lua` file which could be overriden by `~/.config/awesome/rc.lua`. So we need to copy original file to your home folder.

{% highlight bash%}
mkdir -p ~/.config/awesome/
cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
{% endhighlight bash%}

From now all changes should be done with rc.lua which is under your home directory.

### Two screens

By default when I logged in first time with using awesome screens were swaped, so left one was on the right and right on the left. If I were using Gnome Shell swap them back would be easier, just using Displays application, but in awesome it should be done manually. To see what screens you have, you need to run `xrandr`. You'll see name of the screen with applied parameters and then available options, such as screen resolutions and FPS. It would be something like this (I replaced some parts with `...`):

{% highlight bash %}
Screen 0: minimum 8 x 8, current 3840 x 1200, maximum 32767 x 32767
DP1 disconnected (normal left inverted right x axis y axis)
HDMI1 connected primary 1920x1200+0+0 (normal left inverted right x axis y axis) 518mm x 324mm
   1920x1200      60.0*+
   1920x1080      50.0  
   ...
VGA1 connected 1920x1200+1920+0 (normal left inverted right x axis y axis) 518mm x 324mm
   1920x1200      60.0*+
   1920x1080      60.0  
   ...
VIRTUAL1 disconnected (normal left inverted right x axis y axis)
{% endhighlight bash %}

From this output we can see that I have two monitors, one is connected using HDMI port and another using VGA. HDMI is at the top left position (1920x1200+**0+0**) and VGA in on top right (1920x1200+***1920+0**). To swap then in my case I need to run:
 
    xrandr --output VGA1 --left-of HDMI1
    
Done!

### Startup application

One of the simpliest way is to add following section to your _rc.lua_:

{% highlight lua %}
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("clipit")
run_once("hamster-indicator")
{% endhighlight lua %}

### Java applications (SQL Developer)

I am using SQL Developer to work with databases. I was unable to run it after installation (I had just white screen without anything), I tried different versions, but then I discovered that for some reason Awesome has some problems with running Java processes. For SQL Developer solution is to add magical `wmname LG3D` before running the program. More info [here](http://tools.suckless.org/wmname) and [here](https://awesome.naquadah.org/wiki/Problems_with_Java). First you need to install it:

{% highlight bash %}
sudo apt-get install suckless-tools
{% endhighlight bash %}

And then add magic spell before runnig sqldeveloper.sh:

{% highlight bash%}
vim `which 'sqldeveloper'`
{% endhighlight bash%}

and change it to:

{% highlight bash%}
wmname LG3D & /opt/sqldeveloper/sqldeveloper.sh
{% endhighlight bash%}
