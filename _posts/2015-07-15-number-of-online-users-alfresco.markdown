---
layout: post
title:  "Get list of currently logged users"
date:   2015-07-15 20:23:45
comments: true
categories:
description: For monitoring of Alfresco we needed to somehow get a number of users currently logged in Alfresco. Here I'm showing how to easily get number of such users as well as list of usernames using simple webscript.
tags: 
- alfresco
---

## Introduction

For monitoring of Alfresco we needed to somehow get a number of users currently logged in Alfresco. Here I'm showing how to easily get number of such users as well as list of usernames using simple webscript. This post is based on an [answer](https://forums.alfresco.com/comment/77448#comment-77448) by [mrgrechkin](https://forums.alfresco.com/users/mrgrechkinn) on Alfresco forum.

## Webscript

Write a description file: 

{% highlight xml %}
<webscript>
  <shortname>Statistics</shortname>
  <description>
    Return json with stats for application
  </description>
  <format default="json"/>
  <family>Stats</family>
  <lifecycle>draft_public_api</lifecycle>
  <url>/mycomp/api/getStatistics</url>
  <authentication>admin</authentication>
</webscript>
{% endhighlight xml %}

Webscript implementation:

{% highlight java %}
public class GetStatistics extends AbstractWebScript
{
  @Autowired
  private TicketComponent ticketComponent;

  @Override
  public void execute(WebScriptRequest req, WebScriptResponse res) throws IOException
  {
    JSONObject users = new JSONObject();
    JSONObject response = new JSONObject();

    users.put("online", getNumberOfUsersConnected());
    response.put("users", users);

    res.getWriter().write(response.toJSONString());
  }

  /**
   * Return approximate number of users, whose ticket didn't expired yet. 
   * By default alfresco ticket expires after one hour of user's inactivity
   *
   * @return number of users who were connected less that one hour ago
   */
  private int getNumberOfUsersConnected()
  {
    Set<String> connectedUsers = ticketComponent.getUsersWithTickets(true);
    return connectedUsers.size();
  }
}
{% endhighlight java %}

And register webscript in `your-app-context.xml`:

{% highlight xml %}
<bean id="webscript.com.mycomp.myapp.getStatistics.get"
        class="cern.com.mycomp.myapp.webscript.GetStatistics"
        parent="webscript"/>
{% endhighlight xml %}

At the end after calling webscript's URL: [/alfresco/s/mycomp/api/getStatistics](/alfresco/s/mycomp/api/getStatistics) you'll get this output:

{% highlight json %}
{
  "users": {
    "online": 4
  },
  "usernames": "[\"dduck\",\"mmouse\",\"pluto\",\"System\"]"
}
{% endhighlight json %}

And in this post: [REST call monitoring extension for AppDynamics]({{ site.url }}/2015/07/rest-monitor/) you will now how to use this webscript as a metric provider for AppDynamics.

Cheers!