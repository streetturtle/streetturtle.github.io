---
layout: page
title: Tags
---

<div class="page-content wc-container text-center">
{% capture site_tags %}
  [
  {% for tag in site.tags %}
    {"text":"{{ tag[0] }}","size":{{ tag[1].size }}, "url":"{{ site.url }}/tag/{{tag[0]}}"}
  {% unless forloop.last %},{% endunless %}
  {% endfor %}
  ]
{% endcapture %}

{% include tag-cloud.html %}
</div>
