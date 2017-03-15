---
layout: post
title:  "Useful Kafka commands"
date:   2017-03-15 10:47:45
comments: true
description: Few useful Kafka commands 
tags: 
- kafka
share: true
---

# Consumers

## Difference between old and new consumers. 
The new consumer was introduced in version 0.9.0.0, the main change introduced is for previous versions consumer groups were managed by Zookeeper, but for 9+ versions they are managed by Kafka broker. If you use `kafka-console-consumer.sh` for example - it uses an old consumer API. But if you created a new consumer or stream using Java API it will be a new one.  Knowing this defference will help you understand which command to use from examples below.

>List consumer groups
{:.filename}
```bash
$ ./kafka-consumer-groups.sh  -zookeeper localhost:2181 -list        # Old consumers
$ ./kafka-consumer-groups.sh  -bootstrap-server localhost:9092 -list # New consumers
```

>List only old consumer groups
{:.filename}
```bash
$ ./zookeeper-shell.sh localhost:2181
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is disabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
ls /consumers
[console-consumer-59900, console-consumer-857]
```

>Describe consumer group
{:.filename}
```bash
$ ./kafka-consumer-groups.sh -bootstrap-server localhost:9092 -describe -group my-stream-processing-application
GROUP   TOPIC    PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             OWNER
my-appl  lttng                  0                  34996877                  34996877            0                 owner
[root@lttng02 bin]# ./kafka-consumer-groups.sh -zookeeper localhost:2181 -describe -group console-consumer-59900
GROUP                          TOPIC                          PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             OWNER
console-consumer-59900         test_topic                     0          169542          199264          29722           none
```

# Topics

Below are the actions which could be performed on topics. Also topic configuration can be altered by `--alter` parameter. 

>Create topic
{:.filename}
```bash
$ ./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor <> --partitions <> --topic <name>
```

>Delete topic
{:.filename}
```bash
$ ./kafka-topics.sh --zookeeper localhost:2181 --delete  --topic <name>
```

>List topics
{:.filename}
```bash
$ ./kafka-topics.sh --list --zookeeper localhost:2181
topic1
topic2
```

>Using zookeeper shell
{:.filename}
```bash
$ ./zookeeper-shell.sh localhost:2181 <<< "ls /brokers/topics"
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is disabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[topic1,topic2]
```


>Describe topic
{:.filename}
```bash
$ ./kafka-topics.sh --describe --zookeeper localhost:2181
Topic:topic1	PartitionCount:1	ReplicationFactor:1	Configs:
	Topic: topic1	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
Topic:topic2 PartitionCount:1	ReplicationFactor:1	Configs:
	Topic: topic2	Partition: 0	Leader: 0	Replicas: 0	Isr: 0

$ ./kafka-topics.sh --describe --topic topic1 --zookeeper localhost:2181
Topic:lttng	PartitionCount:1	ReplicationFactor:1	Configs:
	Topic: lttng	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
```