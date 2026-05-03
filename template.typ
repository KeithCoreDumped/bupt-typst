#import "@preview/itemize:0.2.0" as el
#import "@preview/cuti:0.4.0": fakebold, show-cn-fakebold
#import "@preview/numbly:0.1.0": numbly
#import "@preview/algo:0.3.6": algo, code, comment, d, i

#let FONTSIZE = (
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
)

// #let FONTSET = (
//   Hei: "SimHei", // ("Inter", "Noto Sans CJK SC"),
//   Song: "SimSun", // "Noto Serif CJK SC",
//   Kai: "KaiTi", // "FZKai-Z03",
//   English: "Times New Roman", // "STIX Two Text",
// )

#let FontEnglish = (name: "Times New Roman", covers: "latin-in-cjk")

#let FontHeiCN = "SimHei"
#let FontHei = (
  FontEnglish,
  "SimHei",
)
#let FontSongCN = "SimSun"
#let FontSong = (
  FontEnglish,
  FontSongCN,
)
#let FontKai = (
  FontEnglish,
  "KaiTi",
)

#let PAGE_MARGIN = (
  top: 2.5cm,
  bottom: 2.5cm,
  left: 2.5cm,
  right: 2.5cm,
)

#let BODY_LEADING = 1.2621em
#let BODY_SPACING = 1.2621em
#let OUTLINE_LEADING = 4.16mm
#let HEADER_TEXT_TOP = 15.6mm
#let HEADER_RULE_TOP = 19.45mm
#let HEADER_RULE_STROKE = 0.72pt
#let FOOTER_TEXT_TOP = 5.95mm

#let main-header = context {
  place(top + center, dy: HEADER_TEXT_TOP)[
    #set text(font: FontSong, size: FONTSIZE.小五, top-edge: "bounds")
    北京邮电大学本科毕业设计（论文）
  ]
  place(top + center, dy: HEADER_RULE_TOP + HEADER_RULE_STROKE / 2)[
    #line(length: 100%, stroke: HEADER_RULE_STROKE)
  ]
}

#let main-footer = context place(top + center, dy: FOOTER_TEXT_TOP)[
  #set text(font: FontSongCN, size: FONTSIZE.小五, top-edge: "bounds")
  #counter(page).display("1")
]

#let roman-footer = context place(top + center, dy: FOOTER_TEXT_TOP)[
  #set text(font: FontEnglish, size: FONTSIZE.小五, top-edge: "bounds")
  #counter(page).display("I")
]

#let prefer-value(primary, fallback: none, default: none) = {
  if primary != none {
    primary
  } else if fallback != none {
    fallback
  } else {
    default
  }
}

#let content-or-empty(value) = if value == none { [] } else { value }

#let cover-date(date) = if date == none { [] } else { fakebold[#date] }

