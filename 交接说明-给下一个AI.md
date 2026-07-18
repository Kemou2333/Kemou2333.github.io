# ⚠️ 给下一个 AI 的交接说明(先读这个)

> 这个项目已经不是原版 Fuwari。2026-07-18 由 Kimi(K3)完成了**三轮新拟物(Neumorphism)改造**。
> 在你动手改任何样式之前,请先读完这份说明和 `设计思路与注意事项.md`,避免把已经修好的问题又改回去。

## 一、项目现状一句话

基于 Fuwari(Astro 5 + Svelte 5 + Tailwind 3 + Stylus + Pagefind + PhotoSwipe)的个人博客,
视觉语言是"同一套浅蓝紫塑料/亚克力设备外壳"的新拟物风格:统一左上光源、凹凸有语义、卡片不透明、无发光效果。
运行:`pnpm install` → `pnpm dev`;构建:`pnpm build`(自动生成 Pagefind 搜索索引);预览:`pnpm preview`。

## 二、改了哪些文件、为什么(按轮次)

### 第 1 轮:修复交接包源码的遗留问题

| 文件 | 改动 | 原因 |
| --- | --- | --- |
| `src/styles/main.css` | `@media (max-width:767px) { @layer components {...} }` 改为 `@layer components { @media ... }` | **Tailwind/PostCSS 会静默丢弃 media 里的 layer**,曾导致桌面端前后文章导航变单列、文章卡左侧灯条全端消失 |
| `src/styles/main.css` | `.neu-row` 换更亮渐变 + 更强投影;新增 `#categories { display:flex; flex-direction:column; gap:.55rem }` | 分类行原来与父卡片融为一体、行与行之间没有间距 |

### 第 2 轮:Kemou 的功能/内容反馈

| 文件 | 改动 |
| --- | --- |
| `src/config.ts` | 头像换为 `public/assets/images/kemou-avatar.jpg`(黑白手绘);`profileConfig.links` 新增 B站/GitHub/TG/邮箱;**删除导航栏 GitHub 链接**(与侧栏联系方式重复) |
| `src/components/widget/Profile.astro` | 联系方式图标按品牌色着色(`linkColors` 映射) |
| `src/components/LightDarkSwitch.svelte` | 明暗切换从 亮→暗→自动 三态循环改为**单击亮暗互换**;默认 AUTO 跟随系统,AUTO 时单击切到系统偏好的反面;三态菜单保留在悬停面板 |
| `src/components/Navbar.astro` | 右侧按钮组加 `gap-1.5 md:gap-2`(移动端太挤);**调色按钮改为单击循环预设色相**(35/78/165/220/250/305),桌面端悬停展开滑杆;通过 `window` 的 `hue-cycle` 自定义事件广播 |
| `src/components/widget/DisplaySettings.svelte` | 监听 `hue-cycle` 事件同步滑杆与数值 |
| `src/components/PostPage.astro` | 移动端文章卡从"融合长条+虚线分隔"改为**独立卡片 + gap-3** |
| `src/components/PostCard.astro` | 删除移动端卡片间虚线;字数/分钟改为**下沉读数窗**(`.post-facts`);描述加彩色侧线(`.post-desc`)并加大加黑(`text-[0.95rem] md:text-base text-black/80`) |
| `src/components/widget/Categories.astro` + `src/components/control/ButtonLink.astro` | 分类行 LED 灯按分类名散列取色(`--row-accent`,与文章卡灯条同一套逻辑),新增分类自动配色 |
| `src/components/PostMeta.astro` | 文章元信息里的标签从扁平文字改为**小键帽**(`.neu-mini-tag`) |
| `src/components/misc/License.astro` | 文章 URL 改为**点击复制**(document 级事件委托 + `__licenseCopyBound` 去重,Swup 换页后仍有效);CC 区链接悬停从扁平改为拟物凸起(`.neu-inline-link`) |
| `src/layouts/MainGridLayout.astro` | **页脚移到整页最底部**:放在 `#content-wrapper` 内 + `margin-top:auto`,容器 `min-height: calc(100vh - var(--main-panel-top) - 1rem)`。⚠️ 不要移到 `#main-grid` 后面——该网格的行高由左栏决定,主列内容是溢出的 |
| `src/styles/main.css` | 背景光斑从 7–12% 降到 2–5%;标签 `:active` 内阴影收敛到 2px、`:focus` 去默认 outline、`:focus-visible` 主色描边(修复深色模式点击标签后"被黑框罩住");新增 `.post-facts/.post-desc/.neu-mini-tag/.neu-inline-link` |

### 第 3 轮:去除"发光"(Kemou 强调:塑料只反光、不发光)

| 文件 | 改动 |
| --- | --- |
| `src/styles/variables.styl` | `--neu-highlight` 浅色从 0.88 降到 0.52,`--neu-highlight-strong` 从 0.98 降到 0.9 | 
| `src/styles/main.css` | 删除所有 `0 0 0 Npx` 形式的 LED 光晕环(文章卡灯条、分类灯、标签灯、读数窗灯、分页当前页);改为一律用 `inset 1px 1px 1px rgba(255,255,255,.4)` 内高光;`#banner-wrapper::after` 删除横幅底部白色内描边、泛白渐变 22%→12% |
| `src/components/HomeOverview.astro` | 删除面板底部的青色弥散光(`::after` blur);统计灯去光晕 |

**为什么:** 左上白色外阴影在纯色背景上是"环境光",但压在照片横幅上就会像卡片在发白光。Kemou 明确要求无发光效果。

## 三、已经验证过的事(不要重复劳动)

- ✅ `pnpm build` 成功(含 Pagefind 索引,**搜索是纯静态实现,不需要服务器**)
- ✅ 浅色/深色/移动端首页、文章页、归档页、关于页截图复查
- ✅ 交互实测:CC 链接点击复制写入剪贴板;明暗两态切换;调色单击循环色相并同步滑杆;移动端菜单/返回顶部正常
- ✅ 文章系统数据驱动:新文章/分类/标签/图片无需改组件

## 四、明确禁止(改之前先问 Kemou)

1. 不上传 GitHub、不部署线上、不动远程仓库和域名配置。
2. 不要把卡片改回半透明毛玻璃;不要给元素加外发光/halo;不要廉价霓虹。
3. 不要硬编码固定分类/板块的配色或布局;不要删 Fuwari 原有功能(搜索/RSS/归档/目录/分页/明暗/主题色/图片放大)。
4. 样式只用 `variables.styl` 里的 design tokens,不要在组件里自创颜色和阴影值。

## 五、如果 Kemou 让你接着改,先看这里

- 设计令牌、凹凸语义表、组件类名清单、踩坑细节 → `设计思路与注意事项.md`
- 验证截图方法:可用 Playwright 截图;注意 headless Chromium 视口底部有一个非 DOM 的覆盖层伪影,且页面是 vh 布局,整页截图要分段拼接(不能直接拉高视口)。
