---
layout: post
title:  "Juniper  VPN on Ubuntu 16.04 64-bit"
date:   2016-09-17 22:47:45
comments: true
description: I faced an issue running Juniper on Ubuntu 16.04. Some of the solutions I found wasn't working (like install 32-bit openjdk and firefox), others took to much time to set up and were quite fragile (like setup VM with 32-bit Debian, run Juniper applet on it and use this VM as proxy). So here is my solution which I already successfully tried on 3 laptops with 64-bit Ubuntu 16.04.
tags: 
- ubuntu
---

I faced an issue running Juniper on Ubuntu 16.04. Some of the solutions I found wasn't working (like install 32-bit openjdk and firefox), others took to much time to set up and were quite fragile (like setup VM with 32-bit Debian, run Juniper applet on it and use this VM as proxy). So here is my solution which I already successfully tried on 3 laptops with 64-bit Ubuntu
 16.04.

## Install Firefox
Most likely it's already installed - normal one, 64-bit

> Note that due to firefox update versions 52+ don't support NPAPI, if it's your case you need to install ESR version of Firefox: [2017-04-14-juniper-on-ubuntu-16-2]({% post_url 2017-04-14-juniper-on-ubuntu-16-2%})
{:.note}

```bash
sudo apt-get install firefox
```

> Also make sure that you have xterm installed (normally you should have it, but some distibutions doesn't, like Elementary OS). Juniper runs some command there, and if it's not installed VPN connection will fail.

## Install icedtea-plugin
 
```bash
sudo apt-get install icedtea-plugin
```

Verify that it is installed properly by going to `about:addons` in Firefox and checking that it's in the list of installed plugins. From now Firefox will be able to run applets. But Juniper applet will fail to run because it needs 32-bit Java.

## Install Oracle 32-bit JDK
 
Download it from oracle site and extract to **/usr/lib/jvm/** specifying that it's a 32-bit version. After add it to 
alternatives system and verify that it was added, but _do not select it_, just keep it there:

``` shell
sudo mv ./jdk1.8.0_101 /usr/lib/jvm/jdk1.8.0_101-32-bit
sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_101-32-bit/bin/java" 1 
sudo update-alternatives --config java
There are 2 choices for the alternative java (providing /usr/bin/java).


  Selection    Path                                      Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/jdk1.8.0_101/bin/java         1         auto mode
  1            /usr/lib/jvm/jdk1.8.0_101-32-bit/bin/java   1         manual mode
  2            /usr/lib/jvm/jdk1.8.0_101/bin/java         1         manual mode


Press <enter> to keep the current choice[*], or type selection number: 
```
 
Now you have 32-bit Java available, but it won't work, since your pc does not support 32-bit architecture yet. So 
let's add it.

## Add 32-bit support 

The last line will install libraries required for 32-bit applications to work properly in 64-bit systems.

```bash
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libstdc++6:i386 lib32z1 lib32ncurses5 libbz2-1.0:i386 libxext6:i386 libxrender1:i386 libxtst6:i386 libxi6:i386
```

Done! Now Juniper applet should work and be able to do its dirty things :)