#let make-cover-page(info) = {
  let title-cn = content-or-empty(info.title-cn)
  let date = info.date

  {
    // Cover layout adapted closely from WongWang/typst-BUPT-Bachelor-Thesis (MIT).
    set page(header: none, footer: none, numbering: none)
    set par(leading: 0.25em, first-line-indent: 0pt, spacing: 0.25em)

    v(0.04mm)
    align(center)[
      #box(inset: (left: 6.4mm))[
        #image("images/bupt-name.pdf", width: 94.75mm)
      ]
    ]

    v(16.7mm)
    align(center)[
      #box(inset: (left: 7.0mm))[
        #text(font: FontHei, size: 26pt)[
          #fakebold[本#h(0.5em)科#h(0.5em)毕#h(0.5em)业#h(0.5em)设#h(0.5em)计（#h(0.5em)论#h(0.5em)文#h(0.5em)）#h(0.8em)]
        ]
      ]
    ]

    v(13.5mm)
    figure(
      image("images/bupt-logo.pdf"),
    )

    v(11.1mm)
    {
      let line-length = 100.8mm
      let line-offset = 3.5pt
      set text(font: FontHeiCN, size: FONTSIZE.三号)
      set par(leading: 0.75em)
      context {
        let title-body = fakebold[#title-cn]
        let title-w = measure(title-body).width
        let two-lines = title-w > line-length
        let content-h = measure(box(width: line-length, align(center, title-body))).height
        let single-h = measure(box(width: line-length, align(center, fakebold[题]))).height

        align(center)[
          #box(inset: (left: 2.9mm))[
            #fakebold[题目：]#box(width: line-length, baseline: content-h - single-h)[
              #align(center)[#title-body]
              #place(left + top, dy: content-h + line-offset)[
                #line(length: line-length, stroke: 0.5pt)
              ]
              #if two-lines {
                let first-line-h = single-h
                place(left + top, dy: first-line-h + line-offset)[
                  #line(length: line-length, stroke: 0.5pt)
                ]
              }
            ]
          ]
        ]
      }
    }

    v(18.0mm)
    {
      let lw = 4em
      let all-values = (
        str(content-or-empty(info.author)),
        str(content-or-empty(info.school)),
        str(content-or-empty(info.major)),
        str(content-or-empty(info.class)),
        str(content-or-empty(info.student-id)),
        str(content-or-empty(info.supervisor)),
      )
      let vw = 12em

      set text(size: FONTSIZE.三号)
      let make-label(s) = {
        let chars = s.clusters()
        box(width: lw, text[#fakebold[#chars.join(h(1fr))]])
      }
      let info-row(label, value) = (
        make-label(label),
        box(width: vw)[
          #align(center)[#fakebold[#content-or-empty(value)]]
          #place(left + bottom, dy: 0.5mm)[
            #line(length: 100%, stroke: 0.5pt)
          ]
        ],
      )
      align(center)[
        #box(inset: (right: 2mm))[
          #grid(
            columns: (lw, vw),
            column-gutter: 0cm,
            row-gutter: 5.72mm + 3.5pt,
            align: (left, left),
            ..info-row("姓名", info.author),
            ..info-row("学院", info.school),
            ..info-row("专业", info.major),
            ..info-row("班级", info.class),
            ..info-row("学号", info.student-id),
            ..info-row("指导教师", info.supervisor),
          )
        ]
      ]
    }

    v(17.8mm)
    align(center)[
      #box(inset: (left: 14.0mm))[
        #text(font: FontSongCN, size: FONTSIZE.三号)[
          #cover-date(date)
        ]
      ]
    ]
    pagebreak()
  }
}

#let default-integrity-statement-body(info) = [
  本人声明所呈交的毕业设计（论文），题目《#content-or-empty(info.title-cn)》是本人在指导教师的指导下，独立进行研究工作所取得的成果。尽我所知，除了文中特别加以标注和致谢中所列内容外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得北京邮电大学或其他教育机构的学位或证书而使用过的材料。

  申请学位论文与资料若有不实之处，本人承担一切相关责任。
]

#let default-authorization-statement-body() = [
  本人完全了解并同意北京邮电大学有关保留、使用学位论文的规定，即：北京邮电大学拥有以下关于学位论文的无偿使用权，具体包括：学校有权保留并向国家有关部门或机构送交学位论文，有权允许学位论文被查阅和借阅；学校可以公布学位论文的全部或部分内容，有权允许采用影印、缩印或其它复制手段保存、汇编学位论文，将学位论文的全部或部分内容编入有关数据库进行检索。（保密的学位论文在解密后遵守此规定）
]

#let make-integrity-statement-page(
  info,
  integrity-body: none,
  authorization-body: none,
  author-signature: none,
  author-sign-date: none,
  advisor-signature: none,
  advisor-sign-date: none,
) = {
  let integrity-body = prefer-value(integrity-body, default: default-integrity-statement-body(info))
  let authorization-body = prefer-value(authorization-body, default: default-authorization-statement-body())

  {
    // Statement page adapted closely from WongWang/typst-BUPT-Bachelor-Thesis (MIT).
    set page(header: none, footer: none, numbering: none)
    set par(first-line-indent: 0em, spacing: 0.25em, leading: 0.25em)

    v(12mm)
    align(center, text(size: FONTSIZE.小三)[
      #fakebold[北#h(0.5em)京#h(0.5em)邮#h(0.5em)电#h(0.5em)大#h(0.5em)学]
    ])
    v(5.36mm)
    align(center, text(size: FONTSIZE.小三)[
      #fakebold[本科毕业设计（论文）诚信声明]
    ])

    v(1.03mm)
    set par(first-line-indent: 2em, leading: 1.26em, spacing: 1.26em)
    set text(size: FONTSIZE.小四)
    integrity-body

    v(7.32mm)
    [
      #h(0.02mm) 本人签名：#box(width: 42.34mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(author-signature)]
      ] #h(9.52mm) 日期：#box(width: 48.69mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(author-sign-date)]
      ]
    ]

    v(28.23mm)
    align(center, text(size: FONTSIZE.小三)[
      #fakebold[关于论文使用授权的说明]
    ])

    v(-0.34mm)
    authorization-body

    v(7.35mm)
    [
      #h(0.02mm) 本人签名：#box(width: 42.34mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(author-signature)]
      ] #h(9.52mm) 日期：#box(width: 48.69mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(author-sign-date)]
      ]
    ]
    v(7.32mm)
    [
      #h(0.02mm) 导师签名：#box(width: 42.34mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(advisor-signature)]
      ] #h(9.52mm) 日期：#box(width: 48.69mm, outset: (bottom: 2pt), stroke: (bottom: 0.5pt))[
        #align(center + horizon)[#content-or-empty(advisor-sign-date)]
      ]
    ]
    pagebreak()
  }
}

