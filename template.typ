#import "@preview/itemize:0.2.0" as el
#import "@preview/cuti:0.4.0": fakebold, show-cn-fakebold

#let chineseNumMap(num) = {
  let chineseNum = (
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "七",
    "八",
    "九",
    "十",
    "十一",
    "十二",
    "十三",
    "十四",
    "十五",
    "十六",
    "十七",
    "十八",
    "十九",
    "二十",
    "二十一",
    "二十二",
    "二十三",
    "二十四",
    "二十五",
    "二十六",
    "二十七",
    "二十八",
    "二十九",
    "三十",
    "三十一",
    "三十二",
    "三十三",
    "三十四",
    "三十五",
    "三十六",
    "三十七",
    "三十八",
    "三十九",
    "四十",
  )
  chineseNum.at(num - 1)
}

#let romanNumMap(num) = {
  let romanNum = (
    "I",
    "II",
    "III",
    "IV",
    "V",
    "VI",
    "VII",
    "VIII",
    "IX",
    "X",
    "XI",
    "XII",
    "XIII",
    "XIV",
    "XV",
    "XVI",
    "XVII",
    "XVIII",
    "XIX",
    "XX",
    "XXI",
    "XXII",
    "XXIII",
    "XXIV",
    "XXV",
    "XXVI",
    "XXVII",
    "XXVIII",
    "XXIX",
    "XXX",
    "XXXI",
    "XXXII",
    "XXXIII",
    "XXXIV",
    "XXXV",
    "XXXVI",
    "XXXVII",
    "XXXVIII",
    "XXXIX",
    "XL",
  )
  romanNum.at(num - 1)
}

#let FONTSIZE = (
  SanHao: 16pt,
  XiaoSan: 15pt,
  SiHao: 14pt,
  XiaoSi: 12pt,
  WuHao: 10.5pt,
  XiaoWu: 9pt,
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
#let FontSong = (
  FontEnglish,
  "SimSun",
)
#let FontKai = (
  FontEnglish,
  "KaiTi",
)

#let tableCounter = counter("Table")
#let figureCounter = counter("Figure")
#let equationCounter = counter("Equation")

