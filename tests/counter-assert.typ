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
  chaptered-number(chapter-at(loc), counter-number-at(ctr, loc))
}

#let assert-eq-number(label, expected-counter, expected-display) = context {
  let loc = locate-one(label)
  let counter-value = counter-number-at(counter(math.equation), loc)
  let display-value = chaptered-number(chapter-at(loc), counter-value)
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
    "式 " + chaptered-number(chapter-at(loc), counter-number-at(counter(math.equation), loc))
  } else if el.func() == figure {
    let supplement = if el.kind == image {
      "图"
    } else if el.kind == table {
      "表"
    } else if el.kind == "algorithm" {
      "算法"
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
