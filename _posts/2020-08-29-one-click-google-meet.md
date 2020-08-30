---
layout: post
title: Google Meet meeting in one shortcut
date: 2020-08-29
description: 
tags: 
---

While WFH for almost half a year already I found myself creating quite a lot Google Meet meetings, as it's much faster to discuss something when you talk to a person, rather than over the text messages. However, creating a meeting takes some time, as you need to perform following actions: 

 - Switch to a browser
 - Open meet.google.com
 - Click "Join or start a meeting"
 - Type a nickname or click to skip this step
 - Copy link to the meeting to share

All those actions could be automated in a following script (or a three-liner command), which then can be executed with a shortcut:

```bash
#!/bin/bash
# Open a new meeting
xdg-open https://meet.google.com/new
# Wait till it creates a new 'room'
sleep 2
# Get the url to the meeting
xwininfo -tree -root | grep -oE 'https://[^ ]+' | xclip -selection clipboard
```

To make it work, you need to have `xclip` installed, to be able to write to the clipboard, and a browser extension, which adds the url to the window title.  

For Google Chrome I use this one: [URL in title](https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb), which should be setup first:
In Extension's Options set following:
 - Tab title format: {title} - {protocol}://{hostname}{port}/{path}
 - Page URL filtering: Whitelist
 - URL filters: ^https://meet\.google\.com/

And for Firefox this one: [Add URL to Window Title](https://addons.mozilla.org/en-US/firefox/addon/add-url-to-window-title/)

Then install the script to some folder, `opt` for example (you can get it from [gist](https://gist.github.com/streetturtle/82f2cd547e627f76e09f640701369545)), make it executable, and add a link to the `/usr/local/bin` to be able to call it from everywhere:

```bash
$ git clone https://gist.github.com/82f2cd547e627f76e09f640701369545.git
$ sudo cp ./82f2cd547e627f76e09f640701369545/start-a-meeting /opt
$ sudo chmod +x /opt/start-a-meeting
$ sudo /opt sudo ln -sf /opt/start-a-meeting /usr/local/bin/start-a-meeting
```

Now you can either call `start-a-meeting` from a terminal, or map a keyboard shortcut to it, and have a new meeting opened in a browser and a link in the clipboard. 