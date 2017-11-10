---
layout: post
title:  "Run Camel route for a given amount of time"
date:   2017-11-09 10:47:45
comments: false
description:
tags:
- apache camel
---

For example I have a SSH route defined below which runs a command on a remote server every second and logs the result:

{% highlight java %}
camelCtx.addRoutes(new RouteBuilder() {
    @Override
    public void configure() {
        from("ssh://root:pswrd@192.168.12.13:22?delay=1000&pollCommand=free%0A")
            .routeId("some-route")
            .convertBodyTo(String.class, "UTF-8")
            .log(LoggingLevel.INFO, "${body}");
    }
});
{% endhighlight %}

But I want to run this route for 4 hours and then stop it.

This could be achieved by adding to the same context another route with timer, which will run once after given amount of time, and in `process` method of this route we will get the first route by it's id and then stop it:

{% highlight java %}
camelCtx.addRoutes(new RouteBuilder() {
    @Override
    public void configure() throws Exception {
        long duration = TimeUnit.HOURS.toMillis(4);
        from("timer://runOnce?repeatCount=1&delay=" + duration)
            .process(exchange -> exchange.getContext().stopRoute("some-route"));
    }
});
{% endhighlight %}
