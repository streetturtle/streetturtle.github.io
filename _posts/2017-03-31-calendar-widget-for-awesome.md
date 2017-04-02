---
layout: post
title:  "Simple calendar widget for Awesome WM"
date:   2017-03-31 10:47:45
comments: true
description:  I've been using Awesome for quite some time - more than 4 years already, and from time to time I needed a simple calendar widget - without any integrations, styles and dependencies, as simple as possible. I tried few but didn't like them. And only today I finally decided to try to make such calendar widget for Awesome. It turned out that it's quite simple.
tags: 
- awesome wm
share: true
---

I've been using Awesome for quite some time - more than 4 years already, and from time to time I needed a simple calendar widget - without any integrations, styles and dependencies, as simple as possible. I tried few but didn't like them. And only today I finally decided to try to make such calendar widget for Awesome. It turned out that it's quite simple. Here is how it looks like:

![Calendar-widget]({{ site.url }}/images/calendar-widget.png){:.center-image}

Default Awesome configuration already has time and current date widget based on textbox (~line 150 of the **rc.lua**):

{% highlight lua %}
{% raw %}
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
{% endraw %}
{% endhighlight %}

The idea of calendar widget is to reuse `mytextclock` and add naughty notification with calendar to it when mouse button clicks on it. 

Let's find out how to print calendar. Ubuntu distribution of linux has handy unitlity  `cal` which prints calendar for the current month with current day highlighted:

{% highlight sh %}
$ cal
     March 2017       
Su Mo Tu We Th Fr Sa  
          1  2  3  4  
 5  6  7  8  9 10 11  
12 13 14 15 16 17 18  
19 20 21 22 23 24 25  
26 27 28 29 30 31 
{% endhighlight %}


>Note that highlighting is done with some unprintable characters.
{:.note}

After I played a bit with `cal` I came up with following command:

{% highlight sh %}
$ ncal -3MC | sed 's/_.\(.\)/+\1-/g'
   February 2017           March 2017            April 2017       
Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  Mo Tu We Th Fr Sa Su  
       1  2  3  4  5         1  2  3  4  5                  1  2  
 6  7  8  9 10 11 12   6  7  8  9 10 11 12   3  4  5  6  7  8  9  
13 14 15 16 17 18 19  13 14 15 16 17 18 19  10 11 12 13 14 15 16  
20 21 22 23 24 25 26  20 21 22 23 24 25 26  17 18 19 20 21 22 23  
27 28                 27 28 29 30 +3-+1-        24 25 26 27 28 29 30 
{% endhighlight %}

Some explanations:

 - `ncal` - is a bit improved version of `cal`. Here it is used because strangely in `cal` it's not possible to make Monday first day of week, however it's possbile in `ncal`.  But `ncal` prints transposed calendar, so it's needed to be printed in `cal`'s way, which is done by providing `-C` option.
 - `-M` makes Monday first day of week. 
 - `-3` prints three months (previous, current and next) instead of one.
 - `sed` is needed for current date highlighting - it wraps current date in + and - signs, which will be handled after in lua.

And now we just connect button click signal to `mytextclock` and call naughty notification with the ouput of a command above - just add the following snippet right after mytextclock declaration in **rc.lua** and restart Awesome:

{% highlight lua %}
{% raw %}
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
local cal_notification
mytextclock:connect_signal("button::release",
    function()
        if cal_notification == nil then
            awful.spawn.easy_async([[bash -c "ncal -3MC | sed 's/_.\(.\)/+\1-/g'"]],
                function(stdout, stderr, reason, exit_code)
                    cal_notification = naughty.notify{
                        text = string.gsub(string.gsub(stdout, 
                                                       "+", "<span foreground='red'>"), 
                                                       "-", "</span>"),
                        font = "Ubuntu Mono 9",
                        timeout = 0,
                        width = auto,
                        destroy = function() cal_notification = nil end
                    }
                end
            )
        else
            naughty.destroy(cal_notification)
        end
    end)
{% endraw %}
{% endhighlight %}
