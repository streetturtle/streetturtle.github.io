---
layout: post
title: "How to create widget for Awesome WM"
date: 2016-01-05 12:09:06
comments: true
tags: 
 - awesome wm
description: Here is tutorial on how to create simple widget for Awesome WM. As an example we'll create a text widget which will show currency rate. The given approach is very flexible since we will use the output of a script, so depending on your knowledge/experience you can use any language (bash, python, ruby or even groovy or java). Another good thing here is usage of DBus to send messages between scripts and Awesome.
comments: true
---

# Introduction

As an example let's create a simple widget which displays a currency rate between swiss franc (CHF) and euro (EUR). This widget will be updated every hour and will consist of just a number. At the end it will look like this: ![ratesWidget]({{site.url}}/images/ratesWidget.png)

# Get the currency rate

I've chosen the simple service: [fixer.io](http://fixer.io/), since it's free, simple and return JSON. So the GET request to the following URL: [api.fixer.io/latest?symbols=CHF](http://api.fixer.io/latest?symbols=CHF) would return this JSON:

{% highlight json %}
{
  "base": "EUR",
  "date": "2016-01-05",
  "rates": {
    "CHF": 1.0847
  }
}
{% endhighlight json %}

The part we are interested in is `1.0847`. So let's write a script which will make a GET request and return this number to the output. For this task I've chosen a python, but you can choose any other language. It looks quite simple in Python though:

{% highlight python %}
#!/usr/bin/python

import requests
import json

r = requests.get("http://api.fixer.io/latest?symbols=CHF")
resp = json.loads(r.content)

print resp["rates"]["CHF"]
{% endhighlight python %}

>My version of python is **2.7.6**, this script could look different for version 3.
{: .note}

Save it in `~/.config/awesome/RateWidget/` with name **rates.py**. It could be simply called from terminal to test:

{% highlight bash %}
$ python rates.py 
1.0847
{% endhighlight bash %}

# Lua widget

Now let's create a text widget and display the script's output. Create file **rates.lua** under the same folder with following content:

{% highlight lua linenos %}
local wibox = require("wibox")
local awful = require("awful")

rateWidget = wibox.widget.textbox()

-- DBus (Command are sent to Dbus, which prevents Awesome from freeze)
sleepTimerDbus = timer ({timeout = 3600})
sleepTimerDbus:connect_signal ("timeout", 
  function ()
    awful.util.spawn_with_shell("dbus-send --session 
                                --dest=org.naquadah.awesome.awful 
                                /com/console/rate 
                                com.console.rate.rateWidget 
                                string:$(python ~/.config/awesome/rates/rates.py)" )
  end)
sleepTimerDbus:start()

sleepTimerDbus:emit_signal("timeout")

dbus.request_name("session", "com.console.rate")
dbus.add_match("session", "interface='com.console.rate', member='rateWidget' " )
dbus.connect_signal("com.console.rate", 
  function (...)
    local data = {...}
    local dbustext = data[2]
    rateWidget:set_text(dbustext)
  end)
{% endhighlight lua %}

Let's have a look at some important lines:

Line **4**: creation of text widget.
Line **7**: creation of a timer which will fire every hour.
Line **8**: second parameter, an anonymous function, will be called when timer will have a timeout signal.
Line **9**: function which sends the execution result of a script (line **14**) to DBus.
Line **16**: timer starts.
Line **18**: very important part, without emitting the signal explicitly it will be fired only after one hour and widget will be empty, so we fire the signal manually.
Lines **20**-**27**: requesting the script output from DBus.
Line **26**: setting the widget text.

>You can read more about sending messages to DBus in this post [Use DBus instead of pread/popen/spawn_in_shell]({{site.url}}/2015/09/fix-awesome-freezes/)
{: .note}

Ok, widget is ready to be used in **rc.lua**:

{% highlight lua %}
require("RatesWidget.rates") -- set the dependency
...
right_layout:add(rateWidget) -- add widget 
{% endhighlight lua %}

# Conclusion

Using this approach you can easily create text widgets which will display any text information - such as information about your system:

{% highlight bash %}
~ df -h /dev/sda2 | grep -P '\d\d%' -o # percentage of available place on sda2 partition
29%
{% endhighlight bash %}
or output of a script, as it was shown in this example. 
I use the same approach in [email widget]({{site.url}}/2015/12/email-widget-for-awesome-wm/): python script gets number of unread emails in my mailbox.
You can set the timer to update widget's value as frequently as you want (for the sake of tutorial in rates widget the timeout is set to half an hour, but actually API is updated every day).
Another good point here is using DBus to prevent Awesome from freezing, so Awesome doesn't wait for script or command to finish execution, result is sent to DBus and then it is taken from it when requested.

The code could be found in the [girhub repo](https://github.com/streetturtle/AwesomeWM/tree/master/RatesWidget).

If something is unclear or if there is any questions please let me know in the comments below, I will be happy to answer :)
