---
layout: post
title: "How to create widget for Awesome WM - part 2"
date: 2016-01-12 12:09:06
comments: true
tags: 
 - awesome wm
description: It's a second part of tutorial about creating simple widgets for Awesome WM. In this part we'll add a notification popup which will appear when mouse enters the widget area and will show rates for several other currencies.
comments: true
---

# Introduction

In the first part we've created a text widget which displays a currency rate between Euro and Swiss Frank. Now let's add a notification pop-up with more currencies which will appear when mouse is hovered over the widget. At the end it would look like this: 
![RatesPopup]({{site.url}}/images/ratesWidgetPopup.png){: .center-image}

# Get the currency rate

This part is very similar, same service but with different parameters and slightly different response. HTTP GET to the url: [api.fixer.io/latest?symbols=USD,EUR,JPY,GBP,CHF,CAD,RUB](http://api.fixer.io/latest?symbols=USD,EUR,JPY,GBP,CHF,CAD,RUB) returns following JSON:

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

So now we need a script (again in Python) to make a GET request and return the part of the response we are interested in. 

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

>My version of python is **2.7.6**, this script could look different for version 3.
{: .note}

Save it under `~/.config/awesome/RateWidget/` with name **ratesPopup.py** and test it:

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

The idea is to show a popup notification when mouse enters the widget area. There is no reason to use DBus here, because we'd like to call script at the moment mouse enters the widget and it doesn't take too much time to execute. 

But if execution of your script takes some time you either 
 
 - should wait until it finishes (because Awesome will be locked by the script) or 
 - use DBus to write script output to some file and simply show the content of the file or use some other tricks.

Add following code to the end of already existing **rates.lua**:

{% highlight lua linenos %}
...
function showRatesPopup()   
    naughty.notify({
        title = "Rates",
        text = awful.util.pread("python ~/.config/awesome/rates/ratesPopup.py"), 
        icon = "/home/username/.config/awesome/rates/currency.png",
        icon_size = 100,
        timeout = 10, 
        width = 300,
        padding = 100,
        fg = "#ffffff",
        bg = "#333333aa",
      })
end

-- Icon which shows unread emails when hover
rateWidget:connect_signal("mouse::enter", function() showRatesPopup() end)
{% endhighlight lua %}

>For some reason path to the icon should be used without tilde (~) so you need to provide absolute path to the file
{: .note}

I think this part is quite simple and self explanatory. And since we are using naughty add `local naughty = require("naughty")` to the top of the file.

That's it! Now you can test it by restarting Awesome and hover your mouse over the widget. And just for info, I use this approach for the [email widget]({{site.url}}/2015/12/email-widget-for-awesome-wm) and for the [battery widget]({{site.url}}/battery-and-sound-volume-widged-for-awesomewm) and it works quite good so far!

Please let me know in the comments below if something is unclear or seems to be wrong, I'll be happy to answer or help you :) The code could be found in [github repo](https://github.com/streetturtle/AwesomeWM/tree/master/RatesWidget).