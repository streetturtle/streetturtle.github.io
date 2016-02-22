---
layout: post
title: "Spotify integration with Awesome WM"
date: 2016-02-15 12:09:06
comments: true
tags: 
 - awesome wm
description: After moving to Spotify I was feeling myself helpless without possiblity to pause/play tracks with keyboard shortcut as I did it with Rhythmbox. And also could be cool to display current track in the wibox. Here is what I come up with.
comments: true
---

# Control Spotify from shell

First thing to do is to be able to control spotify from command line. Spotify has DBus interface and suppots MPRIS2 DBus [specification](https://specifications.freedesktop.org/mpris-spec/latest/Player_Interface.html). But I've found a bash script, which wraps it in convenient functions [here](https://gist.github.com/wandernauta/6800547). Since I'd like to display current artist and song in the Awesome widget I need them to be in one line, so I've added another method to the bash script and  added it in my Github:

{% highlight bash %}
function sp-current-oneline {
  sp-metadata | grep -E "(title|artist)" | sed 's/^\(.\)*|//' | sed ':a;N;$!ba;s/\n/ /g'
}
{% endhighlight bash %}

Let's install it:

{% highlight bash%}
git clone https://gist.github.com/fa6258f3ff7b17747ee3.git
chmod +x
sudo cp ./sp /usr/local/bin/
{% endhighlight bash%}

# Keyboard shortcuts

Nothing special here, I prefer to use **.** for next track, **,** for previous and **/** for play/pause:

{% highlight lua %}
awful.key({ modkey,        }, "/", function () awful.util.spawn("sp play", false) end),
awful.key({ modkey,        }, ".", function () awful.util.spawn("sp next", false) end),
awful.key({ modkey,        }, ",", function () awful.util.spawn("sp prev", false) end),
{% endhighlight lua %}
