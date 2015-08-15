---
layout: post
title:  "URL monitoring extension for AppDynamics in Ruby"
date:   2015-08-19 16:23:45
comments: true
categories:
description: Simple extension for AppDynamics' machine agent to monitor URLs written in Ruby. 
tags: 
- appdynamics
---

## Introduction

Since we have started to use AppDynamics for our application I've installed an [extension to monitor urls](http://community.appdynamics.com/t5/eXchange-Community-AppDynamics/Url-Monitoring-Extension/idi-p/7992), to check if they up, check the return status code and so on.

But since AppDynamics supports not only Java extensions but also scripts I wrote this small script which monitors the provided URLs. This way seems to be easier to support and extend comparing to Java, because you don't need open Java project each time to want to modify something in it or add new metrics. 

This script uses Ruby 1.8. 

{% highlight ruby %}
require 'rubygems'
require 'open-uri'
require 'openssl'
require 'net/http'
require 'net/https'

def printMetric(metric, value)
    printf("name=Custom Metrics|Urls|%s, value=%d\n", metric, value)
end

def getRespCode(url)
  uri = URI.parse(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)

  res = http.request(request)
  #print(res.code) # some other parameters you may use for metrics
  #print(res.body)
  #return res.code
end

someUrl1 = 'https://examplurl.ch/amiup'
someUrl2 = 'https://gesundheit.gta/health/'
someUrl2 = 'https://iddqd.com/godmode/'

printMetric('/example', getRespCode(someUrl1).code)
printMetric('/gta', getRespCode(someUrl2).code)
printMetric('/doom', getRespCode(someUrl3).code)

{% endhighlight ruby %}

## Shell script

Since the logic is in ruby shell script is just a wrapper for it, so it should just run ruby script:

{% highlight bash %}
#!/usr/bin/env bash

ruby ./rest-monitor.rb
exit 0
{% endhighlight bash %}

## Monitor.xml

This file is almost the same for every monitor, it basically tells machine agent how to execute the script. You can find more details in step 7 of [original documentation](https://docs.appdynamics.com/display/PRO40/Build+a+Monitoring+Extension+Using+Scripts). For my monitor it looks like this:

{% highlight xml %}
<monitor>
    <name>RestMonitor</name>
    <type>managed</type>
    <description>Rest call monitoring</description>
    <monitor-configuration></monitor-configuration>
    <monitor-run-task>
        <execution-style>periodic</execution-style>
        <name>Run</name>
        <type>executable</type>
        <task-arguments></task-arguments>
        <executable-task>
            <type>file</type>
            <file os-type="linux">rest-monitor.sh</file>
        </executable-task>
    </monitor-run-task>
</monitor>
{% endhighlight xml %}

Now you just need to put these files under monitors folder and restart machine agent. Metrics will be available under `Custom Metrics|Urls|<urlName>`

