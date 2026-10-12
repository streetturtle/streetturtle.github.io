// Build: typst compile --root . --font-path cv/fonts --ignore-system-fonts cv/cv.typ cv.pdf
// Optional: --input github-stats=path/to/stats.json  ({"owner/repo": {"stars": 1, "forks": 2}})

#let cv = yaml("/_data/cv.yml")
#let person = cv.person

#let paper = "us-letter"
#let margin = (x: 0.5in, y: 0.45in)
#let text-color = rgb("#333333")
#let link-color = rgb("#428bca")
#let rule-color = rgb("#add8e6")
#let header-fill = rgb("#dddddd")
#let heading-font = "Archivo"
#let gutter = 14pt

#let stats = {
  let path = sys.inputs.at("github-stats", default: none)
  if path == none { (:) } else { json("/" + path) }
}

#set document(title: person.name + "'s CV", author: person.name)
#set page(paper: paper, margin: margin)
#set text(font: "Arimo", size: 9pt, fill: text-color)
#set par(leading: 0.45em, spacing: 0.6em)
#set list(indent: 2pt, body-indent: 6pt, spacing: 0.4em)
#show link: set text(fill: link-color)

// Font Awesome 4 glyphs (same icon set as the web page)
#let fa-codes = (
  map-marker: "\u{f041}", flag-o: "\u{f11d}", comments-o: "\u{f0e6}", envelope-o: "\u{f003}",
  laptop: "\u{f109}", phone: "\u{f095}", linkedin: "\u{f0e1}", github: "\u{f09b}",
  stack-overflow: "\u{f16c}", graduation-cap: "\u{f19d}", male: "\u{f183}",
  star: "\u{f005}", code-fork: "\u{f126}",
)
#let fa(name) = text(font: "FontAwesome", fa-codes.at(name))

// Crops a flag out of the web page's sprite sheet using the offsets in flags.css
#let flags-css = read("/css/flags/flags.css")
#let flag(country, size: 9pt) = {
  let m = flags-css.match(regex(
    "\.flag\.flag-" + country + "\s*\{\s*background-position:\s*(-?\d+)(?:px)?\s+(-?\d+)(?:px)?",
  ))
  if m == none { return none }
  let px = size / 16
  box(width: size, height: size, clip: true, baseline: 15%, place(
    top + left,
    dx: int(m.captures.at(0)) * px,
    dy: int(m.captures.at(1)) * px,
    box(width: 208 * px, height: 192 * px, image("/css/flags/flags.png", width: 100%, height: 100%)),
  ))
}

// Converts inline <a href="...">...</a> from cv.yml into PDF links
#let rich(s) = {
  if s == none { return none }
  let out = ()
  let last = 0
  for m in s.matches(regex("<a href=\"([^\"]*)\">([^<]*)</a>")) {
    out.push(s.slice(last, m.start))
    out.push(link(m.captures.at(0), m.captures.at(1)))
    last = m.end
  }
  out.push(s.slice(last))
  out.join()
}

#let current-duration(dates) = {
  let (month, year) = dates.split(" - ").first().split(".").map(int)
  let today = datetime.today()
  let total = (today.year() - year) * 12 + (today.month() - month)
  let (y, m) = (calc.floor(total / 12), calc.rem(total, 12))
  if y > 0 and m > 0 { str(y) + "y " + str(m) + "m" } else if y > 0 { str(y) + "y" } else { str(m) + "m" }
}

#let h4(body) = block(above: 0.7em, below: 0.5em, sticky: true, text(size: 11pt, weight: "bold", body))

#let section(title, ratio: (3fr, 9fr), rule: true, body) = {
  if rule { line(length: 100%, stroke: 0.6pt + rule-color) }
  grid(
    columns: ratio,
    column-gutter: gutter,
    inset: (y: 4pt),
    text(font: heading-font, size: 15pt, title), body,
  )
}

