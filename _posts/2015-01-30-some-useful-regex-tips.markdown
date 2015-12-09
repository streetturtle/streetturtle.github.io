---
layout: post
title:  "Some useful regex tips"
date:   2015-01-30 21:00:52
comments: true
description: Recently I've started discovering some new features of regular expressions which I didn't know before. Here I want to share some of these discoveries. Also I would like to write some useful patterns which are needed sometimes, but to write them from scratch could take some time.
categories: 
tags: 
- regex
---

## Comments

Usually regular expressions are very long and could be almost unreadable. Even if you wrote it by yourself sometime ago. In such cases comments are very useful. To use it you need to turn on [free-spacing mode](http://www.regular-expressions.info/freespacing.html) by adding `x` modifier to your expression. Comment starts with a hashtag `#`. Let's parse date in this format: YYYY/MM/DD (year should be between 1000 and 2012 and assume all months have 30 days). 

{% highlight bash %}
(1\d{3}|20(0\d|1[0-2]))\/(0[1-9]|1[0-2])\/(0[1-9]|[012]\d|30)
{% endhighlight bash %}
		
And the same regex with comments:

{% highlight bash %}
(1\d{3}          # 1000-1999
|                # or
20(0\d|1[0-2]))  # 20 (01-09 or 10-12)
\/               # slash, months after
(0[1-9]          # 01-09
|                # or     
1[0-2])          # 10-12 
\/               # slash, days after
(0[1-9]          # 01-09
|                # or
[12]\d           # 10-29
|                # or 
30)              # 30
{% endhighlight bash %}

## Lookahead assertions

Sometimes it's needed to match something which is followed by something else. But not include this following something else in the match. For such cases **lookahead** assertion is what you need. There are two types of lookahead assertion:

 * positive `(?=regex)` - matches only if it is followed by regex
 * negative `(?!regex)` - matches if it is followed NOT by regex

Let's have a look on a simple example. 

Let's say you have a list of files:

{% highlight bash %}
file.sass
file.xml
index.html
model.xml
model.properties
contentModel.xml
{% endhighlight bash %}

and you want to find all names of xml files but do not include the _.xml_ part. Of course you can use simple pattern `^[a-z]+\.xml$` but then the _.xml_ part will be included in the match. To have only filename use this pattern: `^[a-z]+(?=.xml$)`.

Some explanation:

{% highlight bash %}
^       #beginning of the line
[a-z]+  #file name - one or more letters
(?=     #assertion declaration
.xml$)  #part which should be after the filename
{% endhighlight bash %}

You can play with it here: [https://regex101.com/r/tK4lU3/1](https://regex101.com/r/tK4lU3/1)

Result would be following:

{% highlight bash %}
file
model
contentModel
{% endhighlight bash %}

## Lookbehind assertions

Lookbehind assertion works the same way but looks before the current match. And there are two types of it as well: positive `(?<=regex)` and negative `(?<!regex)`.

Almost the same example, but now let's find all the file extensions we have for filename _model_. 
Pattern for it would be: `(?<=^model\.)[a-z]+$` and the result:

{% highlight bash %}
xml
properties
{% endhighlight bash %}

## If-then-else conditions

To check some conditions regular expressions provide this functionality. The syntax is  `(?(?=regex)then|else)` or if you don't have _else_ just `(?(?=regex)then)`.