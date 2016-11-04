---
layout: post
title: "Spring Data Rest - change of base path not working"
date: 2016-02-01 12:09:06
comments: true
tags: 
 - spring data rest
description: I tried to change base path of Spring Data Rest in application.properties file, but for some reason it didn't work. The problem was in custom config...
comments: true
share: true
---

To change the base path in Spring Data Rest is relatively easy, you just add `spring.data.rest.baseUri=api` or `spring.data.rest.basePath=/api` if you have Spring Boot 1.2.3+ in **application.properties** and then your base 
path to Spring Data Rest would be at [localhost:8080/api](localhost:8080/api).
But unfortunately for me it didn't work. Thanks to [raised issue](https://github.com/spring-projects/spring-boot/issues/2392) on github I found out that the problem was in my custom config which I used to expose ids of the entities:

{% highlight java %}
@Configuration
public class ExposeIdsConfig extends RepositoryRestMvcConfiguration {
  @Override
  public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config) {
    config.exposeIdsFor(Role.class);
    config.exposeIdsFor(OrgUnit.class);
  }
}
{% endhighlight java %}

So if you extend the configuration it wipes settings which were set up in .properties file. The solution is to set base path in this config: 

{% highlight java %}
@Configuration
public class ExposeIdsConfig extends RepositoryRestMvcConfiguration {
  @Override
  public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config) {
    config.exposeIdsFor(Role.class);
    config.exposeIdsFor(OrgUnit.class);
    
    config.setBasePath("/api");
  }
}
{% endhighlight java %}

Another solution is to extend `RepositoryRestConfigurerAdapter` instead of `RepositoryRestMvcConfiguration`. In this case you'll be able to use `spring.data.rest.basePath=/api` property.