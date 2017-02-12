---
layout: post
title:  "Widget notification for Awesome WM"
date:   2017-02-12 10:47:45
comments: true
description: Just want to share two possible ways of having widget notifications/information.
tags: 
- awesome wm
share: true
---
Just want to share two possible ways of having widget notifications/information.

# Tooltip

A tooltip is a small message which pops up when mouse cursor hovers over the widget (or any other element which supports tooltips).

```lua
some_widget = wibox.widget {
    widget = wibox.widget.imagebox,
    image = "smile.png"
    resize = false
}

some_tooltip = awful.tooltip({objects = {battery_widget}})
some_tooltip.text("Tooltip message")
```
The tooltip style is set up globally by theme variables, so (ASFAIK) it's not possible to have two tooltips with different font color for example.

# Naughty.notify

This way uses more code - you should think about notification creation/destruction, notification style. 

```lua
local notification
battery_widget:connect_signal("mouse::enter", function()
    awful.spawn.easy_async([[bash -c 'acpi']],
    function(stdout, stderr, reason, exit_code)
        notification = naughty.notify{
            text = stdout,
            title = "Battery status",
            timeout = 5, hover_timeout = 0.5,
            width = 200,
        }
    end
)
end)
battery_widget:connect_signal("mouse::leave", 
    function() naughty.destroy(notification) 
end)
```
But it's more flexible than tooltip. You can call notification from widget's code, for example if battery charge level is  less than 15%. Note that it's important to destroy widget, otherwise you end up with multiple instances, like on the picture below: ![My helpful screenshot]({{ site.url }}/images/tooltip-vs-naughty.png){:.center-image}
