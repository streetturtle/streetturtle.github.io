---
layout: post
title:  "Mouse Battery status widget for Awesome wm"
date:   2017-01-06 10:47:45
comments: true
description: Quick tutorial on how to create widget which displays battery status of a wireless mouse
tags: 
- awesome wm
share: true
---

Mouse Battery Widget

Quick tutorial on how to create widget which displays battery status of a wireless mouse - Logitech's [Performance MX](http://www.logitech.com/en-ca/product/performance-mouse-mx) in my case. I will follow simple flow which I described in this post: [How to create widget for Awesome WM](http://pavelmakhov.com/2016/01/how-to-create-widget). 

# Get battery info

The hardest part here is to get battery percentage from CLI. I'm using [UPower](https://upower.freedesktop.org/). To list available devices run

```bash
$ upower --dump
...
Device: /org/freedesktop/UPower/devices/mouse_0003o046Do101Ax0006
  native-path:          /sys/devices/pci0000:00/<numbers>
  vendor:               Logitech, Inc.
  model:                Performance MX
  serial:               34998006
  power supply:         no
  updated:              Thu 05 Jan 2017 10:35:12 EST (85 seconds ago)
  has history:          yes
  has statistics:       no
  mouse
    present:             yes
    rechargeable:        yes
    state:               discharging
    warning-level:       none
    percentage:          20%  # <- we need this guy
    icon-name:          'battery-low-symbolic'
...
```
In the output list find the mouse device and use it's name to get info about it and then `grep` for percentage:

```sh
$ upower -i /org/freedesktop/UPower/devices/mouse_0003o046Do101Ax0006 \
| grep percentage \  # get line with percentage
| grep -E -o '[0-9]+'    # get number
20
```

# Text widget

Create file **~/.config/awesome/mouse-battery.lua** with following content:

```lua
local wibox = require("wibox")
local awful = require("awful")

mouse_widget = wibox.widget.textbox()
mouse_widget:set_font('Play 9')

function update_mouse_widget(widget)
    local current = awful.util.pread(
    "upower -i /org/freedesktop/UPower/devices/mouse_0003o046Do101Ax0006 " ..
    "| grep percentage | grep -E -o '[0-9]+'")
  widget:set_text(current)
end

mouse_timer = timer({ timeout = 3600 })
mouse_timer:connect_signal("timeout", function () update_mouse_widget(mouse_widget) end)
mouse_timer:start()

mouse_timer:emit_signal("timeout")
```

And in **~/.config/awesome/rc.lua**

```lua
require("mouse")
...
right_layout:add(mouse_widget)
```

# Image widget

Instead of text we can show battery image. I used the gnome images (found under 
**/usr/share/icons/gnome/scalable/status/** and also `icon-name` from upower command gives image name from that 
folder. Here's the code for widget:

```lua
local wibox = require("wibox")
local awful = require("awful")

function update_mouse_battery_icon(icon)
    local iconName = awful.util.pread(
    "upower -i /org/freedesktop/UPower/devices/mouse_0003o046Do101Ax0006 " ..
    "| grep icon-name | grep -oP \"(?<=').*(?=')\"")
    icon:set_image("/usr/share/icons/gnome/scalable/status/" .. string.gsub(iconName, "\n", "") .. ".svg")
end

mouse_battery_icon = wibox.widget.imagebox()

mouse_battery_timer = timer({ timeout = 60 })
mouse_battery_timer:connect_signal("timeout",  function() update_mouse_battery_icon(mouse_battery_icon) end)
mouse_battery_timer:start()

mouse_battery_timer:emit_signal("timeout")
```

To use it add it in **rc.lua**

```lua
...
right_layout:add(mouse_battery_icon)
...
```
