---
layout: post
title:  "Connect to alfresco database"
date:   2015-02-13 16:23:45
comments: true
categories:
description: For better understanding of Alfresco sometimes it's needed to see Alfresco tables. Here I'm showing how to connect to Alfresco Postgre database on a server and to h2 database during development.
tags: 
- alfresco
- database
---

## Connection to PostgreSQL (IDE)

You can easily connect to Alfresco database using database IDE, [pgAdmin](http://www.pgadmin.org/) for example. But I prefer to use Intellij's [0xdbe](https://www.jetbrains.com/dbe/).
All necessary information you can find in alfresco-global.properties file (host, port, login and password).

![Screenshot]({{ site.url }}/images/0xdbeSettings.png){:.center-image}

## Connection to PostgreSQL (SSH)

First you need to stop Alfresco and start PostgreSQL server:

{% highlight bash %}
/opt/alfresco-5.0.b/alfresco.sh stop
/opt/alfresco-5.0.b/postgresql/scripts/ctl.sh start
{% endhighlight bash %}

After you can start interactive terminal by running:

{% highlight bash %}
psql -U alfresco
Password for user alfresco: 
psql (8.4.20, server 9.3.5)
WARNING: psql version 8.4, server version 9.3.
         Some psql features might not work.
Type "help" for help.

alfresco=> 
{% endhighlight bash %}

Password could be found in `alfresco-global.properties` file.

Now you are able to select from alfresco tables:

{% highlight bash %}
alfresco=> select * from alf_audit_app;
 id | version | app_name_id | audit_model_id | disabled_paths_id 
----+---------+-------------+----------------+-------------------
  1 |       0 |           5 |              2 |                 2
(1 row)

{% endhighlight bash %}

## Connection to H2 (for IntelliJ IDEA)

For IDEA it's quite easy to connect to H2 database. Search for `alf-dev.h2` file and just drag-and-drop to database tab:

![Screenshot]({{ site.url }}/images/alfDbConScrnsht.png){:.center-image}

And you can open the console (Ctrl+Shift+F10 or right click on the database and select Console)
