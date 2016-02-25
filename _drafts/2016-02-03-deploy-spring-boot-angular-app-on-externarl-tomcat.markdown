---
layout: post
title: "Deploy Spring Boot + Angular JS app on external tomcat with custom content root"
date: 2016-02-03 12:09:06
comments: true
tags: 
 - awesome wm
description: 
comments: true
---

I was working on a Spring Boot application which is using Angular JS on the client and Spring Data Rest on the server. Everything was ok until the moment I start to deploy it to the server. For some IT related reason this application should be deployed on an external (not embedded) tomcat server under the context root. 

# $http interceprtor

