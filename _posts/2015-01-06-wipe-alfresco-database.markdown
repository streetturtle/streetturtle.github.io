---
layout: post
title:  "Wipe alfresco database"
date:   2015-01-06 16:23:45
comments: true
categories:
description: Here I'm showing how to wipe alfresco database.
tags: 
- alfresco
- database
---
Sometimes for some unknown reason alfresco crashes after I upload some documents. To be able to work with alfresco again each time this happens I need to reinstall alfresco which takes quite a long time. But basically what I want to do is to wipe alfresco database. To do it I've created a following script:

{% highlight bash %}
/opt/alfresco-5.0.a/alfresco.sh stop
echo -e "\e[32mAlfresco stopped\e[0m"
/opt/alfresco-5.0.a/postgresql/scripts/ctl.sh start
echo -e "\e[32mPostgres started\e[0m"
dropdb -h localhost -U postgres alfresco
echo -e "\e[32mDatabase dropped\e[0m"
createdb -h localhost -U postgres -O alfresco alfresco
echo -e "\e[32mDatabase created\e[0m"
/opt/alfresco-5.0.a/postgresql/scripts/ctl.sh stop
echo -e "\e[32mPostgres stopped\e[0m"
cd /opt/alfresco-5.0.a/alf_data
find -maxdepth 1 ! \( -name 'solr' -o -name 'postgresql' -o -name 'keystore' -o -name '.' \) -type d -exec rm -rf {} +
echo -e "\e[32malf_data cleaned\e[0m"
rm -rf /opt/alfresco-5.0.a/alf_data/solr/workspace/SpacesStore
rm -rf /opt/alfresco-5.0.a/alf_data/solr/archive/SpacesStore
rm -rf /opt/alfresco-5.0.a/alf_data/solr/workspace-SpacesStore/alfrescoModels
rm -rf /opt/alfresco-5.0.a/alf_data/solr/archive-SpacesStore/alfrescoModels
echo -e "\e[32mSolr cleaned\e[0m"
{% endhighlight bash %}

Here are some explanations. 
First thing you need to do is to stop alfresco just to be sure that it's not running:

{% highlight bash %}
/opt/alfresco-5.0.a/alfresco.sh stop
{% endhighlight bash %}

Then start postgres and recreate database by dropping it and create. Be sure that the proper user owns the database you create. You can also keep the table and just drop all the tables in it. But first method works better. And then stop postgres.

{% highlight bash %}
/opt/alfresco-5.0.a/postgresql/scripts/ctl.sh start
dropdb -h localhost -U postgres alfresco
createdb -h localhost -U postgres -O alfresco alfresco
/opt/alfresco-5.0.a/postgresql/scripts/ctl.sh stop
{% endhighlight bash %}

And the last step is to clear Solr index. For more information you can refer to this article: [Performing a full reindex with Solr].

{% highlight bash %}
rm -rf /opt/alfresco-5.0.a/alf_data/solr/workspace/SpacesStore
rm -rf /opt/alfresco-5.0.a/alf_data/solr/archive/SpacesStore
rm -rf /opt/alfresco-5.0.a/alf_data/solr/workspace-SpacesStore/alfrescoModels
rm -rf /opt/alfresco-5.0.a/alf_data/solr/archive-SpacesStore/alfrescoModels
{% endhighlight bash %}

That's it!

[Performing a full reindex with Solr]: http://docs.alfresco.com/4.0/tasks/solr-reindex.html
