---
layout: post
title:  "Juniper on Ubuntu 16.04 64-bit"
date:   2016-09-17 22:47:45
<!--comments: true-->
description: 
tags: 
- ubuntu
---

I faced an issue running Juniper on Ubuntu 16.04. Some of the solutions I found wasn't working (like install 32bit openjdk and firefox), others took to much time to set up and were quite fragile (like setup VM with 32bit Debian, run Juniper applet on it and use this VM as proxy). So here is my solution which I already succesfully tried on 3 laptops with 64bit Ubuntu 16.04.

 - Install Firefox (most likely it's already installed) - normal one, 64bit

{% highlight bash %}
sudo apt-get install firefox
{% endhighlight bash %}

 - Install icedtea-plugin
 
{% highlight bash %}
sudo apt-get install icedtea-plugin
{% endhighlight bash %}

 3. Install Oracle 32bit JDK
 
 4. Add it to alternatives (but don't choose it after, just keep it in alternatives)
 
 5. Now you have 32bit Java available, but if you select it as default one it won't work, since your pc does not support 32bit archtechture. So let's add it:
 
{% highlight bash %}
sudo dpkg --add-architecture i386
sudo apt-get update
{% endhighlight bash %}

For Ubuntu 14 threre were `ia32-libs` package which had neccesarry libraries. But now it's not available anymore. Here are some of the libraries from that package to be able to run Java:

{% highlight bash %}
asdasdasd
{% endhighlight bash %}
