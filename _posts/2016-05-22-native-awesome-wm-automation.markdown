---
layout: post
title: "Native user automation tool for Awesome WM"
date: "2016-05-22 21:11:47 +0200"
description: When I was using Windows I really liked the AutoHotKey tool. After moving to Linux and Awesome WM I missed some of the features of AHK, but finally I found time to investigate the alternatives and came up with native solution for Awesome WM, which I'd like to share.
comments: true
share: true
tags: 
 - awesome wm
---

When I was using Windows I really liked the AutoHotKey tool. After moving to Linux and Awesome WM I missed some of the features of AHK, but finally I found time to investigate the alternatives and came up with native solution for Awesome WM, which I'd like to share.

# Hotkeys

In AHK you can: 

> Remap keys and buttons on your keyboard, joystick, and mouse.
> Create hotkeys for keyboard, joystick, and mouse.
> Essentially any key, button or combination can become a hotkey.

In Awesome it's super easy to create shortcuts and map script execution to them:

{% highlight lua %}
awful.key({ modkey, }, "/", function () awful.util.spawn("sp play", false) end),
{% endhighlight lua %}

so this part more or less solved depending of complexity of hotkeys you want to use.

# Interaction with browser/apps

Another thing I used quite a lot is possibility to open browser on address depending on what text I have in clipboard/or type in input box.

## Input box

Since Awesome is tiling manager one of the biggest problem of AHK alternatives (like AutoKey) is pop-up windows - depends of the layout of current workspace they can appear in strange places and break the current layout of windows. But this problem easily solves with custom prompt - the same one which is used to execute commands `Mod4`{:.key}+`R`{:.key}. 

So lets create custom prompt which will be used for our automation needs, let's map it with `Mod4`{:.key}+`E`{:.key} combination and for the sake of test show notification with inserted text:

{% highlight lua %}
awful.key({ modkey }, "e", function ()
  awful.prompt.run({ prompt = "Magic prompt: " }, mypromptbox[mouse.screen].widget,
    function (text)
      naughty.notify({text = 'Inserted:' .. text})
    end)
end)
{% endhighlight lua %}

Now using regexps it's quite easy to write rules and run different apps/scripts according to what was inserted in that prompt. For example following rules:

 - `calc` would open calculator application;
 - `so java` would open stackoverflow page with questions tagged 'java';
 - `wi cat` would open wikipedia page about cats;
 - anything else would open google search page for inserted text. 
 
would look like this:
 
{% highlight lua %}
awful.key({ modkey }, "e", function ()
  awful.prompt.run({ prompt = "Magic prompt: " }, mypromptbox[mouse.screen].widget,
    function (text)
      if string.find(text, '^calc$') then 
        awful.util.spawn_with_shell('gnome-calculator')
      elseif string.find(text, "^so%s") then
        awful.util.spawn_with_shell("google-chrome 'http://stackoverflow.com/questions/tagged/" .. string.gsub(text, 'so%s', '') .. "'")
      elseif string.find(text, "^wi%s") then
        awful.util.spawn_with_shell("google-chrome 'https://en.wikipedia.org/wiki/Special:Search?search=" .. string.gsub(string.gsub(text, 'wi%s', ''), ' ', '+') .. "'")
      else
        awful.util.spawn_with_shell("google-chrome 'https://google.com/search?query=" .. text .. "'")
      end
    end)
end)
{% endhighlight lua %}

> Note that lua regex patterns are a bit [specific](https://www.lua.org/pil/20.2.html)
{:.note}

## Clipboard

Here the idea is the same. But text is taken from clipboard. Awesome provides handy function - [selection()](https://awesomewm.org/doc/api/modules/selection.html) which gets the content of the clipboard. The function stays almost the same:

{% highlight lua %}
awful.key({ modkey }, "z", function()
  text = selection()
  if string.find(text, 'cal') then 
    awful.util.spawn_with_shell('zenity --calendar')
  elseif string.find(text, "^so%s") then
    awful.util.spawn_with_shell("google-chrome 'http://stackoverflow.com/questions/tagged/" .. string.gsub(text, 'so%s', '') .. "'")
  elseif string.find(text, "^wi%s") then
    awful.util.spawn_with_shell("google-chrome 'https://en.wikipedia.org/wiki/Special:Search?search=" .. string.gsub(string.gsub(text, 'wi%s', ''), ' ', '+') .. "'")
  else
    awful.util.spawn_with_shell("google-chrome 'https://google.com/search?query=" .. text .. "'")
  end
end),
{% endhighlight lua %}