#let BUPTBachelorThesis(
  titleZH: "",
  abstractZH: "",
  keywordsZH: (),
  titleEN: "",
  abstractEN: "",
  keywordsEN: (),
  body,
) = {
  // 页面配置
  set page(paper: "a4", margin: 2.5cm)
  set text(font: FontSong, weight: "regular", size: FONTSIZE.XiaoSi)

  show: el.default-enum-list // 有序列表与内容基线对齐
  show: show-cn-fakebold // 中文伪粗体

  // 数学公式
  set math.equation(
    numbering: it => context [
      // 改用numbering实现，可在正文 @label
      #let chapterLevel = counter(heading).at(here()).at(0)
      #set text(font: FontSong)
      #h(0em, weak: true)
      式（#chapterLevel\-#equationCounter.display()）
      #h(0em, weak: true)
      #equationCounter.step()
    ],
    supplement: [], // 取消自带的 supplement "Equation"
  )

  // 代码
  show raw.where(block: true): it => {
    set block(stroke: 0.5pt, width: 100%, inset: 1em)
    it
  }

  // 中文摘要
  align(center)[
    #set text(font: FontHeiCN, weight: "bold")
    #v(0.6cm)
    #text(size: FONTSIZE.SanHao, titleZH)
    #v(1.4cm)
    #text(size: FONTSIZE.XiaoSan, "摘要")
    #v(0.45cm)
  ]

  set par(
    first-line-indent: (all: true, amount: 2em), // 首行缩进
    leading: 0.92em, // 段内行间距为1.25倍，不等于 1.25em
    spacing: 0.92em, // 段间距同样为1.25倍，不等于 1.25em
    justify: true, // 两端对齐
  )
  abstractZH

  [\ \ ]
  text(
    font: FontHeiCN,
    weight: "bold",
    size: FONTSIZE.XiaoSi,
    h(2em) + "关键词" + h(0.5em),
  )
  text(size: FONTSIZE.XiaoSi, keywordsZH.join(h(1em)))
  pagebreak()

  // 英文摘要
  align(center)[
    #v(0.2cm)
    #text(weight: "bold", size: FONTSIZE.SanHao, titleEN)
    #v(1.5cm)
    #text(weight: "bold", size: FONTSIZE.XiaoSan, "ABSTRACT")
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
  text(weight: "bold", size: FONTSIZE.XiaoSi, h(2em) + "KEY WORDS")
  text(size: FONTSIZE.XiaoSi, for value in keywordsEN {
    h(1em) + value
  })
  pagebreak()

  // 目录
  set page(
    footer: context {
      [
        #align(center)[
          #text(font: FontEnglish, size: FONTSIZE.XiaoWu)[
            #romanNumMap(counter(page).at(here()).at(0))
          ]
        ]
      ]
    },
  )
  counter(page).update(1)

  show outline: it => context {
    set par(first-line-indent: 0em, leading: 0.85em)

    align(center)[
      #text(font: FontHeiCN, weight: "bold", /*tracking: 2em, */ size: FONTSIZE.SanHao, [目录\ \ ]) // 2026模板移除了标题的2em空格
    ]

    let chapterCounter = 1
    let sectionCounter = 1
    let subsectionCounter = 1
    v(1cm)
    let headingList = query(heading)
    for i in headingList {
      link(i.location(), {
        if i.outlined == false {
          break
        }

        if i.level == 1 {
          set text(font: FontHei, size: FONTSIZE.XiaoSi /*, weight: "bold"*/) // 取消页码和点分隔符的加粗

          if i.body != [参考文献] and i.body != [致谢] and i.body != [附录] {
            // 2026模板移除了标题的2em空格
            [第#chineseNumMap(chapterCounter)章#h(1em)]
          }

          if i.body == [致谢] {
            [致谢 #box(width: 1fr, repeat[.]) #counter(page).at(i.location()).at(0)\ ]
          } else if i.body == [附录] {
            [附录 #box(width: 1fr, repeat[.]) #counter(page).at(i.location()).at(0)\ ]
          } else {
            [#i.body #box(width: 1fr, repeat[.]) #counter(page).at(i.location()).at(0)\ ]
          }

          chapterCounter = chapterCounter + 1
          sectionCounter = 1
        } else if i.level == 2 {
          // 手动增大缩进对齐模板
          [#h(1.5em)#calc.abs(chapterCounter - 1)\.#sectionCounter#h(1em)#i.body #box(width: 1fr, repeat[.]) #(
              counter(page).at(i.location()).at(0)
            )\ ]

          sectionCounter += 1
          subsectionCounter = 1
        } else if i.level == 3 {
          // 手动增大缩进对齐模板
          [#h(2.4em)#calc.abs(chapterCounter - 1)\.#calc.abs(sectionCounter - 1)\.#subsectionCounter#h(1em)#i.body #box(
              width: 1fr,
              repeat[.],
            ) #counter(page).at(i.location()).at(0)\ ]

          subsectionCounter += 1
        }
      })
    }
  }

  outline(title: none, depth: 3, indent: auto)

  // 章节标题配置
  set heading(numbering: "1.1")
  show heading: it => context {
    context {
      let levels = counter(heading).at(here())

      // 重置段首空格
      set par(first-line-indent: 0em)
      set text(font: FontHeiCN, weight: "bold")

      if it.level == 1 {
        // 重置计数器
        tableCounter.update(1)
        figureCounter.update(1)
        equationCounter.update(1)

        align(center)[
          #grid(
            rows: 0.95em,
            row-gutter: 0em,
            columns: 1fr,
            [],
            text(size: FONTSIZE.SanHao, [第#chineseNumMap(levels.at(0))章#h(0.5em)#it.body]),
            []
          )
        ]
      } else if it.level == 2 {
        grid(
          rows: (0em, 1em, 0.5em), // (0.5em, 1em, 0.5em),
          columns: 1fr,
          [],
          fakebold[ // 黑体序号使用伪粗体
            #numbering("1.1", ..levels)
            #text(size: FONTSIZE.SiHao, it.body)
          ],
          []
        )
      } else {
        grid(
          rows: (0.15em, 1em, 0.85em),
          columns: 1fr,
          [],
          fakebold[ // 黑体序号使用伪粗体
            #h(2em) #numbering("1.1", ..levels)
            #text(size: FONTSIZE.XiaoSi, it.body)
          ],
          []
        )
      }
    }
    text()[#v(-0.6em, weak: true)]
    text()[#h(0em)]
  }

  // 引用
  show cite: it => {
    text(font: FontEnglish, it)
    h(0em, weak: true) // 移除@cite的多余空格
  }

  // 页眉页脚
  set page(
    header: [
      #counter(footnote).update(0) // 重设脚注计数器，否则不同页脚注会累积
      #align(center)[
        #pad(bottom: -6pt)[
          #pad(bottom: -6pt, text(font: FontSong, size: FONTSIZE.XiaoWu, "北京邮电大学本科毕业设计（论文）"))
          #line(length: 100%, stroke: 0.5pt)
        ]
      ]
    ],
    footer: context [
      #pad(top:-13pt)[
        #align(center)[
          // 正文中数字是times new roman，页码数字使用宋体
          #text(font: "simsun", size: FONTSIZE.XiaoWu)[
            #counter(page).display()
          ]
        ]
      ]
    ],
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
  show figure.caption: set text(font: FontKai, size: FONTSIZE.WuHao)

  // 图
  show figure.where(kind: image): set figure(
    supplement: [图],
    numbering: it => {
      let chapterLevel = counter(heading).get().first()
      str(chapterLevel) + "-" + figureCounter.display() // 图序
    },
  )
  show figure.where(kind: image): set figure.caption(
    separator: h(1em), // 图序与图题之间空2个空格
  )
  show figure.where(kind: image): it => {
    figureCounter.step() // 计数器递增
    it
  }

  // 表
  show figure.where(kind: table): set figure(
    supplement: [表],
    numbering: it => {
      let chapterLevel = counter(heading).get().first()
      str(chapterLevel) + "-" + tableCounter.display() // 表序
    },
  )
  show figure.where(kind: table): set figure.caption(
    separator: h(1em), // 表序与图题之间空2个空格
    position: top,
  )
  show figure.where(kind: table): it => {
    tableCounter.step() // 计数器递增
    it
  }
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
        #let width = measure(it).width
        // 固定宽度盒子，避免撑大
        #box(width: width)[
          #align(left)[
            #text(size: 0.9em)[注：#note]
          ]
        ]
      ]
    } else {
      it
    }
  }

  // 正文
  body
}

