---
layout: post
title: "Install Jekyll 3"
date: 2015-12-21 11:09:06
comments: true
tags: 
  - jekyll
description: Recently Jekyll 3.0 was released (26.10.15) and then 3.0.1 (17.11.15), it took me some time to upgrade my version of it. Here is how I did it.
comments: true
---

>I'm not a Ruby expert and I don't have much experience with it, so following steps could be not the best ones, but it worked for me.
{: .note}

First you need to remove jekyll (even all rubygems would be better) and ruby. Les't start from scratch.

## Ruby

Jekyll 3 doesn't work anymore with version 1.9.3 of Ruby, AFAIK apt-get provide only 1.9.3, so we need to install it using another approach. [Here](https://www.ruby-lang.org/en/documentation/installation/) is the list of ways to do it. After several attempts with RVM I've chosen `ruby-install` which was easier for me:

{% highlight bash %}
wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz
cd ruby-install-0.5.0/
sudo make install
ruby-install ruby 2.2.4
{% endhighlight bash %}

Then export ruby home in HOME variable:
  
{% highlight bash %}
export PATH="$HOME/.rubies/ruby-2.2.4/bin:$PATH"
{% endhighlight bash %}

Now check the version, should be 2.2.4:

{% highlight bash %}
ruby -v
ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-linux]
{% endhighlight bash %}

## Ruby Gems

This step is as usual, go here: [https://rubygems.org/pages/download](https://rubygems.org/pages/download) and follow the instructions (unpack archive, go there and run `ruby setup.rb`).

## Jekyll

Now we need to install jekyll gem and github-pages gems:

{% highlight bash %}
gem install jekyll
gem install github-pages
{% endhighlight bash %}

Now you are ready to blog)

In case you use pagination and have following exception while building your site:

>Deprecation: You appear to have pagination turned on, but you haven't included the 'jekyll-paginate' gem. Ensure you have 'gems: [jekyll-paginate]' in your configuration file.

Add following line to your **config.xml**:

{% highlight bash %}
gems: [jekyll-paginate]
{% endhighlight bash %}



