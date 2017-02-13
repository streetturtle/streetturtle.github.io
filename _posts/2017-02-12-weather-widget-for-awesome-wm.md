---
layout: post
title:  "Weather widget for Awesome WM"
date:   2017-02-12 10:47:45
comments: true
description: Tutorial on how to create a weather widget for Awesome WM v.4. 
tags: 
- awesome wm
share: true
---

# Prerequisite

### API
First of all we need to get weather information from somewhere. I found [openweathermap.org](http://openweathermap.org) which seems to be quite what we need. You need to create an account there to get the API key. After that you'll able to use weather API with limit of 60 calls per minute (which is more than enough).

### Socket library
Next thing is to call the endpoint. At first I thought to use python script as I did in [email-widget](https://github.com/streetturtle/AwesomeWM/tree/master/email-widget), but after few minutes of googling I discovered [luasocket](http://w3.impa.br/~diego/software/luasocket/) library which supports basic HTTP requests. So let's install it. Being on Ubuntu I was able to do so simply by

```bash
sudo apt-get install lua-socket
```

### JSON parsing
And the last preparation step is JSON parser, since weather API returns weather information in JSON. I found [github.com/rxi/json.lua](https://github.com/rxi/json.lua) which looks promising. To 'install' it put **json.lua** in **~/.config/awesome/** folder, so that it could be easily imported in weather widget's script.

# Widget

So let's craft an awesome widget!

Widget will consist of an icon - imagebox, which will show current weather conditions (sun, clouds, etc.) and textbox with current temperature. For icon I quite like the Arc icon theme, moreover there are many weather icons (at least more that in gnome theme). Ideally would be to put both widgets in another widget with horizontal layout, something like this:
 
```lua
weather_widget = wibox.widget {
    {
        widget = wibox.widget.imagebox,
        resize = false,
        image = path_to_icons .. "weather-clear-symbolic.svg"
    },
    {
        widget = wibox.widget.textbox,
        fong = "Play 9",
        text = "-9"
    },
   layout = wibox.layout.align.horizontal,
}
```
 
But then icon would't be aligned vertically because it is smaller than the height of wibox: ![screenshot]({{ site.url }}/images/weather-widget-post.png). As workaround I split widget declarations, so that icon has top margin:

```lua
local icon_widget = wibox.widget {
    {
        id = "icon",
        resize = false,
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(_, 0, 0, 3),
    set_image = function(self, path)
        self.icon.image = path
    end,
}
local temp_widget = wibox.widget{
    font = "Play 9",
    widget = wibox.widget.textbox,
}
weather_widget = wibox.widget {
    icon_widget,
    temp_widget,
    layout = wibox.layout.fixed.horizontal,
}
```

# Widget update

So we have widget, but it should be updated. With text widget it's simple, we just need to get the temperature from the response body and update widget's text. For that we'll need small handy function to convert Kelvin to Celsius:
 
```lua
function to_celcius(kelvin)
    return math.floor(tonumber(kelvin) - 273.15)
end
```

For the icon fortunately API has it's own [icon set](http://openweathermap.org/weather-conditions) and returns icon name. So we need to map API's icon names to Art icon names:
 
```lua
local icon_map = {
    ["01d"] = "weather-clear-symbolic.svg",
    ["02d"] = "weather-few-clouds-symbolic.svg",
    ...
```

And then have a timer to call the API and update widgets:

```lua
local resp
local weather_timer = timer({ timeout = 600 })
weather_timer:connect_signal("timeout", function ()
    local resp_json = http.request("http://api.openweathermap.org/data/2.5/weather?q=" .. city .."&appid=" .. open_map_key)
    resp = json.decode(resp_json)
    icon_widget.image = path_to_icons .. icon_map[resp.weather[1].icon]
    temp_widget:set_text(to_celcius(resp.main.temp)..'°')
end)
weather_timer:emit_signal("timeout")
```



# Notification

As for notification I use [naughty](https://awesomewm.org/doc/api/libraries/naughty.html). Nothing special here:

```lua
local notification
weather_widget:connect_signal("mouse::enter", function()
    notification = naughty.notify{
        icon = path_to_icons .. icon_map[resp.weather[1].icon],
        icon_size=20,
        text = '<b>Humidity:</b> ' .. resp.main.humidity .. '%<br><b>Temperature: </b>' .. to_celcius(resp.main.temp),
        timeout = 5, hover_timeout = 0.5,
        width = 200,
    }
end)
weather_widget:connect_signal("mouse::leave", function()
    naughty.destroy(notification)
end)
```

You can check the whole widget on [github](https://github.com/streetturtle/AwesomeWM/tree/master/weather-widget)