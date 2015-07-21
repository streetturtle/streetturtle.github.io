---
layout: post
title:  "How to install Ruby without root privileges"
date:   2015-07-16 16:23:45
comments: true
categories:
description: 
tags: 
- ruby
---

## Ruby installation

Create directory for ruby and rubygems sources under your home `/home/username/env`. Download ruby there from [official site](https://www.ruby-lang.org/en/downloads/). Extract it in the same folder and move into it:

{% highlight bash %}
tar -xzvf ruby-2.2.2.tar.gz         
cd ./ruby-2.2.2/
{% endhighlight bash %}

Now run configure script with option which tells where to install it (to avoid permissions issues): `-prefix=$Home/env` then make and install:

{% highlight bash %}
./configure -prefix=$Home/env
make
makeinstall
{% endhighlight bash %}

Almost done, the only thing left is to add `/bin` folder to the PATH. Do it in .profile or in .bash_profile or some other startup script:

{% highlight bash %}
export PATH=$HOME/env/bin/:$PATH
{% endhighlight bash %}

Please note that the bin folder should be before original PATH variable, just in case you have set another version of ruby in it.

To check the installation run `ruby -v`.

## Rubygems installation

Download rubygems into the `env` folder from [here](https://rubygems.org/pages/download) and extract it.

{% highlight bash %}
tar -xzvf rubygems-2.4.8.tgz
{% endhighlight bash %}

Create gems folder under env (`mkdir gems`) and set GEM_HOME variable to point it in this folder:

{% highlight bash %}
export GEM_HOME=/home/username/env/gems/
{% endhighlight bash %}

Now go to extracted ruby folder and run setup script:

{% highlight bash %}
cd ./rubygems-2.4.8/
ruby setup.rb
{% endhighlight bash %}

To check the installation run `gem env`.