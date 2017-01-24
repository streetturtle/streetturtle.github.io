---
layout: post
title:  "Enable document view event for RM audit"
date:   2015-02-19 16:23:45
comments: true
categories:
description: I was quite surprised when discovered that out-the-box alfresco RM doesn't audit document view action. After suffering for a while I've finally managed to turn it on!
tags: 
- alfresco
---

Records Management has a really useful feature which is audit. Out of the box it supports many actions and also provides very good ui to view the audit. But the most interesting action - read content is not supported. So let's turn it on.

##Behaviour

In alfresco actions are audited by behaviour. To a have a closer look on it you can clone Records Management project from RM [git repository](https://github.com/Alfresco/records-management.git) and then have a look on some default events. They are located in `org.alfresco.module.org_alfresco_module_rm.audit.event` package. [Here](http://ecmarchitect.com/alfresco-developer-series-tutorials/behaviors/tutorial/tutorial.html) you can find very good tutorial about Alfresco behaviour from Jeff Potts.

In few words behaviour should implement some policy which is in our case would be `ContentServicePolicies.OnContentReadPolicy` and also extend `Audit event`. The behaviour itself would register read event of noderef and pass it to RM audit service. Here is the implementation of this behaviour:

{% highlight java %}
@BehaviourBean
public class ReadAuditEvent extends AuditEvent implements ContentServicePolicies.OnContentReadPolicy {
  @Override
  @Behaviour
    (
      kind = BehaviourKind.CLASS,
      type = "rma:filePlanComponent"
    )
  public void onContentRead(NodeRef nodeRef) {
    recordsManagementAuditService.auditEvent(nodeRef, getName());
  }
}
{% endhighlight java %}

## Register bean

Next step is register this behaviour in `your-app-context.xml`:

{% highlight xml %}
<bean id="audit-event.content-read" parent="audit-event" class="cern.efiles.behavior.ReadAuditEvent">
  <property name="name" value="Read RM Object"/>
  <property name="label" value="rm.audit.content-read"/>
</bean>
{% endhighlight xml %}

## Event name localisation

Localise the event name, which will be shown in the report. Let's say you need to support English and French languages. You'll need to extend localisation properties file. To do this create folder under `extension/module/org_alfresco_module_rm/messages` with following files:locallo

`audit-service.properties`:

{% highlight properties %}
rm.audit.content-read=Read RM Content
{% endhighlight properties %}

`audit-service_fr.properties`:

{% highlight properties %}
rm.audit.content-read=Lecture contenu RM
{% endhighlight properties %}

Now let's test it. Create some record and view it. Then open Audit log for this document and you'll see the registered event:

![Screenshot]({{ site.url }}/images/enableViewAudit.png)