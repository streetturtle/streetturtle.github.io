---
layout: post
title: "Spotify integration with Awesome WM"
date: 2016-02-22 12:09:06
tags: 
 - awesome wm
description: After moving to Spotify I was feeling myself helpless without possibility to pause/play tracks with keyboard shortcut as I did it with Rhythmbox. And also could be cool to display current track in the wibox. Here is what I came up with.
comments: true
share: true
---

# Control Spotify from shell

First thing to do is to be able to control spotify from command line. Spotify has DBus interface and supports MPRIS2 DBus [specification](https://specifications.freedesktop.org/mpris-spec/latest/Player_Interface.html). But I've found a bash script, which wraps it in convenient functions [here](https://gist.github.com/wandernauta/6800547). Since I'd like to display current artist and song in the Awesome widget I need them to be in one line, so I've added another method to the bash script and added it in my [Github](https://gist.github.com/streetturtle/fa6258f3ff7b17747ee3):

{% highlight bash %}
function sp-current-oneline {
  sp-metadata | grep -E "(title|artist)" | sed 's/^\(.\)*|//' | sed ':a;N;$!ba;s/\n/ /g'
}
{% endhighlight bash %}

Let's install it:

{% highlight bash%}
git clone https://gist.github.com/fa6258f3ff7b17747ee3.git
cd ./fa6258f3ff7b17747ee3 
chmod +x
sudo cp ./sp /usr/local/bin/
{% endhighlight bash%}

So from now you are able to control Spotify from command line! Try it:  `sp help`. 

# Widget, Awesome widget

> This widget is not compatible with v4.0 of Awesome WM. For v4.0 use [this](https://github.com/streetturtle/AwesomeWM/tree/master/spotify-widget) one
{:.note}

Create **spotify.lua** with following content under **/home/.config/awesome** or clone it from this [repo](https://github.com/streetturtle/AwesomeWM3/tree/master/Spotify).  

{% highlight lua %}
local wibox = require("wibox")
local awful = require("awful")

spotify_widget = wibox.widget.textbox()
spotify_widget:set_font('Play 9')

function updateSpotifyWidget(widget)
  local current = awful.util.pread('sp current-oneline')
  widget:set_text(current)
end

spotify_timer = timer ({timeout = 10})
spotify_timer:connect_signal ("timeout", function() updateSpotifyWidget(spotify_widget) end) 
spotify_timer:start()

spotify_timer:emit_signal("timeout")
{% endhighlight lua %}

Now include it in **rc.lua** and add to your wibox:

{% highlight lua%}
require("spotify")
...
right_layout:add(spotify_widget)
{% endhighlight lua%}

Restart awesome, turn on some music and you'll see it: ![spotify widget]({{site.url}}/images/spotifyWidget.png)

# Keyboard shortcuts

Nothing special here, I prefer to use `Mod4`{:.key}+`.`{:.key} for next track, `Mod4`{:.key}+`,`{:.key} for previous and `Mod4`{:.key}+`/`{:.key} for play/pause:

{% highlight lua %}
awful.key({ modkey, }, "/", function () awful.util.spawn("sp play", false) end),
awful.key({ modkey, }, ".", function () awful.util.spawn("sp next", false) end),
awful.key({ modkey, }, ",", function () awful.util.spawn("sp prev", false) end)
{% endhighlight lua %}