#let primary_heading(
  title,
) = {
  grid(
    columns: 1fr,
    row-gutter: 0.2em,
    rows: (1em, 1em, 1em),
    [], [#title], []
  )
}

// 仅用于“参考文献”标题：单独减小上方留白
#let bibliography_heading(
  title,
) = {
  grid(
    columns: 1fr,
    row-gutter: 0.2em,
    rows: (0.3em, 1em, 1em),
    [], [#title], []
  )
}

// 仅用于“致谢/附录”标题：减小上方留白，保持下方留白不变
#let backmatter_heading(
  title,
) = {
  grid(
    columns: 1fr,
    row-gutter: 0.2em,
    rows: (0.3em, 1em, 1em),
    [], [#title], []
  )
}

#let render_backmatter_title(title) = align(center)[
  #set text(font: FontHeiCN, size: FONTSIZE.SanHao)
  #backmatter_heading([#title])
]

// 附录部分
#let Appendix(
  bibliographyFile: none,
  body,
) = {
  show heading: it => context {
    set par(first-line-indent: 0em)

    if it.level == 1 {
      render_backmatter_title(it.body)
    } else if it.level == 2 {
      text(
        font: FontSong,
        weight: "regular",
        size: FONTSIZE.XiaoSi,
        it.body,
      )
    }
  }

  // 参考文献
  if bibliographyFile != none {
    pagebreak()
    align(center)[
      #set text(font: FontHeiCN, size: FONTSIZE.SanHao)
      #bibliography_heading([参考文献])
    ]

    set text(
      font: FontSong,
      size: FONTSIZE.WuHao,
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