// ---------- Header ----------
#block(
  fill: header-fill,
  outset: (x: margin.x, top: margin.y),
  inset: (top: 0pt, bottom: 10pt),
  width: 100%,
  grid(
    columns: (9fr, 3fr),
    column-gutter: gutter,
    align(horizon, {
      text(font: heading-font, size: 28pt, person.name)
      linebreak()
      text(font: "Roboto Slab", weight: 300, size: 13pt, person.profession)
    }),
    {
      set text(size: 8pt)
      let rows = (
        ("map-marker", person.location),
        if "citizenship" in person { ("flag-o", person.citizenship) },
        ("comments-o", person.spokenLanguages),
        ("envelope-o", link("mailto:" + person.email, person.email)),
        if "site" in person { ("laptop", link(person.site, "pavelmakhov.com")) },
        if "phone" in person { ("phone", person.phone) },
        if "linkedin" in person {
          ("linkedin", link("https://www.linkedin.com/in" + person.linkedin, "linkedin.com/in/streetturtle"))
        },
        ("github", link("https://github.com" + person.github, person.github)),
        ("stack-overflow", link("http://stackoverflow.com/users/1252056" + person.stackoverflow, person.stackoverflow)),
      ).filter(r => r != none)
      grid(
        columns: (10pt, auto),
        column-gutter: 3pt,
        row-gutter: 3.5pt,
        ..rows.map(((icon, value)) => (align(center, fa(icon)), value)).flatten(),
      )
    },
  ),
)

// ---------- Career ----------
#let job(item) = {
  let site = item.at("company-site", default: none)
  let company = if site != none { link(site, item.company) } else { item.company }
  let duration = if "duration" in item { item.duration } else if item.dates.contains("current") {
    current-duration(item.dates)
  }
  let logo = image("/images/cv/" + item.logo, height: 24pt)
  block(breakable: false, sticky: true, below: 6pt, grid(
    columns: (1fr, auto),
    align: horizon,
    grid(
      columns: (auto, auto),
      column-gutter: 6pt,
      align: horizon,
      if site != none { link(site, logo) } else { logo },
      [*#item.position* \ #company],
    ),
    align(right + horizon, [
      #flag(item.country) #item.location \
      #(item.dates + if duration != none { " / " + duration })
    ]),
  ))
  par(rich(item.summary))
  let accomplishments = item.at("accomplishments", default: none)
  if accomplishments != none and accomplishments.len() > 0 {
    block(below: 0.4em, sticky: true, strong[Selected accomplishments:])
    list(..accomplishments.map(a => rich(a.accomplishment)))
  }
}

// Jobs flagged with `pdf-page-break-before: true` in cv.yml start a new page
#let career-chunks = {
  let chunks = ()
  for item in cv.career {
    if chunks.len() == 0 or item.at("pdf-page-break-before", default: false) { chunks.push(()) }
    chunks.at(-1).push(item)
  }
  chunks
}

#for (c, chunk) in career-chunks.enumerate() {
  if c > 0 { pagebreak() }
  section(if c == 0 { "Career" }, ratio: (2fr, 10fr), rule: false, {
    for (i, item) in chunk.enumerate() {
      if i > 0 { line(length: 100%, stroke: 0.6pt + rule-color) }
      block(inset: (y: 2pt), job(item))
    }
  })
}

// ---------- Technical skills ----------
#let skills = cv.technicalSkills.list.map(s => s.tr)
#section("Technical skills", {
  h4[#fa("male") Key competencies:]
  grid(
    columns: (1fr, 1fr),
    column-gutter: gutter,
    list(..skills.slice(0, 4)),
    list(..skills.slice(4, 7)),
  )
})

// ---------- Talks ----------
#section("Talks", {
  for talk in cv.talks {
    h4(talk.title)
    list(..talk.places.map(p => {
      if "link" in p { link(p.link, p.name) } else { p.name }
      if "year" in p [ (#p.year)]
    }))
  }
})

// ---------- Open source projects ----------
#let card(item) = {
  let s = stats.at(item.link, default: none)
  link("https://github.com/" + item.link, block(
    width: 100%,
    stroke: 0.75pt + rgb("#cccccc"),
    radius: 3pt,
    inset: 7pt,
    {
      set text(fill: rgb("#555555"), size: 8.5pt)
      text(size: 10pt, weight: "bold", fill: rgb("#4078c0"), item.name)
      parbreak()
      item.description
      parbreak()
      box(circle(radius: 3pt, fill: rgb("#" + str(item.color))))
      [ #item.langs]
      if s != none [
        #h(12pt) #fa("star") #s.stars
        #h(12pt) #fa("code-fork") #s.forks
      ]
    },
  ))
}

#section("Open Source Projects", block(breakable: false, grid(
  columns: (1fr, 1fr),
  gutter: 6pt,
  ..cv.sideProjects.map(card),
)))

// ---------- Education ----------
#section("Education", {
  for item in cv.education {
    h4(item.name)
    [#fa("graduation-cap") #item.degree (#item.dates) \ ]
    [#link(item.link), #item.location]
  }
})

