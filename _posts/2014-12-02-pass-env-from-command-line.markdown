---
layout: post
title:  "Set environment from command line"
date:   2014-12-02 16:48:45
comments: true
categories:
description: This post describes how to change Alfresco environment for DB connection using command line arguments.
tags:
- alfresco
---

In `module-context.xml` add following bean:

{% highlight xml %}
  <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
    <property name="ignoreUnresolvablePlaceholders" value="true" />
    <property name="systemPropertiesModeName" value="SYSTEM_PROPERTIES_MODE_OVERRIDE" />
    <property name="locations">
      <value>classpath:alfresco/module/${artifactId}/${alfresco.env}.properties</value>
    </property>
  </bean>
{% endhighlight xml %}

Datasource:

{% highlight xml %}
  <!--registration of datasource-->
  <bean id="DataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="oracle.jdbc.OracleDriver"/>
    <property name="url" value="jdbc:oracle:thin:@${host}"/>
    <property name="username" value="${username}"/>
    <property name="password" value="${password}"/>
  </bean>
{% endhighlight xml %}

.properties files. In my case I have two files `prod.properties` and `dev.properties`. Basically you just pass the name of the properties file.

{% highlight properties %}
host=someHost
username=someUser
password=somePassword
{% endhighlight properties %}

Now you just need to pass custom VM option parameter when you start alfresco. For instance in Intellij IDEA you can create maven run configuration and specify this parameter there:

![Screenshot]({{ site.url }}/images/EnvVar.jpg){:.center-image}