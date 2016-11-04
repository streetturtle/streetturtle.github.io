---
layout: post
title: "Making fn-keys work in Awesome WM"
date: "2016-06-19 11:11:47 +0200"
description: After switching to Awesome from Unity I didn't use fn-keys at all - I simply remapped their functionality to different shortcuts with mod4 key. But after sometime of using Awesome in a dual-boot system alongside with Windows made me crazy each time remembering which shortcut to use to change volume, or brightness. Here I want to show how to make some of fn-keys work in Awesome.
comments: true
share: true
tags: 
 - awesome wm
---

Basically there is nothing super hard in it. The only discovery for me was that the `fn`{:.key} does not throw any signal to X by itself. It works only in combination with some other key. To test that you can run `xev` (listens events from keyboard/mouse and prints them) in your terminal and press `fn`{:.key} several times.
Now let's try combination - `fn`{:.key}+`F2`{:.key} for instance - volume down for my DELL laptop. You'd see something like this in terminal:

{% highlight bash %}
KeyPress event, serial 33, synthetic NO, window 0x800001,
    root 0xf5, subw 0x0, time 1407632, (543,-382), root:(543,520),
    state 0x0, keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XmbLookupString gives 0 bytes: 
    XFilterEvent returns: False

KeyRelease event, serial 33, synthetic NO, window 0x800001,
    root 0xf5, subw 0x0, time 1407739, (543,-382), root:(543,520),
    state 0x0, keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume), same_screen YES,
    XLookupString gives 0 bytes: 
    XFilterEvent returns: False
{% endhighlight bash %}

The interesting part here is `keycode 122 (keysym 0x1008ff11, XF86AudioLowerVolume)`. To refer to this combination in **rc.lua** we need keycode with hash - `#122`. So for volumes fn keys combination the key mapping would be like this:

{% highlight lua %}
awful.key({ }, "#122", function () awful.util.spawn("amixer -D pulse sset Master 5%-") end),
awful.key({ }, "#123", function () awful.util.spawn("amixer -D pulse sset Master 5%+") end),
{% endhighlight lua %}

And for brightness level:

{% highlight lua %}
awful.key({ }, "#232", function () awful.util.spawn("xbacklight -dec 10") end),
awful.key({ }, "#233", function () awful.util.spawn("xbacklight -inc 10") end),
{% endhighlight lua %}

Another way to get keycodes of key combinations is to list them using following command: `xmodmap -pke` and then grep them, for example: `xmodmap -pke | grep Brightness`.
