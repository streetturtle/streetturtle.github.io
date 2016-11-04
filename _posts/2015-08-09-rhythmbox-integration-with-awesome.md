---
layout: post
title:  "Rhythmbox integration with Awesome WM"
date:   2015-08-09 16:23:45
comments: true
categories:
description: Rhythmbox provides tool to control running instance from terminal, which is very good feature. With it's help it is very easy to create a widget which displays currently playing song. Also here I'm showing how to add some shortcuts to control music.
tags: 
- awesome wm
- ubuntu
---

To work with rhythmbox from terminal there is really nice tool called **rhythmbox-client** which allows controlling already running instance of Rhythmbox. To see all supported features simply run `rhythmbox-client -help`.

## Widget

Widget shows name and artist of currently playing song. Basically it runs theis command: `rhythmbox-client --no-start --print-playing`. Looks like this: ![Rhythmbox Widget]({{ site.url }}/images/rhythmbox.png).
To create such widget create file **rhythmbox.lua** with following content:

{% highlight lua %}
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { gmatch = string.gmatch }
local helpers = require("vicious.helpers")

module("vicious.widgets.rhythmbox")

local function worker(format, warg)
	local info = {
	    ["{state}"] = "nil"
	}
	
	local f = io.popen("rhythmbox-client --no-start --print-playing")
	info["{state}"] = f:read("*line")
	f:close()
	return info
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
{% endhighlight lua %}

In **rc.lua** add vicious and rhythmbox files, create widget and add it to wibox:

{% highlight lua %}
require("rhythmbox")
require("vicious")

...

rhythmboxwidget = wibox.widget.textbox()
vicious.register( rhythmboxwidget, vicious.widgets.rhythmbox,
	function (widget, args)
	   if args["{state}"] == nil then
		  return "Now Playing: Not loaded"
	   elseif args["{state}"] == "Not playing" then
		  return "Paused"
	   else
		  return args["{state}"]
	   end
	end, 4)
{% endhighlight lua %}


## Shortcuts

For the shortcuts most useful would be to play next/previous song and play/pause action. I would like to use **Mod4+,(.)** to switch songs and **Mod4+/** to play/pause.

You can try these commands from terminal to perform those actions:

{% highlight bash %}
rhythmbox-client --no-start --play-pause
rhythmbox-client --no-start --next
rhythmbox-client --no-start --previous
{% endhighlight bash %}

And in **rc.lua** with keybindings:

{% highlight lua %}
awful.key({ modkey, }, "/", function () awful.util.spawn("rhythmbox-client --no-start --play-pause", false) end),
awful.key({ modkey, }, ",", function () awful.util.spawn("rhythmbox-client --no-start --next", false) end),
awful.key({ modkey, }, ".", function () awful.util.spawn("rhythmbox-client --no-start --previous", false) end)
{% endhighlight lua %} 