#import "../template.typ": *

#let locate-one(sel) = {
  let matches = query(sel)
  assert.eq(matches.len(), 1, message: "expected exactly one match for " + repr(sel))
  matches.first().location()
}

#let element-one(sel) = {
  let matches = query(sel)
  assert.eq(matches.len(), 1, message: "expected exactly one match for " + repr(sel))
  matches.first()
}

#let chapter-at(loc) = {
  let nums = counter(heading).at(loc)
  assert(nums.len() > 0, message: "missing heading context for " + repr(loc))
  nums.first()
}

#let counter-number-at(ctr, loc) = {
  let nums = ctr.at(loc)
  assert(nums.len() > 0, message: "missing counter context for " + repr(loc))
  nums.first()
}

#let chaptered-number(chapter, number) = str(chapter) + "-" + str(number)
#let appendix-number(appendix, number) = "附" + str(appendix) + "-" + str(number)
#let heading-text(body) = repr(body)
#let is-appendix-heading-body(body) = heading-text(body).contains("附录")

#let nearest-level-1-heading-before(loc) = {
  let headings = query(selector(heading.where(level: 1)).before(loc))
  if headings.len() == 0 {
    none
  } else {
    headings.last()
  }
}

#let appendix-index-at(loc) = {
  let headings = query(selector(heading.where(level: 1)).before(loc))
  headings.filter(h => is-appendix-heading-body(h.body)).len()
}

#let is-appendix-context-at(loc) = {
  let nearest = nearest-level-1-heading-before(loc)
  assert(nearest != none, message: "missing level-1 heading context for " + repr(loc))
  is-appendix-heading-body(nearest.body)
}

#let numbered-display-at(loc, number) = {
  if is-appendix-context-at(loc) {
    appendix-number(appendix-index-at(loc), number)
  } else {
    chaptered-number(chapter-at(loc), number)
  }
}

#let figure-number-display-at(loc, number) = {
  if is-appendix-context-at(loc) {
    str(appendix-index-at(loc)) + "-" + str(number)
  } else {
    chaptered-number(chapter-at(loc), number)
  }
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

#let figure-number-at(kind, loc) = {
  let ctr = figure-counter-of-kind(kind)
  assert(ctr != none, message: "unsupported figure kind in counter test")
  figure-number-display-at(loc, counter-number-at(ctr, loc))
}

#let assert-eq-number(label, expected-counter, expected-display) = context {
  let loc = locate-one(label)
  let counter-value = counter-number-at(counter(math.equation), loc)
  let display-value = numbered-display-at(loc, counter-value)
  assert.eq(
    counter-value,
    expected-counter,
    message: "wrong equation counter for " + repr(label)
      + "\nexpected: " + repr(expected-counter)
      + "\nactual:   " + repr(counter-value),
  )
  assert.eq(
    display-value,
    expected-display,
    message: "wrong equation display for " + repr(label)
      + "\nexpected: " + repr(expected-display)
      + "\nactual:   " + repr(display-value),
  )
}

#let assert-figure-number(label, kind, expected-display) = context {
  let loc = locate-one(label)
  let display-value = figure-number-at(kind, loc)
  assert.eq(
    display-value,
    expected-display,
    message: "wrong figure/table/algorithm display for " + repr(label)
      + "\nexpected: " + repr(expected-display)
      + "\nactual:   " + repr(display-value),
  )
}

#let assert-heading-number(label, expected-chapter, expected-numbering) = context {
  let loc = locate-one(label)
  let nums = counter(heading).at(loc)
  let chapter-value = chapter-at(loc)
  let numbering-value = str(numbering(numbly(
    "第{1:一}章",
    "{1}.{2}",
    "{1}.{2}.{3}",
    "{1}.{2}.{3}.{4}",
  ), ..nums))
  assert.eq(
    chapter-value,
    expected-chapter,
    message: "wrong chapter for heading " + repr(label)
      + "\nexpected: " + repr(expected-chapter)
      + "\nactual:   " + repr(chapter-value),
  )
  assert.eq(
    numbering-value,
    expected-numbering,
    message: "wrong heading numbering for " + repr(label)
      + "\nexpected: " + repr(expected-numbering)
      + "\nactual:   " + repr(numbering-value),
  )
}

