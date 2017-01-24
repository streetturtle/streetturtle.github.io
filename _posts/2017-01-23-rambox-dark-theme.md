---
layout: post
title:  "Rambox dark theme"
date:   2017-01-23 10:47:45
comments: true
description: Rambox allows having separate application for messaging services, which actually is a simplified version of Chrome. The drawback here is lack of extensions, namely Stylish and CareYourEyes because some services provide dark theme out of the box, like GMail, but Slack or Telegram doesn't have it. Let's see how this could be improved.
tags: 
- rambox
share: true
---

Rambox allows having separate application for messaging services, which actually is a simplified version of Chrome. The drawback here is lack of extensions, namely Stylish and CareYourEyes because some services provide dark theme out of the box, like GMail, but Slack or Telegram doesn't have it. Let's see how this could be improved.

One of the biggest differences between [Franz](http://meetfranz.com/) and [Rambox](http://rambox.pro/) is customizability of Rambox - it allows running custom JS code per service. With such cool feature you can apply custom CSS per service (styles could be taken from [userstyles.org](https://userstyles.org/)) using [Custom Code](https://github.com/saenzramiro/rambox/wiki/Inject-JavaScript-Code) feature of Rambox. 

To use it simply grab CSS from userstyles.org, remove `@-moz-document` wrapper, paste CSS in following snippet and put it in Custom Code field in service's advanced settings:

```js
function applycss(css){
    var head = document.getElementsByTagName('head')[0];
    var s = document.createElement('style');
    s.setAttribute('type', 'text/css');
    s.appendChild(document.createTextNode(css));
    head.appendChild(s);
 }
applycss(`
// css goes here
`);
```

