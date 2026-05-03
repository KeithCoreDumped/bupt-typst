# 北京邮电大学本科学士学位论文模板

北邮苦 Word 和 LaTeX 久矣，于是就出现了用 [Typst](https://github.com/typst/typst) 编写的毕业论文模板。

欢迎提出任何 Issue 和 PR 帮助完善这个模板。

## 在线编辑

进入 [Typst 官网](https://typst.app/) ，并将本模板的文件导入进去，但是你还需要导入一些**在线编辑器暂不支持**的字体（比如 `楷体` ），最终你的目录看起来会像是这个样子：

```
- images
	- bupt.png
- main.typ
- template.typ
- FZKTK.ttf
```

然后只要修改 `main.typ` 就可以了。

## 本地编译

进入 Typst 的 GitHub 仓库，下载 [release](https://github.com/typst/typst/releases) ，解压出 `typst.exe` 放入根目录。

更多本地编译的使用信息见 [Typst](https://github.com/typst/typst) 仓库的 README.md 。

非常推荐你使用在线编辑来书写 Typst 文档，本模板采用的字体几乎都是官方自带的字体。

如果进行本地编译的话，你需要在本仓库的 [release](https://github.com/QQKdeGit/bupt-typst/releases) 中下载所需的字体文件，并执行如下命令：

```shell
typst compile --font-path path/to/fonts main.typ
```

## 当前支持

- 内置封面 / 标题页
- 内置诚信声明与论文使用授权说明页
- 中文摘要、英文摘要
- 目录
- 正文章节标题样式与页眉页脚
- 图、表、公式、算法按章编号与中文引用
- 参考文献
- 附录
- 附录内手工维护的缩略语表包装函数

模板目标已经从“正文模板”升级为“可直接生成论文主体 PDF 的模板”。如果学校后续更新 Word 模板，优先对照 `template.typ` 中的前言页和版式常量进行微调。

## 暂不支持

- 新的三线表 / 续表 API
- 任务书、成绩评定表、开题报告、中期检查表等过程性材料
- 正文缩略语首次出现自动展开 / 自动追踪

## 用法

推荐直接使用 `title-cn`、`title-en` 和封面信息字段：

- `title-cn` / `title-en`
- `author`
- `student-id`
- `school`
- `major`
- `class`
- `supervisor`
- `date`
- `thesis-type`
- `degree-type`
- `confidentiality`

兼容性说明：

- 旧字段 `titleZH`、`titleEN` 仍可继续使用。
- `advisor` 会自动映射到 `supervisor`。

最小示例：

```typst
#import "template.typ": *

#show: BUPTBachelorThesis.with(
  title-cn: [中文题目],
  title-en: [English Title],
  author: [张三],
  student-id: [2021210000],
  school: [计算机学院],
  major: [计算机科学与技术],
  class: [2021211301],
  supervisor: [李四],
  date: [2026年5月],
  abstractZH: [中文摘要。],
  keywordsZH: ("关键词1", "关键词2"),
  abstractEN: [English abstract.],
  keywordsEN: ("keyword 1", "keyword 2"),
)

= 绪论

正文……

= 附录1 缩略语表

#AcronymList(
  (
    ("DPO", "Direct Preference Optimization，直接偏好优化"),
    ("RLHF", "Reinforcement Learning from Human Feedback，基于人类反馈的强化学习"),
  ),
  abbreviation-width: 2.1cm,
)
```

`AcronymList(...)` 只负责按 A-Z 排序并渲染两列表格，不带表头。左列是英文缩写，右列是解释文本；推荐直接写成二元组 `(缩写, 解释)`。如果需要调节列宽，可用 `abbreviation-width:`；也可以通过 `align:`、`inset:`、`stroke:` 做轻量调整。

## 字体

默认字体组合：

- 中文正文：`SimSun`
- 中文标题：`SimHei`
- 图表标题：`KaiTi`
- 西文：`Times New Roman`

如果本地缺字库，可通过 `--font-path` 指定字体目录：

```shell
typst compile --font-path path/to/fonts main.typ
```

常见差异：

- macOS 通常需要额外提供宋体 / 黑体 / 楷体。
- Windows 一般自带 `SimSun`、`SimHei`、`KaiTi`、`Times New Roman`。

## 说明

封面、诚信声明和版式数值参考并吸收了以下 MIT 许可项目的部分实现思路：

- [WongWang/typst-BUPT-Bachelor-Thesis](https://github.com/WongWang/typst-BUPT-Bachelor-Thesis)
- [FA555/bupt-upt](https://github.com/FA555/bupt-upt)

其中封面使用的校名 / 校徽 PDF 资源来自 WongWang 仓库中的 MIT 许可素材，已在本仓库内复用。
