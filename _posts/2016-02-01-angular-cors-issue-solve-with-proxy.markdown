---
layout: post
title: "Solving Angular JS CORS issue"
date: 2016-02-01 12:09:06
comments: true
tags: 
 - angular js
description: Making HTTP requests from Angular was painful for me at the beginning. Due to CORS issue I wasn't able to make calls to external services. Trying different solutions I came up with one which I think quite easy to implement.
comments: true
---

# The problem

Every time I call some services which are on different machine from one which served the application using `$http` or `$resource` services I end up with following error:

{% highlight bash %}
No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 'http://something:1234' is therefore not allowed access.
{% endhighlight bash %}

This is [CORS](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing). Shortly you just not allowed to call some other service from client side JS due to security reason.

# Solutions

The most common solution is to use [JSONP](https://en.wikipedia.org/wiki/JSONP) approach.
Another solution is to enable CORS on external service. If you lucky enough to be able to change it and if it's a Spring Boot application you can use this approach: [Enabling Cross Origin Requests for a RESTful Web Service](https://spring.io/guides/gs/rest-service-cors/) which basically add an `@CrossOrigin` annotation to the method which enables cross-origin requests for annotated method.

I haven't tried first solution. Second worked quite good but unfortunately we used quite many services and it became unmanagable.

# The solution

Since it's possible to call only the server which served the application I decided to create a proxy controller which basically redirects all the requests to the proper service, and then simply returns the response back.
So instead of calling `someservice.com/getUsers` I call local controller at `localhost:8080/proxy/someservice/getUsers` which then calls `someservice.com/getUsers` and simply returns the response. Here is simple implementation of proxy controller for two POST methods:

{% highlight java %}
@RestController
public class ProxyController{
  @RequestMapping(value = "/proxy/dar/person/acl", method = RequestMethod.POST)
  public String getAce(RequestEntity<String> requestEntity) throws URISyntaxException {
    return getResponseBody("http://external-service.com" + "/access-rights/person/acl", requestEntity, HttpMethod.POST);
  }

  @RequestMapping(value = "/proxy/dar/read/acl/document/all", method = RequestMethod.POST)
  public String getAcl(RequestEntity<String> requestEntity) throws URISyntaxException {
    return getResponseBody("http://external-service.com" + "/access-rights/document/acl/all", requestEntity, HttpMethod.POST);
  }
}
{% endhighlight java %}

In case of calling many services all urls could be put in a map and then it would be just one method:

{% highlight java linenos %}
HashMap<String, String> redirects = new HashMap<String, String>(){
  {
    put("person/acl", "/access-rights/person/acl");
    put("read/acl/document/all", "/access-rights/document/acl/all");
    put("read/acl/document", "/access-rights/document/acl");
    put("read/access", "/access-rights/permission");
  }
};

@RequestMapping(value = "/proxy/dar/**", method = RequestMethod.POST)
public String genericProxyPost(RequestEntity<String> requestEntity, HttpServletRequest request) throws
  URISyntaxException
{
  String pattern = (String) request.getAttribute(HandlerMapping.BEST_MATCHING_PATTERN_ATTRIBUTE);
  String path = new AntPathMatcher().extractPathWithinPattern(pattern, request.getServletPath());

  return getResponseBody("http://external-service.com" + redirects.get(path), requestEntity, HttpMethod.POST);
}
{% endhighlight java %}

For the code above all requests which starts with `/proxy/dar/` will endup in this method (line **10**).
The key in the map is local path, the value is path of the external service. 
Then in `path` variable would be written the remaining part of the URL, which is key in the map (line **15**).
By this key we take the part of URL from the map of external service and redirect HTTP call there (line **17**).


Basically the code above tells redirect calls from `http://localhost:8080/proxy/dar/person/acl` to `http://external-service.com/access-rights/person/acl` and so on according to the map. 
