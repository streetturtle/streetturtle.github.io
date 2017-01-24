---
layout: post
title:  "Upgrading to Awesome WM 4"
date:   2017-01-06 10:47:45
comments: true
description: Several thing I did after upgrading to Awesome WM 4.0
tags: 
- awesome wm
share: true
---

# Installation

Currently there is no .deb package available, at least I didn't find any. So you'll need to build it. After struggling with failed dependencies (like `xcb-xrm`) and dependencies of those dependencies I found quite handy docker image which allows easily build .deb package: [github.com/elw00d/awesome-deb-docker](https://github.com/elw00d/awesome-deb-docker). Just follow the instructions of Readme file of the repo. After you have a .deb, install it:

```bash
$ sudo dpkg -i awesome_4.0.0-4~trusty0_amd64.deb
```
and replace your old **rc.lua** with the new one from **/etc/xdg/awesome/rc.lua**:

```bash
$ mv ~/.config/awesome/rc.lua  ~/.config/awesome/rc3.5.lua
$ cp /etc/xdg/awesome/rc.lua ~/.config/awesome/
```
and do logout/login. Hopefully now you have a vanilla Awesome 4 installation which could be easily checked:

```bash
$ awesome -v
awesome v4.0 (Harder, Better, Faster, Stronger)
 • Compiled against Lua 5.2.3 (running with Lua 5.2)
 • D-Bus support: ✔
 • execinfo support: ✔
 • RandR 1.5 support: ✘
 • LGI version: 0.9.0
```

# Few things after installation

## Titlebar

First thing I didn't like is the top panel (titlebar) of the windows with app name and control buttons (floating, maximized, sticky, etc.):

![Awesome-screenshot]({{site.url}}/images/awesome-wm-4-top-panel.png){:.center-image}

To remove it comment (or edit to add titlebar to some special apps - since it's a rule) following section of the config file:

```lua
-- Add titlebars to normal clients and dialogs
{ rule_any = {type = { "normal", "dialog" }
  }, properties = { titlebars_enabled = true }
},
```

## Autostart apps

Slightly modified version of well-known snippet:

```lua
function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("clipit")
run_once("nemo")
```

## Pread and DBus

In previous version it was a bit complicated to refresh some widgets, using DBus was a good workaround, but not very easy to use. Version 4 has handy [function](https://awesomewm.org/apidoc/libraries/awful.spawn.html#easy_async) `easy_async`:

```lua
awful.spawn.easy_async([[bash -c 'acpi | cut -d, -f 2,3']],
    function(stdout, stderr, reason, exit_code)   
      naughty.notify{
        text = stdout,
        title = "Battery status",
        timeout = 5, hover_timeout = 0.5,
        width = 200,
      }   
    end
```

## Shortcuts table

Popup table with available shortcuts, you could add yours:


```lua
awful.key({ modkey, }, "/", function () awful.spawn("sp play", false) end, {description = "spotify play/stop", group = "Music"}),
awful.key({ modkey, }, ".", function () awful.spawn("sp next", false) end, {description = "spotify next", group = "Music"}),
awful.key({ modkey, }, ",", function () awful.spawn("sp prev", false) end, {description = "spotify previous", group = "Music"})
```