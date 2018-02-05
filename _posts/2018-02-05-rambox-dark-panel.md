---
layout: post
title: Rambox dark panel
date:   2018-02-05 08:08
description: Rambox doesn't have a dark theme yet, but you can mimic it easily.
comments: true
tags:
- rambox
---

I was suffering from white Rambox panel for some time, I even thought to change its sources and build it manually to make it dark. But finally I found a solution, even though it's temporary - you'll have to do it every time you run Rambox.

Basically you need to open the Developer Tools window of Rambox (not the Service) by clicking on **Window** -> **Toggle Developers Tools**, open Console tab and execute the following piece of JS:


```js
document.querySelector('.x-tab-bar').style.backgroundColor='#20272D';
document.querySelectorAll('.x-tab').forEach(function(el){el.style.backgroundColor='#444';});
```

First line sets the color of the bar and second of the tabs. Result will look following way:

![rambox dark panel]({{ "/images/2018/rambox-dark-panel.png" | relative_url }}){:.center-image}