#let chapter-at(loc) = {
  let nums = counter(heading).at(loc)
  if nums.len() > 0 { nums.first() } else { 0 }
}

#let counter-number-at(ctr, loc) = {
  let nums = ctr.at(loc)
  if nums.len() > 0 { nums.first() } else { 0 }
}

#let current-chapter() = {
  let nums = counter(heading).get()
  if nums.len() > 0 { nums.first() } else { 0 }
}

#let chaptered-number(chapter, number) = str(chapter) + "-" + str(number)

#let equation-marker-at(loc) = {
  let chapter = chapter-at(loc)
  let number = counter-number-at(counter(math.equation), loc)
  text(font: FontSong)[(#chaptered-number(chapter, number))]
}

#let figure-counter-of-kind(kind) = {
  if kind == image {
    counter(figure.where(kind: image))
  } else if kind == table {
    counter(figure.where(kind: table))
  } else if kind == "algorithm" {
    counter(figure.where(kind: "algorithm"))
  } else {
    none
  }
}

#let figure-supplement-of-kind(kind) = {
  if kind == image {
    [图]
  } else if kind == table {
    [表]
  } else if kind == "algorithm" {
    [算法]
  } else {
    none
  }
}

#let figure-number-at(kind, loc) = {
  let ctr = figure-counter-of-kind(kind)
  if ctr == none {
    none
  } else {
    chaptered-number(chapter-at(loc), counter-number-at(ctr, loc))
  }
}

#let AcronymList(
  items,
  abbreviation-width: 2.4cm,
  align: (left, left),
  inset: (x: 0.35em, y: 0.45em),
  stroke: none,
) = {
  let sorted = items.sorted(key: item => str(item.at(0)))
  if sorted.len() == 0 {
    return
  }
  set par(first-line-indent: 0em, leading: BODY_LEADING, spacing: BODY_SPACING)
  table(
    columns: (abbreviation-width, 1fr),
    align: align,
    inset: inset,
    stroke: stroke,
    ..sorted.flatten(),
  )
}

