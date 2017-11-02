---
layout: post
title:  "Awesome taglist for Awesome WM"
date:   2017-07-20 10:47:45
comments: true
description: It's cool coincidence that default number of tags is the same as number of letters in 'AwesomeWM', isn't it? =) 
tags: 
- awesome wm
---

> Check the updated article in one of the Awesome WM [recipe](https://awesomewm.org/recipes/awesome-taglist/)
{:.note}

Here is pretty nice-looking and super easy way to customize taglist! The idea is simple - literally write 'awesomewm' in the taglist using letters from the awesomewm logo:

![awesome-taglist]({{site.url}}/images/awesome-taglist.png){:.center-image}

To customize the taglist the same way you need to install font which I generated using [icomoon.io](https://icomoon.io/) service from the svg images of letters from the logo. You can get it from my [github]({{site.url}}/css/awesomewmfont.ttf). 
And then simply name your tags in **rc.lua** using this font:

![awesometaglist]({{site.url}}/images/awesome_taglist_2.png){:.center-image}


At the beginning I tried to use svg images directly in the tags, but had too many problems trying to align them properly and getting rid of the gap between tags. And for the text names this is done by default.  
Another good thing about using font instead of images is that it's really easy to theme using Beautiful theme library whereas for images you'd need to create several images with the same color (for focus, urgent, etc.). For example in my current configuration I use following colors:

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
