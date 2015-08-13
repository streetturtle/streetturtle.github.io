---
layout: post
title:  "URL monitoring extension for AppDynamics in Ruby"
date:   2015-07-19 16:23:45
comments: true
categories:
description: Simple extension for AppDynamics' machine agent to monitor URL's written in Ruby. 
tags: 
- awesome wm
- ubuntu
---

## Introduction

Since we have started to use AppDynamics for our application I've installed an [extension to monitor urls](http://community.appdynamics.com/t5/eXchange-Community-AppDynamics/Url-Monitoring-Extension/idi-p/7992), to check if they up, check the status code


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
  #print(res.code)
  #print(res.body)
  #return res.code
end

share = 'https://efiles.cern.ch/share/page'                     # sso, 302 is ok
repo = 'https://efiles.cern.ch/alfresco/'                       # no sso, 200 is ok
solr = 'https://efiles-index-server01-prod.cern.ch:8443/solr4/' # no cert, 401 is ok

printMetric('/share', getRespCode(share).code)
printMetric('/repo', getRespCode(repo).code)
printMetric('/solr', getRespCode(solr).code)

# uri = URI.parse(share)

# Due to the old version of Ruby on a server open-uri won't work
# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# io = open(solr)
# io.status #=> ["200", "OK"]
# print(io.status.fetch(0, 0)) # return 0 if 0th element donesn't exist
# print(io.string)
# result = Net::HTTP.start(uri.host, uri.port) { |http| http.get(uri.path) }
{% endhighlight ruby %}