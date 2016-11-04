---
layout: post
title:  "Use Google Keep in Awesome WM"
date:   2015-08-04 16:23:45
comments: true
categories:
description: 
tags: 
- awesome wm
- ubuntu
---

Google keep is very useful in taking quick notes. Recently I've found out how to use is as a standalone app in Awesome!

First step is quite easy: install Google Keep extension in Chrome, then go to apps, right click on it and choose create shortcuts option, in next window choose Desktop.

Done! But run apps using desktop entry from Awesome is not geeky at all :)

Open a desktop entry which was created by chrome:

{% highlight bash %}
vim ~/Desktop/chrome-hmjkmjkepdijhoojdojkdfohbdgmmhki-Default.desktop
{% endhighlight bash %}

and copy Exec part of file, it should look something like `/opt/google/chrome/google-chrome --profile-directory=Default --app-id=hmjkmjkepdijhoojdojkdfohbdgmmhki`.

Next create a file in `/usr/local/bin`, let's name it *keep*, make it executable:

{% highlight bash %}
cd /usr/local/bin
sudo touch keep
sudo chmod +x keep
{% endhighlight bash %}

And insert in that file Exec part of desktop entry you've copied followed by ampersand `&`:

{% highlight bash %}
/opt/google/chrome/google-chrome --profile-directory=Default --app-id=hmjkmjkepdijhoojdojkdfohbdgmmhki &
{% endhighlight bash %}

Now to run keep you can use Mod4+r using `keep` command.