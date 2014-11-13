---
layout: post
title:  "Post with an images"
date:   2014-08-30 23:56:45
categories:
description: A sample post to show how images are being rendered on harmony.
---

Usually when you develop some new features for Alfresco you need to completely clean the project. Which is not so good since you will loose all manually created things such us users or sites. In case of users you can integrate Alfresco with () But for sites it could be quite complicated to manually recreate them, especially when you have more than 5 sites. In this post I'd like to show how to create sites automatically when Alfresco starts. So that you could be sure that your sites are in place.

I found few tutorials on how to do this, but some of them were too complicated, some just didn't work. First thing which probably could do the work is `siteService`. But the problem with it that it only creates site on Alfresco side. So you won't be able to use it. Another approach which worked for me is to use `create-site` share webscript. It is a POST webscript, so I need to pass all the site parameters to it. Since I know the site names and types already I can just call this webscript from another one, in which I have all the site parameters hardcoded. 

Let's register the webscript in Spring:

Create a webscript description file:

And finally write the webscript:

To test is you can simply go to http://localhost:8081/share/...






A sample post to show how images are being rendered on harmony.

### Image from external host

![Image](http://placekitten.com/g/900/300)