---
layout: post
title: "Use DBus instead of pread/popen/spawn_in_shell in Awesome WM"
date:   2015-09-19 09:26:45
comments: true
categories:
description: After I started to use some widgets in Awesome I've noticed that sometimes it freezes for several seconds, so I cannot switch between tags or run 
tags: 
- awesome wm
---

## Freeze problem 

Let's say we have a text widget which displays output of some script (get unread emails for instance). And sometimes execution of this script takes some time. Since lua is not multi-threaded you'll have a 'freeze' - you won't be able to interact with Awesome (switch tags, open Awesome menu, etc.) because Awesome will wait for the response.

I will demonstrate it on a simple example. Let's say I have a python script which sleeps for 5 seconds and then returns some string, sleep.py:

{% highlight lua %}
#!/usr/bin/python

import time
time.sleep(5)
print 'wow'
{% endhighlight lua %}

## Pread example

By using `awful.util.pread` Awesome will just wait until execution of a script is finished. To check it let's create a text widget in a separate lus file:

{% highlight lua %}
local wibox = require("wibox")
local awful = require("awful")

sleepMessage = wibox.widget.textbox()

-- Pread (Awesome freezes  while waiting for response)
sleepMessageTimer = timer({ timeout = 10 })
sleepMessageTimer:connect_signal("timeout",
  function()
    sleepMessage:set_text(awful.util.pread("python ~/HomeDev/temp/sleep.py")) 
  end)
sleepMessageTimer:start()
{% endhighlight lua %}

And put it in **rc.lua**:

{% highlight lua %}
require("sleep")
...
right_layout:add(sleepMessage)
{% endhighlight lua %}

After restart of Awesome after 5 seconds Awesome will freeze for 5 seconds and then message will be displayed on a widget. This is exactly what happens when execution of some scripts takes time.

Now let's have on a solution of this problem: using DBus to transfer messages between scripts and Awesome.

## DBus example

To use DBus for this example change implementation of **sleep.py**

{% highlight lua %}
local wibox = require("wibox")
local awful = require("awful")

sleepMessage = wibox.widget.textbox()

-- DBus (Command are sent to DBus, which prevents Awesome from freezing)
sleepTimerDbus = timer ({timeout = 5})
sleepTimerDbus:connect_signal ("timeout",
  function ()
    awful.util.spawn_with_shell("dbus-send --session --dest=org.naquadah.awesome.awful /com/console/sleep com.console.sleep.sleepMessage string:$(python ~/HomeDev/temp/sleep.py)" )
  end)
sleepTimerDbus:start()

dbus.request_name("session", "com.console.sleep")
dbus.add_match("session", "interface='com.console.sleep', member='sleepMessage' " )
dbus.connect_signal("com.console.sleep",
  function (...)
    local data = {...}
    local dbustext = data[2]
    sleepMessage:set_text(dbustext)
  end)
{% endhighlight lua %}

With this implementation Awesome will not freeze. Here instead of reading output of a script we send it to DBus:

{% highlight bash %}
dbus-send --session --dest=org.naquadah.awesome.awful /com/console/sleep com.console.sleep.sleepMessage string:$(python ~/HomeDev/temp/sleep.py)
{% endhighlight bash %}

And when execution has finished we take it and display:

{% highlight lua %}
dbus.request_name("session", "com.console.sleep")
dbus.add_match("session", "interface='com.console.sleep', member='sleepMessage' " )
dbus.connect_signal("com.console.sleep",
  function (...)
    local data = {...}
    local dbustext = data[2]
    sleepMessage:set_text(dbustext)
  end)
{% endhighlight lua %}

## Conclusion

For widgets, which uses scripts which could take some time to run, like calling some service use DBus :)