#let expected-ref-text(label) = {
  let el = element-one(label)
  let loc = el.location()
  if el.func() == math.equation {
    "式 " + numbered-display-at(loc, counter-number-at(counter(math.equation), loc))
  } else if el.func() == figure {
    let supplement = if el.kind == image {
      if is-appendix-context-at(loc) { "附图" } else { "图" }
    } else if el.kind == table {
      if is-appendix-context-at(loc) { "附表" } else { "表" }
    } else if el.kind == "algorithm" {
      if is-appendix-context-at(loc) { "附算法" } else { "算法" }
    } else {
      panic("unsupported figure kind in ref text test")
    }
    supplement + " " + figure-number-at(el.kind, loc)
  } else if el.func() == heading {
    let nums = counter(heading).at(loc)
    str(numbering(el.numbering, ..nums)) + if nums.len() != 1 { "节" }
  } else {
    panic("unsupported element in ref text test")
  }
}

#let assert-ref-text(label, expected) = context {
  let actual = expected-ref-text(label)
  assert.eq(
    actual,
    expected,
    message: "wrong ref text for " + repr(label)
      + "\nexpected: " + repr(expected)
      + "\nactual:   " + repr(actual),
  )
}

#BUPTBachelorThesis(
  title-cn: "计数器断言测试",
  title-en: "Counter Assertion Test",
  abstractZH: [用于验证图、表、公式、算法、标题的编号与跨章引用定位。],
  keywordsZH: ("Typst", "计数器"),
  abstractEN: [Regression test for counter-based numbering and reference helpers.],
  keywordsEN: ("Typst", "counter"),
  author: "张三",
  student-id: "2021210000",
  school: "计算机学院",
  major: "计算机科学与技术",
  class: "2021211301",
  supervisor: "李四",
  date: "2026年5月",
  equation-numbering-location: right + bottom,
)[
  = 第一章 <sec:ch1>

  == 小节 <sec:sub1>

  #figure(
    rect(width: 3cm, height: 1.8cm, fill: luma(230)),
    caption: [测试图一],
  )<fig:one>

  #figure(
    caption: [测试表一],
    table(
      columns: 2,
      [A], [B],
      [1], [2],
    ),
  )<tab:one>

  $
    a + b = c
  $ <eq:one>

  #figure(
    kind: "algorithm",
    supplement: [算法],
    caption: [测试算法一],
    algo[
      输入：$x$ \
      输出：$y$ \
      若 $x > 0$ \
      $y = x$ \
    ],
  )<algo:one>

  = 第二章 <sec:ch2>

  == 小节 <sec:sub2>

  $
    d + e = f
  $ <eq:two>

  #figure(
    rect(width: 3cm, height: 1.8cm, fill: luma(210)),
    caption: [测试图二],
  )<fig:two>

  #figure(
    caption: [测试表二],
    table(
      columns: 2,
      [C], [D],
      [3], [4],
    ),
  )<tab:two>

  #figure(
    kind: "algorithm",
    supplement: [算法],
    caption: [测试算法二],
    algo[
      输入：$m$ \
      输出：$n$ \
      若 $m > 0$ \
      $n = m$ \
    ],
  )<algo:two>

  = 第三章 <sec:ch3>

  跨章引用：@fig:one，@tab:one，@eq:one，@algo:one，@sec:sub2。

  #show: Appendix.with()

  = 附录1 附录测试一 <app:one>

  #figure(
    rect(width: 3cm, height: 1.8cm, fill: luma(190)),
    caption: [附录测试图一],
  )<fig:app-one>

  #figure(
    caption: [附录测试表一],
    table(
      columns: 2,
      [E], [F],
      [5], [6],
    ),
  )<tab:app-one>

  $
    p + q = r
  $ <eq:app-one>

  #figure(
    kind: "algorithm",
    supplement: [算法],
    caption: [附录测试算法一],
    algo[
      输入：$p$ \
      输出：$q$ \
      若 $p > 0$ \
      $q = p$ \
    ],
  )<algo:app-one>

  = 附录2 附录测试二 <app:two>

  $
    u + v = w
  $ <eq:app-two>

  #figure(
    rect(width: 3cm, height: 1.8cm, fill: luma(170)),
    caption: [附录测试图二],
  )<fig:app-two>

  #figure(
    caption: [附录测试表二],
    table(
      columns: 2,
      [G], [H],
      [7], [8],
    ),
  )<tab:app-two>

  #figure(
    kind: "algorithm",
    supplement: [算法],
    caption: [附录测试算法二],
    algo[
      输入：$u$ \
      输出：$v$ \
      若 $u > 0$ \
      $v = u$ \
    ],
  )<algo:app-two>

  #context {
    assert-heading-number(<sec:ch1>, 1, "第一章")
    assert-heading-number(<sec:sub1>, 1, "1.1")
    assert-heading-number(<sec:ch2>, 2, "第二章")
    assert-heading-number(<sec:sub2>, 2, "2.1")
    assert-heading-number(<sec:ch3>, 3, "第三章")

    assert-eq-number(<eq:one>, 1, "1-1")
    assert-eq-number(<eq:two>, 1, "2-1")
    assert-ref-text(<eq:one>, "式 1-1")
    assert-ref-text(<eq:two>, "式 2-1")

    assert-figure-number(<fig:one>, image, "1-1")
    assert-figure-number(<tab:one>, table, "1-1")
    assert-figure-number(<algo:one>, "algorithm", "1-1")
    assert-ref-text(<fig:one>, "图 1-1")
    assert-ref-text(<tab:one>, "表 1-1")
    assert-ref-text(<algo:one>, "算法 1-1")

    assert-figure-number(<fig:two>, image, "2-1")
    assert-figure-number(<tab:two>, table, "2-1")
    assert-figure-number(<algo:two>, "algorithm", "2-1")
    assert-ref-text(<fig:two>, "图 2-1")
    assert-ref-text(<tab:two>, "表 2-1")
    assert-ref-text(<algo:two>, "算法 2-1")
    assert-eq-number(<eq:app-one>, 1, "附1-1")
    assert-figure-number(<fig:app-one>, image, "1-1")
    assert-figure-number(<tab:app-one>, table, "1-1")
    assert-figure-number(<algo:app-one>, "algorithm", "1-1")
    assert-ref-text(<eq:app-one>, "式 附1-1")
    assert-ref-text(<fig:app-one>, "附图 1-1")
    assert-ref-text(<tab:app-one>, "附表 1-1")
    assert-ref-text(<algo:app-one>, "附算法 1-1")
    assert-eq-number(<eq:app-two>, 1, "附2-1")
    assert-figure-number(<fig:app-two>, image, "2-1")
    assert-figure-number(<tab:app-two>, table, "2-1")
    assert-figure-number(<algo:app-two>, "algorithm", "2-1")
    assert-ref-text(<eq:app-two>, "式 附2-1")
    assert-ref-text(<fig:app-two>, "附图 2-1")
    assert-ref-text(<tab:app-two>, "附表 2-1")
    assert-ref-text(<algo:app-two>, "附算法 2-1")
    assert-ref-text(<sec:ch1>, "第一章")
    assert-ref-text(<sec:sub1>, "1.1节")
    assert-ref-text(<sec:sub2>, "2.1节")
  }
]

