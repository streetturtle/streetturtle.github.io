---
layout: post
title: "E-mail widget for Awesom WM"
date: 2015-10-25 16:25:06
comments: true
tags: 
 - awesome
 - linux
description: Simple email widget for Awesome.  
comments: true
---

Widget consists of icon with number:

and a popup message which appears when you hover over icon:

Create a folder `./.config/awesome/EmailWisget` or clone it from [here](https://github.com/streetturtle/AwesomeWM/tree/master/EmailWidget) 

## Python scripts 

This widget uses of two python scripts: first gets number of unread emails and second gets subject and sender of this email. For both of them you'll need to provide your credentials and imap server.

### Number of unread emails

This script prints out a digit which represents number of unread emails:

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

Now let's combine everything together. 

