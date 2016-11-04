---
layout: post
title:  "Solving Lenovo m5400 touchpad problem"
date:   2015-04-08 16:23:45
comments: true
categories:
description: After several days of using my Lenovo m5400 I faced serious problem with built-in touchpad. Sometimes it didn't work at all, sometimes every touch I made was understood as scrolling, sometimes it was stuck for several seconds and started to work again. Here is solution to this problem!   
tags: 
---
After several days of using my Lenovo m5400 I've faced serious problem with built-in touchpad. Sometimes it didn't work at all, sometimes every touch I made was understood as scrolling, sometimes it was stuck for several seconds and started to work again. It seems that problem somewhere in driver, I tried to reinstall/update it, but it didn't help. Since I was using my laptop only at home I decided to buy an external mouse and don't use  touchpad at all. But recently I tried again to solve this issue. After some time clicking around it turned out that it's quite easy to make it work.

Just in case I'm running Windows 8.1 on Lenovo m5400 with i5-4200.

Press super and search for "Mouse settings", select _Change mouse settings_

![My helpful screenshot]({{ site.url }}/images/m5400MouseSettings.png){:.center-image}

Then select _Device Settings_, Synaptic TouchPad... device and press _Settings_, you'll see following window:

![My helpful screenshot]({{ site.url }}/images/m5400MouseSettings-1.png){:.center-image}

Then I disabled everything except Two-Finger Scrolling option and also changed sensitivity of Palm Check because I think that touchpad wasn't working because it wasn't able to distinguish palm from finger sometimes and was blocking touchpad. 

After this manipulation touchpad start to work much more better!

Cheers!