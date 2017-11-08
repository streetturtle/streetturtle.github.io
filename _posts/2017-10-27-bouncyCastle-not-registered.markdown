---
layout: post
title:  "Apache Camel - BouncyCastle not registered error"
date:   2017-10-27 10:47:45
comments: true
description: Solving the "BouncyCastle not registered, using the default JCE provider" problem which appeared using the Apache Camel's SSH component.
tags:
- apache camel
---

While using Apache Camel's [SSH component](http://camel.apache.org/ssh.html) I've faced a strange issue. I was developing an application which could run in background and collect output of linux commands. From IDEA it was running ok, but when I created a fat .jar using maven-assembly-plugin and started it I got following exception:

{% highlight java %}
[...    main] SecurityUtils      INFO  BouncyCastle not registered, using the default JCE provider
[...thread-1] ClientSessionImpl  INFO  Client session created
[...thread-1] ClientSessionImpl  INFO  Server version string: SSH-2.0-OpenSSH_4.3
[...thread-2] ClientSessionImpl  WARN  Exception caught
java.security.InvalidAlgorithmParameterException: DH key size must be multiple of 64, and can only range from 512 to 2048 (inclusive).
The specific key size 4096 is not supported
  at com.sun.crypto.provider.DHKeyPairGenerator.initialize(DHKeyPairGenerator.java:128)
  at java.security.KeyPairGenerator$Delegate.initialize(Unknown Source)
  at java.security.KeyPairGenerator.initialize(Unknown Source)
  at org.apache.sshd.common.kex.DH.getE(DH.java:65)
  at org.apache.sshd.client.kex.DHGEX.next(DHGEX.java:118)
  at org.apache.sshd.common.session.AbstractSession.doHandleMessage(AbstractSession.java:425)
  at org.apache.sshd.common.session.AbstractSession.handleMessage(AbstractSession.java:326)
  at org.apache.sshd.client.session.ClientSessionImpl.handleMessage(ClientSessionImpl.java:306)
  at org.apache.sshd.common.session.AbstractSession.decode(AbstractSession.java:780)
  at org.apache.sshd.common.session.AbstractSession.messageReceived(AbstractSession.java:308)
  at org.apache.sshd.common.AbstractSessionIoHandler.messageReceived(AbstractSessionIoHandler.java:54)
  at org.apache.sshd.common.io.nio2.Nio2Session$1.onCompleted(Nio2Session.java:184)
  at org.apache.sshd.common.io.nio2.Nio2Session$1.onCompleted(Nio2Session.java:170)
  at org.apache.sshd.common.io.nio2.Nio2CompletionHandler$1.run(Nio2CompletionHandler.java:32)
  at java.security.AccessController.doPrivileged(Native Method)
  at org.apache.sshd.common.io.nio2.Nio2CompletionHandler.completed(Nio2CompletionHandler.java:30)
  at sun.nio.ch.Invoker.invokeUnchecked(Unknown Source)
  at sun.nio.ch.Invoker$2.run(Unknown Source)
  at sun.nio.ch.AsynchronousChannelGroupImpl$1.run(Unknown Source)
  at java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
  at java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
  at java.lang.Thread.run(Unknown Source)
[                      Thread-3] Application           INFO  Application has been stopped
{% endhighlight %}

After some investigation and googling I found out that bouncyCastle jar is signed and cannot be put inside the fat jar.

>To make it work the bouncyCastle jar should be in classpath, but not in the fat jar.
{:.note}

## Solution 1 - add JCE provider to the classpath

The idea is following:

 - copy the signed jar into some folder
 - exclude this jar from the fat jar
 - add this jar to the manifest file as classpath.

This can be easily achieved with [Maven Dependency Plugin](https://maven.apache.org/components/plugins/maven-dependency-plugin/) and [Maven Shade Plugin](https://maven.apache.org/plugins/maven-shade-plugin/).

Below is an example of the plugin section of the **pom.xml**:

{% highlight xml %}
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <version>3.0.1</version>
    <executions>
        <execution>
            <id>copy-installed</id>
            <phase>package</phase>
            <goals>
                <goal>copy</goal>
            </goals>
            <configuration>
                <artifactItems>
                    <artifactItem>
                        <groupId>org.bouncycastle</groupId>
                        <artifactId>bcprov-jdk15on</artifactId>
                        <version>${bouncycastle-version}</version>
                        <type>jar</type>
                    </artifactItem>
                </artifactItems>
                <outputDirectory>${project.build.directory}/jce-jars</outputDirectory>
            </configuration>
        </execution>
    </executions>
</plugin>
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>2.3</version>
    <configuration>
        <artifactSet>
            <excludes>
                <exclude>org.bouncycastle:*:*:*</exclude>
            </excludes>
        </artifactSet>
        <transformers>
            <transformer
                    implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                <manifestEntries>
                    <Main-Class>com.application.Application</Main-Class>
                    <Class-Path>. ./jce-jars/bcprov-jdk15on-1.58.jar</Class-Path>
                </manifestEntries>
            </transformer>
        </transformers>
        <shadedArtifactAttached>true</shadedArtifactAttached>
        <shadedClassifierName>fat</shadedClassifierName>
    </configuration>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
        </execution>
    </executions>
</plugin>
{% endhighlight %}

To run the app you need to have the fat jar and jce-jars folder with **bcprov-jdk15on-1.58.jar** in it as it's expected by the MANIFEST.MF.

## Solution 2 - register bouncyCastle

This one is much simpler. Download the bcprov jar from official site: [bouncycastle.org/latest_releases](https://www.bouncycastle.org/latest_releases.html) and put it under **$JAVA_HOME/jre/lib/ext/**. And then add it as the last option in **$JAVA_HOME/jre/lib/security/java.security**, in my case it looks like following:

>java.security
{:.filename}
{% highlight property %}
...
security.provider.7=com.sun.security.sasl.Provider
security.provider.8=org.jcp.xml.dsig.internal.dom.XMLDSigRI
security.provider.9=sun.security.smartcardio.SunPCSC
security.provider.10=org.bouncycastle.jce.provider.BouncyCastleProvider
{% endhighlight %}

More info could be found in [Oracle docs](https://docs.oracle.com/cd/E19830-01/819-4712/ablsc/index.html).
