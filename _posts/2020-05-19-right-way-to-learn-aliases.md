---
layout: post
title: The right way to learn aliases
date: 2020-06-04 16:48:45
description: Just want to share how I managed to learn quite a lot of new and <b>useful</b> aliases. 
tags: 
---

I was trying to master aliases for a long time, but with not much success. Articles like _5/10/30 most useful/handy/ aliases for linux_ didn't help much, as even if there was something useful for me, I ended up with adding that alias to my **.zshrc**, but never used it after. I think that the main reason was that I didn't know which command I need to replace with alias. It's like with Amazon - instead of buying something from the suggestions (which most of the time will end up collecting dust on the shelf), you should analyze your needs first and then buy a thing which will fulfill this need.

Probably the best candidates would be the commands you use more often, and then just check which ones of them could be "aliased". After this idea popped in my mind I wrote the below one-liner which prints out top 10 (or more) most frequently used commands from your [history](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html):

```bash
$ history \
| sed 's/^\s*[[:digit:]]\+\*\?\s*//g' \
| sort \
| uniq -c \
| sed 's/^\s*//g' \
| sort  -k1 -n -r \
| head
```

which in my case outputs the following: 

```bash
996 ll
362 git status
275 git push
228 git pull
203 cd 
131 git add -A
87 git checkout master
85 cd ..
84 top | grep awesome
83 ssh-add
```

Now let's check what can be replaced by aliases, (oh-my-zsh [plugins](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins) could be the good source of aliases).

 - `ll` is already an alias of `ls -lh`, not bad
 - `git status/push/pull/checkout master` - can be replaced by `gst/gp/gl/gcm` (oh-my-zsh [git plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) has quite a lot of aliases for git)
 - `cd ..` - again, oh-my-zsh already has an alias for this command - `..`

So now I just need to remember these 6 aliases (which would be easy, as I use those commands quite often)

With a small addition to the command - grepping the output of `history` by the executable - you can print only commands related to one executatble, for example for `git` it would be:

```bash
$ history \
| grep git \
| sed 's/^\s*[[:digit:]]\+\*\?\s*//g' \
| sort \
| uniq -c \
| sed 's/^\s*//g' \
| sort  -k1 -n -r \
| head
```

which in my case shows the following:

```bash
362 git status
275 git push
228 git pull
131 git add -A
87 git checkout master
53 git rebase --continue
49 git checkout -
41 git stash pop
40 git stash
39 git merge master
```

And then for each command you can either create your own alias, search online, or, if you have oh-my-zsh installed, just search for existing ones, like:

```bash
$ alias | grep 'git status'   
gsb='git status -sb'
gss='git status -s'
gst='git status'
```
