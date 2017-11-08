
How to run route for a given amount of time.

{% highlight java %}
camelCtx.addRoutes(new RouteBuilder() {
    @Override
    public void configure() {
        from(route.getFromString() + "&useFixedDelay=false")
            .routeId("some-route")
            .process(exchange -> {
                Date created = exchange.getProperty(Exchange.CREATED_TIMESTAMP, Date.class);
                String body = exchange.getIn().getBody(String.class);
                exchange.getIn().setBody(created.getTime() + "," +
                    body.replaceAll("\\n", "")
                        .replaceAll(",$", "") + "\n");
            })
            .to(route.getToString());
    }
});

camelCtx.addRoutes(new RouteBuilder() {
    @Override
    public void configure() throws Exception {
        long durationSec = TimeUnit.MINUTES.toMillis(utilinux.config.getDurationMinutes());
        from("timer://runOnce?repeatCount=1&delay=" + durationSec)
            .process(exchange -> exchange.getContext().stopRoute("some-route"));
    }
});
{% endhighlight %}