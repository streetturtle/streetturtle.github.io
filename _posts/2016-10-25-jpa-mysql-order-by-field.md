---
layout: post
title:  "MySQL order by field in Criteria API"
date:   2016-10-24 22:47:45
comments: true
description: Here I have a simple example showing how to implement MySQL's order by field in Criteria API for MySQL DBMS.
tags: 
- jpa
- database
---

JPA is pretty awesome when you work with DB, but it has several downsides. One of them is missing support for some DB specific functions/features (which could be very useful if you plan to change your DBMS one day). About one of them I wrote in my previous post: [MySQL fulltext search with JPA](http://localhost:4000/2016/09/jpa-custom-function). Another problem I've faced recently is ordering by given list of ids which looks like follows in plain SQL:

```sql
sql select *
from person
where id in (31, 41, 59, 26, 53)
order by field (id, 31, 41, 59, 26, 53)
```
So lets implement this SQL in Criteria API.

`javax.persistence.criteria.Order` is an interface which is responsible for ordering. What we need to do is to add custom expression to it, by this expression it will sort later. You can use anonymous class, but having separate class is better since it can be reused after:

```java
public class OrderByField implements Order{
    private Expression<?> expression;

    @Override
    public Order reverse() { return null; }

    @Override
    public boolean isAscending() { return false; }

    @Override
    public Expression<?> getExpression() { return expression; }

    public OrderByField(CriteriaBuilder cb, List<Expression<?>> list) {
        this.expression = cb.function("FIELD",
                                       Integer.class,
                                       list.toArray(new Expression<?>[list.size()]));
    }
}
```

Instance of this class could be passed to `.order` method of `CriteriaBuilder` class. But first you need to have a list of expressions, which should have column by which order will be performed as first element:

```java
List<Expression<?>> list = new ArrayList<>();
list.add(stRoot.get("id"));
for (Integer i : ids) {
    list.add(cb.parameter(Integer.class, "param" + i));
}
```

And then you need to set those parameters:

```java
for (Integer id : ids) {
    typedQuery.setParameter("param" + id, id);
}
```

> Obviously it would be better to pass params as one object (array or list) but I didn't manage to do it.
{:.note}