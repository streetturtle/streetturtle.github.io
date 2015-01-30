---
layout: post
title:  "Some useful regex tips"
date:   2015-01-30 21:00:52
description: Recently I've started discovering some new features of regular expressions which I didn't know before. Here I want to share some of these discoveries. Also I would like to write some useful patterns which are needed sometimes, but to write them from scratch could take some time.
categories: 
tags: 
- regex
---

## Lookahead and lookbehind assertions

### Lookahead

Sometimes it is needed to match something which is followed by something else. But not include this following something else in the match. For such cases **lookahead** assertion is what you need. There are two types of lookahead assertion:

* positive `(?=regex)`
* negative `(?!regex)`

Let's have a look on a simple example. 

Let's say you have a list of files and you want to find all names of xml files but do not include the _.xml_ part. Of course you can use simple pattern `^[a-z]+\.xml$` but then the _.xml_ part will be included in the match. To have only filename use this pattern: `^[a-z]+(?=.xml$)`.

Some explanation:

{highlight bash}
^       #beginning of the line
[a-z]+  #file name - one or more letters
(?=     #assertion declaration
.xml$)  #part which should be after the filename
{endhighlight bash}

You can play with it here: [https://regex101.com/r/tK4lU3/1](https://regex101.com/r/tK4lU3/1)

### Lookbehind

Lookbehind assertion works the same way but looks before the current match. And there are two types of it as well:

* positive `(?<=regex)`
* negative `(?<!regex)`

Almost the same example, but now let's find all the file extensions we have for filename _model_. 
Pattern for it would be: `(?<=^model\.)[a-z]+$`

{highlight bash}
(?<=      #start of positive lookbehind assertions
^model\.) #filename
[a-z]+    #file extension, more that letter
$
{endhighlight bash}