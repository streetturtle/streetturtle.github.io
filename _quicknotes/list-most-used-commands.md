---
layout: post
title:  "List most used linux commands"
date:   2018-02-19 10:47:45
comments: true
tags:
 - notes
---

This one-liner lists top 10 most used commands based on your history file:

```bash
history \
| sed 's/^\s*[[:digit:]]\+\*\?\s*//g' \
| sort \
| uniq -c \
| sed 's/^\s*//g' \
| sort  -k1 -n -r \
| head
```
