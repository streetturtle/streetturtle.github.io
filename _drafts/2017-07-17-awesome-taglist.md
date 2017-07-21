---
layout: post
title:  "Awesome taglist for Awesome WM"
date:   2017-07-20 10:47:45
comments: true
description: It's cool coincidence that default number of tags is the same as number of letters in 'AwesomeWM', isn't it? =) 
tags: 
- awesome wm
---

I think some people already did it, but I still think that it's pretty cool-looking way to customize taglist! The idea is simple - literally write 'awesomewm' in the taglist using letters from awesomewm's logo:

![awesome-taglist]({{site.url}}/images/awesome-taglist.png){:.center-image}

To customize the taglist the same way you need to install font which I generated using [icomoon.io](https://icomoon.io/) service from the svg images of letters from the logo. You can get it from my [github](http://github.com/streetturtle/awesome-wm-widgets). 
And then simply name your tags using this font:

<style>
@font-face {
    font-family:"AgencyFBRegular";
    src: url({{site.url}}/css/awesome.ttf/)
}
</style>

>rc.lua
{:.filename}
{% highlight lua %}
...
-- Each screen has its own tag table.
awful.tag({ "", "", "", "", "", "", "", "", ""}, 
    s, awful.layout.layouts[1])
...
{% endhighlight %}

At the beginning I tried to put svg images directly in the tags, but had too many problems trying to align them properly and get rid of the gap between tags.
Another good thing about using font instead of images is that it's really easy to theme using beautiful themes. For example I'm using colors inspired by [pro-gotham](https://github.com/stobenski/pro/tree/master/themes/pro-gotham) theme:

>theme.lua
{:.filename}
{% highlight lua%}
...
theme.taglist_fg_focus    = "#3992af"
theme.taglist_fg_occupied = "#164b5d"
theme.taglist_fg_urgent   = "#ED7572"
theme.taglist_fg_empty    = "#828282"
theme.taglist_spacing     = 2
theme.taglist_font        = "awesomewm 11"
...
{% endhighlight lua%}