# Kemou 博客 AI 维护规则

本项目是 Kemou 的个人博客，基于 Astro/Fuwari 修改。Kemou 是技术初学者，完成任务后要用简体中文说明结果，避免只给术语或命令。

## 新增内容

- 正式文章与随笔都放在 `src/content/posts/`，一篇内容对应一个 `.md` 或 `.mdx` 文件。
- 图片放在 `public/assets/images/`；正文使用 `/assets/images/文件名` 引用。
- 文件名使用小写英文、数字和连字符，发布后不要随意修改，以免旧链接失效。
- 必填或常用 frontmatter：`title`、`published`、`description`、`image`、`tags`、`category`、`draft`。
- 随笔仍然是普通文章，默认归入 `生活随记`，不要为它复制一套页面。
- 除非 Kemou 明确要求，不要擅自改写文章观点、补造经历或添加大段 AI 腔说明。

## 分类与颜色

- 文章 frontmatter **不填写颜色字段**，也不要在文章组件里写行内色值。
- 唯一配色规则位于 `src/utils/accent-utils.ts`，文章卡片、分类侧栏和归档页共用该文件。
- 现有分类固定为：`AI 与工具`→青蓝、`学习与项目`→蓝紫、`游戏与体验`→珊瑚橙、`生活随记`→薄荷绿。
- 新分类会按名称自动获得稳定颜色，不需要 AI 临时挑色。
- 只有 Kemou 明确提出调整整个配色系统时，才修改 `accent-utils.ts` 或 `src/styles/variables.styl`。

## 视觉维护

- 遵守新拟物语义：外壳凸起、输入/相框/读数槽下沉、按钮悬停抬升且按下下沉。
- 统一光源为左上反光、右下投影；塑料与亚克力只能反光，不能使用霓虹外发光。
- 优先复用 `src/styles/main.css` 中的公共拟物类和 `src/styles/variables.styl` 中的设计令牌。
- 不要为了单个页面复制一套阴影、颜色或动画规则。

## 修改与验证

- 修改前先查看 Git 状态，保留用户尚未提交的改动。
- 不直接编辑 `dist/`、`.astro/` 或 `node_modules/`，它们都是生成内容或依赖。
- 完成整批修改后只运行一次正式构建；Windows PowerShell 优先使用 `pnpm.cmd build`。
- 只有构建失败时才针对真实错误修复并重试，不做没完没了的检查。
- 只有 Kemou 明确要求发布时才提交并推送到 GitHub；发布后确认一次 GitHub Pages 任务即可。

详细发文步骤见 `AI内容维护指南.md`，整体美术规范见 `设计思路与注意事项.md`。
