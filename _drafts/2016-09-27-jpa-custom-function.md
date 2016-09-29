---
layout: post
title:  "MySQL fulltext search with JPA"
date:   2016-09-27 22:47:45
comments: true
description:
tags: 
- jpa
---

# Problem Description

In JPQL you can easily call user-defined functions just by providing its' name and parameters, the same way it would be done in SQL: `... and someFunc(user.age, :someParam)`. Regarding the Criteria API it becomes a little bit trickier, but still possible. You need to use following construction:

```java
// create it
Expression<Double> function = criteriaBuilder.function("calculateAge", Double.class,
    root.get("dob"),
    criteriaBuilder.parameter(String.class, "someParam"));
...
// use it
criteriaQuery.where(criteriaBuilder.greaterThan(function, 0.));
...
// set param
entityManager.createQuery(criteriaQuery).setParameter("someParam", "someValue");
```

Since any user-defined function has the same signature it's easy to create it in JPQL or by using Criteria API. But
there are some functions which have different signature, like MySQL's Full Text Search, which is `match(column_name)
against (param)`.

>**So the problem is how to call such functions using JPQL or Criteria API**
{:.note}

# Solution

The idea here is to register custom function, to do so you need to create custom dialect. I would recommend first to
[check](http://stackoverflow.com/questions/27181397/how-to-get-hibernate-dialect-during-runtime) which dialect is used and then extend it. I didn't manage to find the proper return type. `Boolean` and `TrueFalse` types didn't work. With `Double` type it seems to work ok, but you would need to compare the result with 0 after.

```java
public class MySQLDialect extends MySQL5Dialect {

  public MySQLDialect() {
    super();
    registerFunction("match", new SQLFunctionTemplate(StandardBasicTypes.DOUBLE,
        "match(?1) against  (?2 in boolean mode)"));
  }
}
```

And then set it by setting `hibernate.dialect` property.

Now you can easily use it:

**JPQL**:

```java
Query query = entityManager
    .createQuery("select an from Animal an " +
                 "where an.type = :animalTypeNo " +
                 "and match(an.name, :animalName) > 0", Animal.class)
    .setParameter("animalType", "Mammal")
    .setParameter("animalName", "Tiger");
List<Animal> result = query.getResultList();
return result;
```

**Criteria API**:

```java
CriteriaBuilder criteriaBuilder = entityManager.getCriteriaBuilder();
CriteriaQuery<Animal> criteriaQuery = criteriaBuilder.createQuery(Animal.class);
Root<Animal> root = criteriaQuery.from(Animal.class);

List<Predicate> predicates = new ArrayList<>();

Expression<Double> match = criteriaBuilder.function("match", Double.class,
    root.get("name"),
    criteriaBuilder.parameter(String.class, "animalName"));

predicates.add(criteriaBuilder.equal(root.get("animalType"), "Mammal"));
predicates.add(criteriaBuilder.greaterThan(match, 0.));

criteriaQuery.where(predicates.toArray(new Predicate[]{}));

TypedQuery<Animal> query = entityManager.createQuery(criteriaQuery);
List<Animal> result = query.setParameter("animalName", "Tiger").getResultList();

return result;
```