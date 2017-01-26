---
layout: post
title:  "LTTng live streaming example"
date:   2017-01-18 22:47:45
comments: true
description: LTTng has quite good documentation, but sometimes it’s not very clear, especially without deep knowledge of this tool. It took me almost a day to setup live streaming of the traces. 
tags: 
- lttng
---

LTTng has quite good [documentation](http://lttng.org/docs/v2.9/), but sometimes it's not very clear, especially without deep knowledge of this tool. It took me almost a day to setup live streaming of the traces. One of the problems I had  was related to this section of documentation: [lttng.org/docs/v2.9/#doc-lttng-live](http://lttng.org/docs/v2.9/#doc-lttng-live) - due to a bug in documentation this part:

```bash
lttng create --live my-session
```

should be like this:

```bash
lttng create my-session --live
```

There is a PR for this change: [2.7, 2.8, 2.9: put --live after session name](https://github.com/lttng/lttng-docs/pull/19). 

# Local streaming

Local means that traces are streamed to the same machine.

**1**. Target terminal session - create live session which triggers creation of relay daemon and enable kernel's events:

```bash
$ lttng create my-session --live
Spawning a session daemon
Spawning a relayd daemon
Session my-session created.
Traces will be written in net://127.0.0.1
Live timer set to 1000000 usec
$ lttng enable-event --kernel --all
All Kernel events are enabled in channel channel0
```

**2**. Remote terminal session - list available tracing sessions and view it:

```bash
$ babeltrace --input-format=lttng-live net://localhost # list available tracing sessiong
net://localhost/host/laptop-name/my-session (timer = 1000000, 9 stream(s), 0 client(s) connected)
$ babeltrace --input-format=lttng-live net://localhost/host/laptop-name/my-session
[21:00:10.187779571] (+0.000000535) name sched_switch: { cpu_id = 2 }, ...
[21:00:10.187780930] (+0.000001359) name timer_hrtimer_cancel: { cpu_id...
[21:00:10.187782227] (+0.000001297) name timer_hrtimer_cancel: { cpu_id...
```

**3**. Target terminal session - start trace session:

```bash
$ lttng start
Tracing started for session my-session
```

# Remote streaming

Remote means that traces are sent from one machine to another. For test purpose I created a headless Ubuntu Server VM which will "generate" traces, let's name it **guest-machine**.  

> Note that on remote (receiver) machine ports 5342 and 5343 should be opened.
{:.note}

**1**. Target (guest-machine) - if `--set-url` parameter is passed the relay daemon won't start:

```bash
$ lttng create my-session --live --set-url=net://host-machine-ip
Spawning a session daemon
Session my-session created.
Traces will be written in net://host-machine-ip
Live timer set to 1000000 usec
```

**2**. Remote (host-machine) - start the daemon:

```bash
$ lttng-relayd
```

**3**. Target - enable kernel events, note that relay daemon should be started already on remote:

```bash
$ lttng enable-event --kernel --all
All Kernel events are enabled in channel channel0
$ lttng start
Tracing started for session my-session
```

**4**. Remote - view traces:

```bash
$ babeltrace --input-format=lttng-live net://localhost
net://localhost/host/guest-machine-ip/my-session (timer = 1000000, 2 stream(s), 0 client(s) connected)
$ babeltrace --input-format=lttng-live net://localhost/host/guest-machine-ip/my-session
[21:00:10.187779571] (+0.000000535) name sched_switch: { cpu_id = 2 }, ...
[21:00:10.187780930] (+0.000001359) name timer_hrtimer_cancel: { cpu_id...
[21:00:10.187782227] (+0.000001297) name timer_hrtimer_cancel: { cpu_id...
```
