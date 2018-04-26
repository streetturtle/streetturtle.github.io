---
layout: post
title: Add locally installed libs to Python SDK in IDEA
date:   2018-04-15 14:25
comments: true
tags:
- idea
---

When you install Python libraries locally (with `--user` flag):

```bash
pip install --user jira
```

then this library is installed under **~/.local/lib/python3.4/site-packages/** but IDEA doesn't know about such installation. To tell it where to find those libraries go to Project Settings (`Ctrl`{:.key} + `Shift`{:.key} + `s`{:.key}) then select **Project** and under **Project SDK** click **Edit...**:

![rambox dark panel]({{ "/images/2018/pythonSdk1.png" | relative_url }}){:.center-image}

and add path to the local libraries:

![rambox dark panel]({{ "/images/2018/pythonSdk2.png" | relative_url }}){:.center-image}
