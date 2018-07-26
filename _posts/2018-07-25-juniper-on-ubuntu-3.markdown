---
layout: post
title: Juniper VPN on Ubuntu (part 3)
date: 2018-07-24 14:25
comments: true
description: Finally there is a super easy way to use Juniper VPN on Ubuntu (and probably on other distributives as well).
tags:
- ubuntu
---

I hope it's a final post about Juniper on Ubuntu :) And no Java, Firefox 32bit or iced-tea plugin required!

First you need to install openconnect:

{% highlight bash %}
$ sudo apt-get update
$ sudo apt-get install openconnect
{% endhighlight %}

Then login to you VPN provider and get Cookie named DSID:

 - In Chrome by pressing Ctrl + Shift + I, select Application tab, then Cookies:
 {![chrome-cookie]({{site.url}}/images/2018/juniper1.png)
 - In Firefox by pressing Ctrl + Shift + I, select Storage tab, then Cookies:
 {![firefox-cookie]({{site.url}}/images/2018/juniper2.png)

Then run openconnect with a copied cookie, the command should look following way:

{% highlight bash %}
$ sudo openconnect --juniper -C "DSID=15c4fd0fdc6534f7e01231041f6f1c23;" vpn.cowabunga.com
{% endhighlight %}

You should see something similar to this line:

{% highlight bash %}
Connected tun0 as 192.168.19.27, using SSL
{% endhighlight %}

Done!!!
