---
layout: post
title:  "Simple DnD file upload"
date:   2015-08-19 16:23:45
comments: true
categories:
description: Simple implementation of drag-and-drop component based on basic 'input type="file"' tag. 
tags: 
- html
- css
---

## Introduction

For one of the projects I'm working on I discovered that default html tag for uploading files supports drag-and-drop action. But not in IE. I would like to share how to create simple drag-and-drop without any JS libraries which will have slightly different appearance in all version of IE. So let's start.

## 

Create `<input type="file">`