---
layout: post
title:  "Tag cloud for Jekyll using D3.js"
date:   2016-11-06 22:47:45
comments: true
description: Generate a tag cloud for a Jekyll blog with d3.js
tags: 
- jekyll
share: true
---

I really liked the picture example from [github page](https://github.com/jasondavies/d3-cloud) of d3-cloud.js. Let's generate same thing for a Jekyll blog. According to several examples I found online d3-cloud needs to have a JSON with an array of objects, which consists of tag name, proportional size of a tag (in case of blog it is a number of posts with given tag) and also would be useful to have a link to page with posts which have selected tag, such JSON would look like follows:

```js
[
  {"text":"alfresco","size":14, "url":"http://localhost:4000/tag/alfresco"},
  {"text":"database","size":6, "url":"http://localhost:4000/tag/database"},
  ...
]
```

It turned out that to generate such string in Liquid is quite easy. Add file, say **tags.html** to your blog root with following content:

```js
{% raw %}
{% capture site_tags %}
  [
  {% for tag in site.tags %}
    {
      "text":"{{ tag[0] }}",
      "size":{{ tag[1].size }},
      "url":"{{ site.url }}/tag/{{tag[0]}}"
     }
  {% unless forloop.last %},{% endunless %}
  {% endfor %}
  ]
{% endcapture %}
{% include tag-cloud.html %}
{% endraw %}
```

Now let's create html which will take the generated JSON with tags information and generate a tag cloud. Create a file **/_includes/tag-cloud.html**, and add following lines there:

{% highlight html linenos %}
<div class="tags"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.17/d3.min.js"></script>
<script src="../js/d3.layout.cloud.js"></script>

<script>
  var cloud = d3.layout.cloud;
  var fill = d3.scale.category20();
  var tags_map = {%raw%}{{ site_tags | json}}{%endraw%};

  var layout = cloud()
          .size([400, 400])
          .words(tags_map)
          .padding(5)
          .rotate(function() { return (~~(Math.random() * 6) - 3) * 15; })
          .font("Impact")
          .fontSize(function (d) { return d.size * 1.3 + 20; })
          .on("end", draw);

  layout.start();

  function draw(words) {
    d3.select(".tags").append("svg")
            .attr("width", layout.size()[0])
            .attr("height", layout.size()[1])
            .append("g")
            .attr("transform", "translate(" + layout.size()[0] / 2 + "," + layout.size()[1] / 2 + ")")
            .selectAll("text")
            .data(words)
            .enter().append("text")
            .style("font-size", function (d) { return d.size + "px"; })
            .style("font-family", "Ubuntu")
            .style("fill", function(d, i) { return fill(i); })
            .style("color", "#fff")
            .style("cursor", "pointer")
            .attr("text-anchor", "middle")
            .attr("transform", function (d) {
              return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
            })
            .on("click", function (d){window.open(d.url, "_self");})
            .text(function (d) {return d.text;});
  }
</script>
{% endhighlight %}

Note that on **line 8** the generated JSON is passed to d3, which then process it. Also on **line 16** the number of tags in multiplied by some constant (which depends on number of tags you have). And then in `draw` function additional styles and attributes are added to each tag. There is many things to play with to make tag cloud look better, like tag rotation, styles, size and so on.
