---
layout: post
title: "E-mail widget for Awesome WM"
date: 2015-12-22 12:09:06
comments: true
tags: 
 - awesome wm
description: Email widget for Awesome WM  
comments: true
---

This widget consists of an icon with counter which shows number of unread emails: ![email icon]({{site.url}}/images/emailWidgetScrnsht.png)
and a popup message which appears when mouse hovers over an icon: ![email popup]({{site.url}}/images/emailWidgetScrnsht2.png)

## Installation

To install it either clone [EmailWidget](https://github.com/streetturtle/AwesomeWM/tree/master/EmailWidget) project under `~/.config/awesome/` or download a .zip archive and unzip it there.

After provide your credentials in python scripts so that they could connect to server and add following lines in your **rc.lua** file:

{% highlight lua %}
require("email")
...
right_layout:add(emailWidget_icon)
right_layout:add(emailWidget_counter)
{% endhighlight lua %}

## How it works

This widget uses the output of two python scripts, first is called every 5 minutes - it returns number of unread emails and second is called when mouse hovers over an icon and displays content of those emails. For both of them you'll need to provide your credentials and imap server. For testing they can simply be called from console:

{% highlight bash %}
python ~/.config/awesome/email/countUnreadEmails.py 
python ~/.config/awesome/email/readEmails.py 
{% endhighlight bash %}

### Number of unread emails

This script prints out number of unread emails:

{% highlight python %}
#!/usr/bin/python

import imaplib
import email

M=imaplib.IMAP4_SSL("imap.whatever.com", 993)
M.login("username","password")

status, counts = M.status("INBOX","(MESSAGES UNSEEN)")

if status == "OK":
  unread = int(counts[0].split()[4][:-1])
else:
  unread = "N/A" 

print(unread)
{% endhighlight python %}

### Subject and sender of email

And this prints subject, sender and sent time of the email. Since content of email sometimes can be in HTML I decided not to parse it because it could be quite tricky. 

{% highlight python %}
#!/usr/bin/python

import imaplib
import email
import datetime

def process_mailbox(M):
    rv, data = M.search(None, "UNSEEN")
    if rv != 'OK':
        print "No messages found!"
        return

    for num in data[0].split():
        # rv, data = M.fetch(num, '(RFC822)')     # mark us read
        rv, data = M.fetch(num, '(BODY.PEEK[])')  # don't mark us read
        if rv != 'OK':
            print "ERROR getting message", num
            return

        msg = email.message_from_string(data[0][1])
        print 'From:', msg['From']
        print 'Subject: %s' % (msg['Subject'])
        date_tuple = email.utils.parsedate_tz(msg['Date'])
        if date_tuple:
            local_date = datetime.datetime.fromtimestamp(
            email.utils.mktime_tz(date_tuple))
            print "Local Date:", local_date.strftime("%a, %d %b %Y %H:%M:%S")
            print

M=imaplib.IMAP4_SSL("imap.whatever.com", 993)
M.login("username","password")

rv, data = M.select("INBOX")
if rv == 'OK':
    process_mailbox(M)
    M.close()

M.logout()
{% endhighlight python %}

## Lua Widget

Now let's combine everything together in lua file:

{% highlight lua %}
emailWidget_icon = wibox.widget.imagebox()
emailWidget_icon:set_image("~/.config/awesome/email/email.png")
emailWidget_icon:connect_signal("mouse::enter", function() showEmailWidgetPopup() end)

emailWidget_counter = wibox.widget.textbox()

emailWidget_times = timer ({timeout = 5})
emailWidget_times:connect_signal ("timeout", 
	function ()
		awful.util.spawn_with_shell("dbus-send --session --dest=org.naquadah.awesome.awful /com/awesome/widget com.awesome.widget.unreadEmails string:$(python ~/.config/awesome/email/getUnreadEmailsNum.py)" )
		end)
emailWidget_times:start()

dbus.request_name("session", "com.awesome.widget")
dbus.add_match("session", "interface='com.awesome.widget', member='unreadEmails' " )
dbus.connect_signal("com.awesome.widget", function (...)
	local data = {...}
	local dbustext = data[2]
	emailWidget_counter:set_text(dbustext)
	end )
{% endhighlight lua %}

>Note that getting number of unread emails could take some time, so instead of `pread` or `spawn_with_shell` functions I use DBus, you can read more about it in [this]({{site.url}}/2015/09/fix-awesome-freezes) post.
{: .note}
