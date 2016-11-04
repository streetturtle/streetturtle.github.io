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

First of all you need to install it, note that in default repositories only version 3.4 available, but the latest one
 is 3.5.6:

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

### Two screens (swap screens)

By default when I logged in first time using awesome screens were swapped, so left one was on the right and right on the left. If I were using Gnome Shell swap them back would be easier, just using Displays application, but in awesome it should be done manually. To see what screens you have, you need to run `xrandr`. You'll see name of the screen with applied parameters and then available options, such as screen resolutions and FPS. It would be something like this (I replaced some parts with `...`):

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

From this output we can see that I have two monitors, one is connected using HDMI port and another using VGA. HDMI is at the top left position (1920x1200+**0+0**) and VGA in on top right (1920x1200+***1920+0**). To swap them in my case I need to run:
 
{% highlight bash %}
xrandr --output VGA1 --left-of HDMI1
{% endhighlight bash %}
    
Done!

### Themes

There are two types of themes: for awesome: which basically applies to top panel, widgets and for applications: GTK themes.

Regarding GTK themes to check available ones you need to install `lxappearance` application which allows you to
change theme:

{% highlight bash %}
sudo apt-get install lxappearance
{% endhighlight bash %}

Personally I like adwaita dark theme, so I download it and put in /usr/share/themes. And then I choose it from available themes in lxappearance:

![My helpful screenshot]({{ site.url }}/images/lxappearance.png)

### Startup application

One of the simplest way is to add following section to your _rc.lua_:

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

And then add magic spell before running sqldeveloper.sh:

{% highlight bash%}
vim `which 'sqldeveloper'`
{% endhighlight bash%}

and change it to:

{% highlight bash%}
wmname LG3D & /opt/sqldeveloper/sqldeveloper.sh
{% endhighlight bash%}


## Shortcuts

Volume control. First you need to find out how increase/decrease volume from shell, depends on your soundcard you can use one of the following:

{% highlight bash %}
amixer set Master 5%+           # works for desktop
amixer -D pulse sset Master 5%+ # works for laptop
{% endhighlight bash %}

And then add following section to the shortcuts:

{% highlight lua %}
  -- Custom shortkeys
 awful.key({ modkey,        }, "]", function () awful.util.spawn("amixer -D pulse sset Master 5%+") end),
 awful.key({ modkey,        }, "[", function () awful.util.spawn("amixer -D pulse sset Master 5%-") end)
{% endhighlight lua %}