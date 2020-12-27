---
layout: post
title: Client is missing an icon
date: 2020-12-26
description: I didn't have an icon for Rambox and finally found how to add it
tags: 
 - awesome wm
---

For some reason Rambox didn't have an icon on the tasklist and it looked following way:

![rambox-no-icon]({{site.url}}/images/2020/rambox-no-icon.png)

Adding following lines to the signal handler finally resolved the issue (note that default configuration already has this handlerg):

```lua
client.connect_signal("manage", function (c)
    if c.class == "Rambox" then
        local icon = gears.surface("/home/pmakhov/Pictures/256x256.png")
        c.icon = icon._native
        icon:finish()
    end
end)
```

![rambox-with-icon]({{site.url}}/images/2020/rambox-with-icon.png)

Based on this SO answer: [stackoverflow.com/a/30379815/1252056](https://stackoverflow.com/a/30379815/1252056)