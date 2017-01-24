---
layout: post
title:  "Installing LTTng on CentOS"
date:   2017-01-22 10:47:45
comments: true
description: Never used Cent OS before it took me some time to build LTTng manually. Here is a summary of my suffering...
tags: 
- lttng
share: true
---

According to the LTTng [documentation](https://lttng.org/docs/v2.9/#doc-building-from-source) before building and installing LTTng following dependencies should be installed first:

 - libuuid
 - popt
 - Userspace RCU
 - libxml2

I've checked if those packages are installed:

```bash
$ ldconfig -p | grep 'libuuid\|popt\|libxml2'
    libxml2.so.2 (libc6,x86-64) => /lib64/libxml2.so.2
    libuuid.so.1 (libc6,x86-64) => /lib64/libuuid.so.1
    libpopt.so.0 (libc6,x86-64) => /lib64/libpopt.so.0
```
which seems to be so according to the output, but building LTTng failed saying that some of packages below are missing. After some time of struggling it turned out that `*-devel` packages should also be installed (I guess it depends on distribution or version of CentOS).

So here is a quick summary:

```bash
$ yum install libuuid-devel &&
$ yum install popt-devel &&
$ yum install libxml2-devel
```

Userspace RCU should be built :(

```bash
$ cd $(mktemp -d) &&
wget http://www.lttng.org/files/urcu/userspace-rcu-latest-0.9.tar.bz2 &&
tar -xf userspace-rcu-latest-0.9.tar.bz2 &&
cd userspace-* &&
./configure &&
make &&
make install &&
ldconfig
```

And then simply follow the documentation and install LTTng-modules, -UST and -tools.