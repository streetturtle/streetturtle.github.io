---
layout: post
title: "Perform an update using Angular's $resource and Spring Data REST"
date:   2015-09-21 09:26:45
comments: true
categories:
description:  
tags: 
- spring data rest
- angular js
---

Using Spring Data REST with Angular's $resource object is very useful and convenient, but I've faced a problem with CRUD update. 
First you need to create such method while creating $resource object:

{% highlight javascript %}
angular.module('myApp.services',[]).factory('Something',function($resource){
  return  $resource('http://giveMeSomeRest.nom/please/:id',{id:'@_id'},{
      update: {
        method: 'PUT'
      }
  });
});
{% endhighlight javascript %}

But when this method was called I got `405 Method Not Allowed` error. The problem is Spring expects to have an id in the URL. To add it modify creation of a $resource object:

{% highlight javascript %}
angular.module('myApp.services',[]).factory('Something',function($resource){
  return  $resource('http://giveMeSomeRest.nom/please/:id',{id:'@_id'},{
      update: {
        method: 'PUT',
        params: {id: "@id"},
      }
  });
});
{% endhighlight javascript %}

Please note that `@id` refers to the parameter defined above, so no underscore is needed.

