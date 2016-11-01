---
layout: page
title: Tags
---

<div class="page-content wc-container text-center">
{% capture site_tags %}
  {% for tag in site.tags %}
    {{ site_tag | append: '{"text":"' | append: tag[0] | append: '","size":' | append: tag[1].size }}
    {{ site_tag | append: ', "url":"' | append: site.url | append: '/tag/' | append: tag[0] | append: '"' }}
    {{ site_tag }}}
  {% unless forloop.last %},{% endunless %}
  {% endfor %}
{% endcapture %}
{% include tag-cloud.html %}
</div>