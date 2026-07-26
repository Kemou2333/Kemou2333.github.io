# Kemou 的博客

一个记录 AI、游戏、学习与生活想法的个人博客。

网站基于 [Fuwari](https://github.com/saicaca/fuwari) 与 [Astro](https://astro.build/) 构建，并针对 Kemou 的内容与拟态视觉风格进行了定制。
（功劳全归GPT和KIMI）
## 本地运行

```bash
pnpm install
pnpm dev
```

## 添加文章

文章存放在 `src/content/posts/`，图片存放在 `public/assets/images/`。新增文章不需要重新开发首页、分类或归档页面。也可以运行：

```bash
pnpm new-post article-name
```

文章和图片准备完成后，Windows 用户可双击根目录的 `一键发布博客.cmd`。推送到 `main` 分支后，GitHub Pages 会自动构建并发布网站。

交给 AI 维护时，先完整阅读 `AGENTS.md`。
