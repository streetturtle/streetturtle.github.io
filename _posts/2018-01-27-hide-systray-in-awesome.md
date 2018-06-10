---
layout: post
title: Toggle systray visibility in Awesome WM
date:   2018-01-27 19:32
description: Simple trick to make awesome look more clear by hiding the systray using keyboard shortcut
comments: true
tags:
- awesome wm
---

Here is a trick to toggle system tray visibility in Awesome using keyboard shortcut. The reason to do that is pretty simple - it looks ugly in some themes. In my case I don't like two things about it:

 - I didn't manage to make it transparent which is quite important since I am using transparent tasklist and widgets. I tried `wibox.widget.systray.opacity` property which doesn't work as well as setting an alpha channel for `beautiful.bg_systray`.

 - Colors of the apps are very different from theme colors which makes systray look flashy and disturbing:

![systray screenshot]({{ "/images/2018/systray.png" | relative_url }})

On the other hand not showing it at all will make interaction with some apps pretty difficult. So having a keyboard shortcut which toggles its visibility sounds like a good solution for the problems mentioned above.

To do it create a systray widget inside `awful.screen.connect_for_each_screen` function:

{% highlight lua %}
awful.screen.connect_for_each_screen(function(s)
    ...
    s.systray = wibox.widget.systray()
    s.systray.visible = false
    ...
{% endhighlight %}

Then add it to the the wibox: replace default `wibox.widget.systray()` by `s.systray` inside `s.mywibox:setup` method:

{% highlight lua %}
s.mywibox:setup {
    ...
    s.mytasklist, -- Middle widget
    {
        ...
        s.systray
    ...
{% endhighlight %}

Almost done, the only thing left is a shortcut, I use `mod`{:.key} + `=`{:.key}:

{% highlight lua %}
awful.key({ modkey }, "=", function ()
    awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
    end, {description = "Toggle systray visibility", group = "custom"})
)
{% endhighlight %}

