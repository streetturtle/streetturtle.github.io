---
layout: post
title: Awesome WM customization / development setup
date: 2020-04-13 16:48:45
tags: 
- awesome wm
---

# Setup

The simplest way to customize your config is to open `~/.config/awesome/rc.lua` and start editing the file, then restart awesome and see the result. But this approach brings few issues. You may break something in config (like forget to put a comma) which will result in a broken config and awesome will load default config file. So now you need to fix the problem, restart again and so on.

Another way is to spawn a new instance of awesome in a window by using [Xephyr](https://en.wikipedia.org/wiki/Xephyr) and point it to a copy of your config. Then when your changes are ready, simply replace your existing config by the one you used on a 'guest' instance of awesome. This approach is a safe way of trying new widgets, themes, configs, etc. Especially when working with widgets, you need to restart the config quite often, to see your changes. To run awesome in a window use following command:

```bash
Xephyr :5 -resizeable  & sleep 1 ; DISPLAY=:5 awesome -c ./rc.lua
```

Another benefit of this approach is you can see errors and stacktrace in terminal, which sometimes may reveal some internal problem of the widget, for example below is a stacktrace of one of my widget:

```
2020-04-07 20:44:55 E: awesome: Failed to open file '/tmp/spotify:track:7cMFjxhbXBpOlais7KMF3jtest': No such file or directory
stack traceback:
	/usr/share/awesome/lib/gears/surface.lua:99: in function </usr/share/awesome/lib/gears/surface.lua:91>
	(...tail calls...)
	/usr/share/awesome/lib/wibox/widget/imagebox.lua:96: in function 'wibox.widget.imagebox.set_image'
	/usr/share/awesome/lib/wibox/widget/base.lua:480: in upvalue 'drill'
	/usr/share/awesome/lib/wibox/widget/base.lua:563: in function 'wibox.widget.base.make_widget_declarative'
	(...tail calls...)
	...ome/awesome-wm-widgets/spotify-player/spotify-player.lua:93: in upvalue 'callback'
	/usr/share/awesome/lib/awful/widget/watch.lua:77: in function </usr/share/awesome/lib/awful/widget/watch.lua:76>
	(...tail calls...)
	/usr/share/awesome/lib/awful/spawn.lua:481: in function </usr/share/awesome/lib/awful/spawn.lua:475>
	[C]: in function 'xpcall'
	/usr/share/awesome/lib/gears/protected_call.lua:36: in function </usr/share/awesome/lib/gears/protected_call.lua:35>
	(...tail calls...)
	/usr/share/awesome/lib/awful/spawn.lua:577: in upvalue 'done'
	/usr/share/awesome/lib/awful/spawn.lua:592: in function </usr/share/awesome/lib/awful/spawn.lua:584>

```

So finally you endup with a convenient setup, which reminds a simple web development: you change the code, restart 'guest' awesome, see the changes, if something goes wrong check logs in terminal, in which you started Xephyr:

![setup]({{ "/images/2020/setup.png" | relative_url }}){:.center-image}