#let BUPTBachelorThesis(
  title: none,
  title-cn: none,
  titleZH: "",
  title-en: none,
  abstractZH: "",
  keywordsZH: (),
  titleEN: "",
  abstractEN: "",
  keywordsEN: (),
  author: none,
  student-id: none,
  school: none,
  major: none,
  class: none,
  advisor: none,
  supervisor: none,
  date: none,
  info-meta: none,
  integrity-body: none,
  authorization-body: none,
  author-signature: none,
  author-sign-date: none,
  advisor-signature: none,
  advisor-sign-date: none,
  equation-numbering-location: right + bottom,
  body,
) = {
  assert((right, right + bottom).contains(equation-numbering-location), message: "can be only right or right + bottom")
  let info-meta = if info-meta == none { (:) } else { info-meta }
  let info = (
    title-cn: prefer-value(title-cn, fallback: prefer-value(titleZH, fallback: title)),
    title-en: prefer-value(title-en, fallback: titleEN),
    author: prefer-value(author, fallback: info-meta.at("author", default: none)),
    student-id: prefer-value(student-id, fallback: info-meta.at("student-id", default: none)),
    school: prefer-value(school, fallback: info-meta.at("school", default: none)),
    major: prefer-value(major, fallback: info-meta.at("major", default: none)),
    class: prefer-value(class, fallback: info-meta.at("class", default: none)),
    supervisor: prefer-value(supervisor, fallback: prefer-value(advisor, fallback: info-meta.at(
      "supervisor",
      default: none,
    ))),
    date: prefer-value(date, fallback: info-meta.at("date", default: none)),
  )
  // 页面配置
  set page(
    paper: "a4",
    margin: PAGE_MARGIN,
    header-ascent: 0cm,
    footer-descent: 0cm,
  )
  set text(
    font: FontSong,
    weight: "regular",
    size: FONTSIZE.小四,
    costs: ( // 允许孤行/寡行
      widow: 0%,
      orphan: 0%,
    ),
  )

  show: el.paragraph-enum-list.with(
    indent: 0em,
    label-indent: 2em,
  ) // 有序列表与内容基线对齐，首行/悬挂缩进对齐word模板
  show: show-cn-fakebold // 中文伪粗体

  // 数学公式
  set math.equation(
    numbering: (..nums) => context {
      let num = if nums.pos().len() > 0 { nums.pos().first() } else { 0 }
      if equation-numbering-location == right {
        text(font: FontSong)[(#chaptered-number(current-chapter(), num))]
      } else {
        []
      }
    },
    supplement: none, // 取消自带的 supplement "Equation"
  )
  show math.equation.where(block: true): set block(
    above: 0em,
    below: 0em,
  )
  show math.equation.where(block: true): it => block(
    above: 7.4mm,
    below: 7.4mm,
    width: 100%,
    {
      it
      if equation-numbering-location == right + bottom {
        // 公式编号单独占用一行固定高度，保证与后续正文间距稳定。
        block(width: 100%, height: BODY_LEADING)[
          #align(right + top, equation-marker-at(it.location()))
        ]
      }
    },
  )
  // @equation => 式4-1
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      let loc = el.location()
      link(loc)[式 #chaptered-number(chapter-at(loc), counter-number-at(counter(math.equation), loc))]
    } else if el != none and el.func() == figure {
      let loc = el.location()
      let supplement = figure-supplement-of-kind(el.kind)
      let number = figure-number-at(el.kind, loc)
      if supplement != none and number != none {
        link(loc)[#supplement #number]
      } else {
        it
      }
    } else if el != none and el.func() == heading {
      let loc = el.location()
      let numbers = counter(heading).at(loc)
      h(0em, weak: true)
      link(loc)[
        #numbering(el.numbering, ..numbers)
      ]
      if numbers.len() != 1 [节]
      h(0em, weak: true)
    } else {
      it
    }
  }

  // 代码
  show raw.where(block: true): it => {
    set block(stroke: 0.5pt, width: 100%, inset: 1em)
    it
  }

  make-cover-page(info)
  make-integrity-statement-page(
    info,
    integrity-body: integrity-body,
    authorization-body: authorization-body,
    author-signature: author-signature,
    author-sign-date: author-sign-date,
    advisor-signature: advisor-signature,
    advisor-sign-date: advisor-sign-date,
  )

  // 中文摘要
  align(center)[
    #set text(font: FontHei, weight: "bold")
    #v(0.6cm)
    #text(size: FONTSIZE.三号, info.title-cn)
    #v(1.4cm)
    #text(size: FONTSIZE.小三, "摘要")
    #v(0.45cm)
  ]

  set par(
    first-line-indent: (all: true, amount: 2em), // 首行缩进
    leading: BODY_LEADING,
    spacing: BODY_SPACING,
    justify: true, // 两端对齐
  )
  abstractZH

  [\ \ ]
  text(
    font: FontHeiCN,
    weight: "bold",
    size: FONTSIZE.小四,
    h(2em) + "关键词" + h(0.5em),
  )
  text(size: FONTSIZE.小四, keywordsZH.join(h(1em)))
  pagebreak(to: "odd", weak: true)

  // 英文摘要
  align(center)[
    #v(0.2cm)
    #text(weight: "bold", size: FONTSIZE.三号, info.title-en)
    #v(1.5cm)
    #text(weight: "bold", size: FONTSIZE.小三, "ABSTRACT")
    #v(0.8cm)
  ]

  [
    #set par(
      leading: 1.05em,
      spacing: 1.05em,
    )
    #abstractEN
  ]


  [\ ]
  text(weight: "bold", size: FONTSIZE.小四, h(2em) + "KEY WORDS")
  text(size: FONTSIZE.小四, for value in keywordsEN {
    h(1em) + value
  })

  pagebreak(to: "odd", weak: true)

  // 标题样式
  set heading(numbering: numbly(
    "第{1:一}章", // use {level:format} to specify the format
    "{1}.{2}", // if format is not specified, arabic numbers will be used
    "{1}.{2}.{3}",
    "{1}.{2}.{3}.{4}", // here, we only want the 4th level
  ))
  show heading.where(level: 1): it => {
    pagebreak(to: "odd", weak: true)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(math.equation).update(0)
    counter(figure.where(kind: "algorithm")).update(0)
    let number = if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      // h(0.5em)
    }
    set par(first-line-indent: 0pt)
    v(1.8mm)
    align(center)[
      #set text(weight: "bold")
      #set text(font: FontHeiCN, size: FONTSIZE.三号)
      #number
      #set text(font: FontHei, size: FONTSIZE.三号)
      #it.body
    ]
    v(7.8mm)
  }
  show heading.where(level: 2): it => {
    let number = if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      // h(0.5em)
    }
    set par(first-line-indent: 0pt)
    v(1.44mm)
    [
      #set text(weight: "bold")
      #set text(font: FontHeiCN, size: FONTSIZE.四号)
      #number
      #set text(font: FontHei, size: FONTSIZE.四号)
      #it.body
    ]
    v(1.85mm)
  }
  show heading.where(level: 3): it => {
    let number = if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      // h(0.5em)
    }
    set par(first-line-indent: 0pt)
    v(1.10mm)
    pad(left: 2em)[
      #set text(weight: "bold")
      #set text(font: FontHeiCN, size: FONTSIZE.小四)
      #number
      #set text(font: FontHei, size: FONTSIZE.小四)
      #it.body
    ]
    v(4.14mm)
  }
  show heading.where(level: 4): it => {
    let number = if it.numbering != none {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      h(0.5em)
    }
    set par(first-line-indent: 0pt)
    v(2.11mm)
    pad(left: 2em)[
      #set text(weight: "bold")
      #set text(font: FontHeiCN, size: FONTSIZE.五号)
      #number
      #set text(font: FontHei, size: FONTSIZE.五号)
      #it.body
    ]
    v(2.11mm)
  }

  // 目录
  set page(
    numbering: "I",
    footer: roman-footer,
  )
  counter(page).update(1)

  align(center)[
    #text(font: FontHeiCN, weight: "bold", /*tracking: 2em, */ size: FONTSIZE.三号, [目录\ \ ]) // 2026模板移除了标题的2em空格
  ]
  show outline.entry: it => {
    set par(first-line-indent: 0em, leading: OUTLINE_LEADING, spacing: OUTLINE_LEADING)
    let indent = (it.level - 1) * 2em
    let elem = it.element
    let loc = elem.location()
    let body = elem.body
    if not elem.outlined {
      return
    }

    link(loc, {
      if it.level == 1 {
        text(
          font: FontHei,
          size: FONTSIZE.小四,
          if elem.numbering != none {
            numbering(elem.numbering, ..counter(heading).at(loc))
            h(0.5em, weak: true)
          }
            + body,
        )
      } else {
        h(indent)
        numbering(elem.numbering, ..counter(heading).at(loc))
        h(0.5em)
        body
      }

      box(width: 1fr, repeat(gap: 0.05em)[.])

      [#counter(page).at(loc).at(0) \ ]
    })
  }

  outline(title: none, depth: 3, indent: auto)

  set page(numbering: "1")

  // 引用
  show cite: set text(font: FontEnglish)
  show cite: it => {
    show "–": "-"
    it
  }
  // 恢复@cite的多余空格，恢复字体为英文字体

  // 页眉页脚
  set page(
    header: main-header,
    footer: main-footer,
  )
  counter(page).update(1)

  // 脚注
  set footnote(numbering: "①")
  set footnote.entry(separator: none)
  show footnote: set super(baseline: -0.5em)
  show footnote.entry: it => {
    set super(size: 0.65em, baseline: -0.4em)
    show super: it => {
      it + h(3pt) // entry中序号和文本的空格
    }
    it
  }

  // 图表标题
  show figure.caption: set text(font: FontKai, size: FONTSIZE.五号)

  // 图
  show figure.where(kind: image): set figure(
    supplement: [图],
    numbering: (..nums) => context {
      let num = if nums.pos().len() > 0 { nums.pos().first() } else { 0 }
      chaptered-number(current-chapter(), num)
    },
  )
  show figure.where(kind: image): set figure.caption(
    separator: h(1em), // 图序与图题之间空2个空格
  )

  // 表
  show figure.where(kind: table): set figure(
    supplement: [表],
    numbering: (..nums) => context {
      let num = if nums.pos().len() > 0 { nums.pos().first() } else { 0 }
      chaptered-number(current-chapter(), num)
    },
  )
  show figure.where(kind: table): set figure.caption(
    separator: h(1em), // 表序与图题之间空2个空格
    position: top,
  )
  set table(
    stroke: (x, y) => if y == 0 {
      (top: 0.5pt, bottom: 0.5pt) // 首行顶/底分割线
    },
    inset: 5.8pt,
  )
  set table.hline(stroke: 0.5pt)

  // 表格后处理：可选表注
  show figure.where(kind: table): it => context {
    let next-figs = query(selector(figure.where(kind: table)).after(here()))
    let next-fig-loc = if next-figs.len() > 0 {
      next-figs.first().location()
    } else {
      none
    }
    let sel = if next-fig-loc == none {
      selector(metadata).after(here())
    } else {
      selector(metadata).after(here()).before(next-fig-loc)
    }
    let metas = query(sel)
    let notes = metas.filter(s => s.value.role == "tablenote").map(s => s.value.body)
    let note = if notes.len() > 0 { notes.first() } else { none }

    if note != none {
      block[
        #it
        #v(3pt, weak: true) // 表注和表的距离
        #layout(size => {
          // 获取父元素宽度，否则当传入相对长度时measure按照无限大计算
          let m = measure(width: size.width, it)
          // 固定宽度盒子，避免撑大
          box(width: m.width)[
            #align(left)[
              #set par(first-line-indent: 0em) // 移除表注的首行缩进
              #text(size: 0.9em)[注：#note]
            ]
          ]
        })
        #let width = measure(it).width

      ]
    } else {
      it
    }
  }

  // 算法
  show figure.where(kind: "algorithm"): set figure(
    supplement: [算法],

    numbering: (..nums) => context {
      let num = if nums.pos().len() > 0 { nums.pos().first() } else { 0 }
      chaptered-number(current-chapter(), num)
    },
  )
  show figure.where(kind: "algorithm"): set figure.caption(
    separator: h(1em),
  )
  show figure.caption.where(kind: "algorithm"): []
  show figure.where(kind: "algorithm"): it => {
    set table.cell(align: left)
    table(
      columns: (1fr,),
      {
        it.supplement
        figure-number-at("algorithm", it.location())
        h(0.5em)
        it.caption.body
      },
      it.body,
      table.hline(),
    )
  }

  // 正文
  body
}

