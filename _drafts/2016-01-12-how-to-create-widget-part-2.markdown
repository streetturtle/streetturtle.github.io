---
layout: post
title: "How to create widget for Awesome WM - part 2"
date: 2016-01-12 12:09:06
comments: true
tags: 
 - awesome wm
description: It's a second part ot tutorial about creating simple widgets for Awesome WM. 
comments: true
---

# Introduction

In the first part we've created a text widget which displays a currency rate between Euro and Swiss Frank. Now let's add a notification pop-up with more curencies which will appear when mouse is hovers over the widget. At the end it would look like this: ![]() 

# Get the currency rate

This part is very similar, same service but with different parameters and slightly different response. GET to the url: [api.fixer.io/latest?symbols=USD,EUR,JPY,GBP,CHF,CAD,RUB](http://api.fixer.io/latest?symbols=USD,EUR,JPY,GBP,CHF,CAD,RUB) return following JSON:

{% highlight json %}
{
  "base": "EUR",
  "date": "2016-01-11",
  "rates": {
    "CAD": 1.5336,
    "CHF": 1.0863,
    "GBP": 0.74705,
    "JPY": 128.33,
    "RUB": 81.9975,
    "USD": 1.0888
  }
}
{% endhighlight json %}

So now we need a script (again in Python) to make a GET request and return the part of the response we are interesting in. 

>My version of python is **2.7.6**, this script could look different for version 3.
{: .note}

{% highlight python %}
#!/usr/bin/python

import requests
import json

r = requests.get("http://api.fixer.io/latest?symbols=USD,EUR,JPY,GBP,CHF,CAD,RUB")
resp = json.loads(r.content)
rates = resp["rates"]

for currency, rate in rates.items():
	print currency, rate
{% endhighlight python %}

Save it in `~/.config/awesome/RateWidget/` with name **ratesPopup.py** and test it:

{% highlight bash %}
~/.config/awesome/RatesWidget ❯ python ratesPopup.py
USD 1.0888
CHF 1.0863
RUB 81.9975
JPY 128.33
GBP 0.74705
CAD 1.5336
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
Line **8**: second parameter, an anonymus function, will be called when timer will have a timeout signal. 
Line **9**: function which sends the execution result of a script (line **14**) to DBus.
Line **16**: timer starts.
Line **18**: very important part, without emiting the signal explicitly it will be fired only after one hour and widget will be empty, so we fire the signal manualy.
Lines **20**-**27**: requesting the script ouput from DBus.
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

The code could be found in the [gihub repo](https://github.com/streetturtle/AwesomeWM/tree/master/RatesWidget).

If something is unclear or if there is any questions please let me know in the comments below, I will be happy to answer :)