
In GWT it's easy to include CSS resource, but since FontAwesome is not only CSS - it's also font files (woff, eot, etc.) it took me some time to do it. 

In my case I used only WOFF font, since it's mostly supported by browsers, but using the below way you can do the same for all other types. First download Font Awesome and put following files in your project:

```
css
|-- fontawesome-all.min.css
`-- webfonts
    |-- fa-brands-400.woff
    |-- fa-regular-400.woff
    `-- fa-solid-900.woff
```

Including css as CssResource will include only the CSS, but it you have a look at the bottom of it you'll notice `@font-face` section which refers to font file by relative path. So we will need to serve font files and make them be accessible.
