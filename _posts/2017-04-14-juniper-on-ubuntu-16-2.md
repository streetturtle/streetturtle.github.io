---
layout: post
title:  "Juniper VPN on Ubuntu 16.04 64-bit (part 2)"
date:   2017-04-13 22:47:45
comments: true
description: 
tags: 
- ubuntu
---

This is an update to the post [Juniper VPN on Ubuntu 16.04 64-bit]({% post_url 2016-09-17-juniper-on-ubuntu-16 %}).
In version 52 of Firefox the support of NPAPI (Netscape Plugin API) was [dropper](https://www.mozilla.org/en-US/firefox/52.0/releasenotes/), so most likely your firefox was automatically updated and IcedTea plugin doesn't work anymore, as well as Juniper. 

The solution is to use ESR (Extended Support Release) version of firefox which still has an NPAPI support. You can get it [here](https://www.mozilla.org/en-US/firefox/52.0esr/releasenotes/). After you have it put it under `opt` folder and create an executable under `/usr/local/bin`, so that this firefox is used only to create VPN connection:

{% highlight bash %}
tar -xvf ./Downloads/firefox-52.0.2.tar.bz2
sudo mv ./Downloads/firefox /opt/
mv /opt/firefox /opr/firefox_for_vpn
sudo echo `/opt/firefox_for_vpn/firefox &` > vpn_firefox
{% endhighlight %}

To prevent it from automatic updates go to [about:preferences#advanced](about:preferences#advanced) and choose **Never check for updates (not recommended: security risk)** option.

