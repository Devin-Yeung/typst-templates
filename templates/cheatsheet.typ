
// Creating Dividing Line
#let dividing(text) = {
  let line = box(
    line(length: 100%, stroke: 0.5pt),
    baseline: 0.4em,
  )
  parbreak()
  grid(
    columns: (1fr, auto, 2.5fr),
    column-gutter: 0.5em,
    line, [#text], line,
  )
}

#let argmin = math.op("arg min", limits: true)

#let argmax = math.op("arg max", limits: true)

#let template(doc) = [
  #set columns(gutter: 1.2em)
  #set page(
    paper: "a4",
    columns: 2,
    margin: (
      x: 1em,
      y: 1em,
    ),
  )

  #show regex("[\u4e00-\u9fa5]"): set text(
    font: "LXGW Wenkai",
    lang: "zh",
  )

  #set par(
    justify: true,
    spacing: 0.55em,
  )

  #show math.equation.where(block: true): it => [
    #v(0.1em)
    #it
    #v(0.1em)
  ]

  #set text(
    size: 8pt,
    font: "Libertinus Sans",
  )

  #set table(
    inset: 0.5em,
    stroke: 0.08em,
  )

  #doc
]
