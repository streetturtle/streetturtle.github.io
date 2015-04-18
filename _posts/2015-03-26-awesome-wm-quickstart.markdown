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

First of all you need to install it:

{% highlight bash %}
sudo apt-get install awesome fonts-font-awesome awesome-extra
{% endhighlight basj %}

Then logout and login selecting Awesome wm in available shells.

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



