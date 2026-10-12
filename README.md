streetturtle
============
Some test readme

CV PDF
------

The [CV page](https://streetturtle.github.io/cv.html) and its PDF are both generated from `_data/cv.yml`.
The PDF layout lives in `cv/cv.typ` ([Typst](https://typst.app)) with bundled fonts in `cv/fonts/`.
The page's download button links to `/cv.pdf`, which is built locally and committed.

1. Install Typst: `brew install typst`
2. Edit `_data/cv.yml`
3. Build: `rake cv:pdf` — fetches GitHub stars/forks for `sideProjects`, writes `cv.pdf` to the repo root and fails if it is not exactly 2 pages
4. Commit and push `cv.pdf` together with the `_data/cv.yml` changes

Live preview while editing:

```
typst watch --root . --font-path cv/fonts --ignore-system-fonts cv/cv.typ cv.pdf
```

To force a job onto the next page, add `pdf-page-break-before: true` to its entry in `career`.
Paper size, margins, colors and fonts are set at the top of `cv/cv.typ`.