// 附录部分
#let Appendix(
  bibliographyFile: none,
  body,
) = {
  set heading(numbering: none)
  let subheadings = heading.where(level: 2).or(heading.where(level: 3)).or(heading.where(level: 4))
  show subheadings: set heading(outlined: false)

  // 参考文献
  if bibliographyFile != none {
    [= 参考文献]

    set text(
      font: FontSong,
      size: FONTSIZE.五号,
      lang: "zh",
    )
    set par(first-line-indent: 0em)
    bibliography(
      bibliographyFile,
      title: none,
      style: "gb-7714-2015-numeric",
    )
    show bibliography: it => {}
  }

  body
}

// 表注
#let tablenote(body) = metadata((role: "tablenote", body: body))

#let algo = algo.with(
  indent-size: 1.5em,
  line-numbers: false,
  stroke: none,
  fill: none,
  block-align: left,
)

#let Achevements(body) = {
  set enum(numbering: "[1]")
  set heading(outlined: false)
  show heading.where(level: 2): it => {
    set par(first-line-indent: 0em)
    set text(font: FontHeiCN, size: FONTSIZE.四号, weight: "bold")
    block(
      above: 1.5em,
      below: 1.5em,
      it.body,
    )
  }
  body
  pagebreak(to: "odd", weak: true) // 最后的空页
}

#let cite-inline(key) = cite(key, style: "numeric-inline.csl")
