---
layout: post
title: IntelliJ IDEA for Jekyll blogging
date:   2017-11-08 14:11
description: Here I'm showing some not very obvious features of IntelliJ IDEA which can significantly improve Jekyll blogging.
comments: true
tags:
- jekyll
- idea
---

IntelliJ IDEA is amazing tool and a must-have for a developer. It has tons of very useful features and could be a good alternative to Brackets, Sublime or Atom for writing a blog using Jekyll. Below is some not very obvious feature which can simplify your blogging routine. The described features should work in community version of IDEA and probably in PyCharm and WebStorm as well.

# Check spelling

I think everybody do some typos from time to time, IDEA can help find them.
It has special type of code inspection which is called **Typo**. It basically checks if you have typos in the text. Another good thing about it is that it can be ran for different scopes (like file, folder, project, etc.) to check all the files in it.

To run it open _Run Inspection by Name_ dialog by pressing `Ctrl`{:.key} + `Alt`{:.key} + `Shift`{:.key} + `I`{:.key} and type _typo_ to search for Typo inspection and then select it. You'll see the following dialog:

![Screenshot]({{site.url}}/images/20171108-idea-jekyll.png){:.center-image}

# Live Templates

To simplify tedious routine of writing some of the Markdown / Liquid templates, like

 - code highlighting:

{% highlight liquid %}
{% raw %}
{% highlight bash %}
<your code snippet>
{% endhighlight %}
{% endraw %}
{% endhighlight %}{:.in-list}

 - showing image (some of Markdown plugins for IDEA have this functionality, but live templates are more flexible):

{% highlight markdown %}
{% raw %}
![image name]({{site.url}}/assets/imagename.png)
{% endraw %}
{% endhighlight %}{:.in-list}

 - or even some custom things, for example in my Jekyll theme I use following structure to create keyboard shortcuts (like `Ctrl`{:.key} + `Shift`{:.key}):

{% highlight markdown %}
{% raw %}
`Ctrl`{:.key} + `Shift`{:.key}
{% endraw %}
{% endhighlight %}{:.in-list}

you can use Live Templates feature. In the following gif you can see how it works:

![Live Template Demo]({{site.url}}/images/20171108-live-template-gif.gif){:.center-image}

To create a custom template, for example for Liquid's **highlight** template, do the following steps:

 - open Live Templates settings by pressing `Ctrl`{:.key} + `Alt`{:.key} + `S`{:.key};
 - then go to **Editor** -> **Live Templates**;
 - create new Template Group called Jekyll;
 - inside created group create new Live Template with following settings:
 
![Live Template creation]({{site.url}}/images/20171108-live-template.png)

Below is some of the templates I am using:

>Highlight template
{:.filename}
{% highlight bash %}
{% raw %}
{% highlight $LANG$ %}
$END$
{% endhighlight %}
{% endraw %}
{% endhighlight %}

>Insert Image template
{:.filename}
{% highlight bash %}
{% raw %}
![$NAME$]({{ site.url }}/images/$FILENAME$)$END$
{% endraw %}
{% endhighlight %}

# File template

Each post file in Jekyll has YAML front matter block with variables which Jekyll will use after. IDEA helps simplify the process of creating such files. Open IDEA settings and go to **Editor** -> **File and Code templates**. Create new File Template and name it _Jekyll post_. Paste following code snippet into the textfield:

{% highlight bash %}
---
layout: post
title: $title
date:   ${YEAR}-${MONTH}-${DAY} ${HOUR}:${MINUTE}
description: $description
comments: true
tags:
- $tag
---
{% endhighlight %}

When such file is created you will see the dialog to define the values of the variables. And the `${...}` variables will be replaced by the system's values.

Also add name and file extension, like in the screenshot below.

![File Template]({{site.url}}/images/20171108-file-template.png){:.center-image}

Now you have a new file type registered:

![File registered]({{site.url}}/images/20171108-new-filetype.png){:.center-image}

# Exclude folders from indexing

IDEA automatically indexes files in the project, which is very useful if you want to search f file by name (`Ctrl`{:.key} + `Shift`{:.key} + `N`{:.key}) or by content (`Ctrl`{:.key} + `Shift`{:.key} + `F`{:.key}). But it becomes annoying when in the search results you see files from bower_components / vendor / gem folder. To exclude such folders from the indexing go to the project settings - `Ctrl`{:.key} + `Alt`{:.key} + `Shift`{:.key} + `S`{:.key} and exclude this directory from module:

![exclude directory from module]({{site.url}}/images/20171108-exclude-from-module.png)

