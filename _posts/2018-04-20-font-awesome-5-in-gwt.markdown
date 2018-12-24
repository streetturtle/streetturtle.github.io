---
layout: post
title: FontAwesome 5 in GWT
date:   2018-04-20 14:25
comments: true
description: In GWT it's easy to include CSS resource, but since FontAwesome is not only CSS - it's also font files (woff, eot, etc.) it took me some time to do it.
tags:
- gwt
---

In GWT it's easy to include CSS resource, but since FontAwesome is not only CSS - it's also font files (woff, eot, etc.) it took me some time to do it.

In my case I used only WOFF font, since it's supported by most of the browsers, but using the below way you can do the same for all other types. First download Font Awesome and put following files in your project:

```
css
|-- fontawesome-all.min.css
`-- webfonts
    |-- fa-brands-400.woff
    |-- fa-regular-400.woff
    `-- fa-solid-900.woff
```

Including CSS as `CssResource` will include only the CSS file, but if you have a look at the bottom of it you'll notice `@font-face` section which refers to font file by relative path. So we will need to serve font files and make them be accessible.

First let's serve the CSS and fonts, create a `ClientBundle` with follwing content:

```java
public interface FontAwesomeBundle extends ClientBundle{
    FontAwesomeBundle INSTANCE =  GWT.create( FontAwesomeBundle.class );

    @Source("css/fontawesome/fontawesome-all.min.css")
    @CssResource.NotStrict
    CssResource fontAwesome();

    @DataResource.DoNotEmbed
    @DataResource.MimeType("application/font-woff")
    @Source("css/fontawesome/webfonts/fa-brands-400.woff")
    DataResource faBrands400woff();

    @DataResource.DoNotEmbed
    @DataResource.MimeType("application/font-woff")
    @Source("css/fontawesome/webfonts/fa-regular-400.woff")
    DataResource faRegular400woff();

    @DataResource.DoNotEmbed
    @DataResource.MimeType("application/font-woff")
    @Source("css/fontawesome/webfonts/fa-solid-900.woff")
    DataResource faSolid900woff();
}
```

Then inject CSS in your app by calling:

```java
FontAwesomeBundle.INSTANCE.fontAwesome().ensureInjected();
```

After above operations content of font-awesome will be injected in the head element of the DOM. But CSS file still has relative paths to the font files, e.g. **http://localhost/gwt/myapp/65A71CB6AC75767538DD48A2FE8BD898.cache.woff**. To change it in font awesome CSS replace all `@font-faces` by following:

```css
@url faBrands400woffUrl faBrands400woff;
@font-face {
    font-family: 'Font Awesome 5 Brands';
    font-style: normal;
    font-weight: normal;
    src: faBrands400woffUrl format("woff"); }

.fab {
    font-family: 'Font Awesome 5 Brands'; }

@url faRegular400woffUrl faRegular400woff;
@font-face {
    font-family: 'Font Awesome 5 Free';
    font-style: normal;
    font-weight: 400;
    src: faRegular400woffUrl format("woff"); }

.far {
    font-family: 'Font Awesome 5 Free';
    font-weight: 400; }

@url faSolid900woffUrl faSolid900woff;
@font-face {
    font-family: 'Font Awesome 5 Free';
    font-style: normal;
    font-weight: 900;
    src: faSolid900woffUrl format("woff"); }

.fa,
.fas {
    font-family: 'Font Awesome 5 Free';
    font-weight: 900; }
```

`@url faBrands400woffUrl faBrands400woff;` construction defines constant `faBrands400woffUrl` which will be replaced by `faBrands400woff.getUrl()`.

