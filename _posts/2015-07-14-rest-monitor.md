---
layout: post
title:  "REST call monitoring extension for AppDynamics"
date:   2015-07-14 16:23:45
comments: true
categories:
description: AppDynamics is platform which allows to monitor many aspects of the application - from user interaction to performance of SQL calls to database. It has nice platform for custom extensions which provides all kind of metrics. Here I'd like to show how to create a custom extension which makes a rest call to some webservice (which provides some interesting metrics about application) and sends them to the AppDynamics controller.
tags: 
- appdynamics
- ruby
---

## Introduction

Let's say I have a web application and I want to know how many users are online. My application has a rest API from which I can get this number in json. So I need to somehow get it and pass to machine agent. The response I got is like this:

{% highlight json %}
{
  "users": {
    "online": 20
  }
}
{% endhighlight json %}

## Type of extension

AppDynamics supports three types of extensions:

 - Using a script
 - Using java application
 - Using HTTP listener
 
Basically the idea of first two is when they run machine agent reads the output of them (which is in a special format) and sends it to the controller. Since writing a script is simpler in terms of support and future extension than java application I decided to use a script way. The idea is to create a ruby script which will be called by .sh script. At the end the extension will consist of three files:

 - rest-monitor.sh
 - rest-monitor.rb
 - monitor.xml

## Ruby script

The script's task is to call HTTP service which in my case returns response in json, parse it and write to console formatted metric. Metric format should be as following (example from default extension):

{% highlight bash %}
name=Custom Metrics|Hardware Resources|Disks|Total Disk Usage %, value=23
{% endhighlight %}

And here is the method which formats the metric to such format:

{% highlight ruby %}
def printMetric(metric, value)
    printf("name=Custom Metrics|Users|%s, value=%d\n", metric, value)
end
{% endhighlight ruby %}

Now we need to call a service, in my case it is HTTPS with basic authentication. In ruby it's quite easy to perform such call:

{% highlight ruby %}
url  = "https://myawesomeapp.com/service/api/getStatistics.json"
uri = URI.parse(url)

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth 'admin', '123'

res = http.request(request)
{% endhighlight ruby %}


`res.body` will contain json response, but first we need to parse it, get value by key and print it:

{% highlight ruby %}
resJson = JSON.parse(res.body)
qty = resJson['users']['online']
printMetric('online', qty)
{% endhighlight ruby %}

The whole script is:

{% highlight ruby %}
#!/usr/bin/ruby

require 'rubygems'
require 'net/http'
require 'net/https'
require 'json'

def printMetric(metric, value)
    printf("name=Custom Metrics|Users|%s, value=%d\n", metric, value)
end

url  = "https://myawesomeapp.com/service/api/getStatistics.json"
uri = URI.parse(url)

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(uri.request_uri)
request.basic_auth 'admin', '123'

res = http.request(request)

resJson = JSON.parse(res.body)
qty = resJson['users']['online']
printMetric('online', qty)
{% endhighlight ruby %}

Please note that I was using ruby version 1.8.7, so that's why I needed to include explicitly `net/https` and `rubygems`. If you have newer version (`ruby -v` to check it) you probably won't need this.

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

Now you just need to put these files under monitors folder and restart machine agent. Metrics will be available under `Custom Metrics|Users|online`