#counter(heading).update(0)
#counter(math.equation).update(0)
#counter(figure.where(kind: image)).update(0)
#counter(figure.where(kind: table)).update(0)
#counter(figure.where(kind: "algorithm")).update(0)

#BUPTBachelorThesis(
  title-cn: "右侧公式编号断言测试",
  title-en: "Right Equation Numbering Test",
  abstractZH: [用于验证公式编号位于公式右侧时的计数逻辑。],
  keywordsZH: ("Typst", "公式"),
  abstractEN: [Regression test for right-side equation numbering.],
  keywordsEN: ("Typst", "equation"),
  author: "张三",
  student-id: "2021210000",
  school: "计算机学院",
  major: "计算机科学与技术",
  class: "2021211301",
  supervisor: "李四",
  date: "2026年5月",
  equation-numbering-location: right,
)[
  = 第一章 <sec:right-ch1>

  $
    x + y = z
  $ <eq:right-a>

  = 第二章 <sec:right-ch2>

  $
    m + n = p
  $ <eq:right-b>

  #context {
    assert-heading-number(<sec:right-ch1>, 1, "第一章")
    assert-heading-number(<sec:right-ch2>, 2, "第二章")
    assert-eq-number(<eq:right-a>, 1, "1-1")
    assert-eq-number(<eq:right-b>, 1, "2-1")
    assert-ref-text(<eq:right-a>, "式 1-1")
    assert-ref-text(<eq:right-b>, "式 2-1")
  }
]
