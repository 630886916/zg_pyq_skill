# 给 AI Agent 的安装 / 升级说明

> 这个文件是给**执行安装的 AI Agent** 看的，不是给使用者看的。
> 使用者只会说一句「帮我装这个技能：<仓库地址>」，剩下由你完成。
> 目标：**装对、不碰其他技能、能报出版本**。

## 目标目录

| 平台 | 技能目录 |
|---|---|
| Windows（WorkBuddy 等） | `%USERPROFILE%\.workbuddy\skills\zg-pyq\` |
| macOS / Linux | `~/.workbuddy/skills/zg-pyq/` |
| Claude Code | `~/.claude/skills/zg-pyq/`（或项目内 `.claude/skills/zg-pyq/`） |
| Cursor / Codex / 其他 | 各自的 skills 目录，规则相同：**目录名必须是 `zg-pyq`** |

## 安装（也是升级）

1. 取仓库到临时目录：
   - 已 clone 过 → `git -C <临时目录> pull --ff-only`
   - 没有 → `git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git <临时目录>`
   - `git` 不可用 → 下载 `https://github.com/630886916/zg_pyq_skill/archive/refs/heads/main.zip` 并解压
2. 把仓库里的 `skills/zg-pyq/` **整个目录**复制到目标目录（同名覆盖）。
   升级时先清空目标目录再复制，避免旧文件残留。
3. 校验四项：
   - `SKILL.md` 存在，且 frontmatter 里是 `name: zg-pyq`
   - 顶部版本行含 `v2.1.0`
   - `references/08_转化文案类型库.md` 存在（v2.0 新增的核心能力库）
   - `更新说明.md` 首条是 `v2.1.0`
4. 回报：安装路径 + 版本号 + 四项校验结果。

## 硬性约束（请务必遵守）

- **只写上面那一个技能目录**，不要删除、移动、覆盖使用者的其他技能。
- **不要改目录名**：必须是 `zg-pyq`，与 `SKILL.md` 的 `name` 一致。
- **不要运行 `安装.bat`**（那是给人类双击用的，Agent 直接复制目录即可）。
- 仓库根目录的 `专家提示词.md`、`使用说明.md`、`更新说明.md`、`install.ps1` 等**不需要**复制进技能目录；
  技能目录只需要 `skills/zg-pyq/` 里的内容。
- 若目标机已有 v1.0 的中文目录 `skills\军工航空朋友圈营销文案\`，提示使用者手动删除，避免两个技能并存。
- 安装/升级完成后提醒使用者：**刷新或重启会话**才会加载新规则。

## 常见失败

| 现象 | 处理 |
|---|---|
| `CONNECT tunnel failed 502` / 连不上 github.com | 换网络或代理重试；仍不行则改用仓库 `dist/` 里的 zip 解压安装 |
| 目录里已有旧文件但版本没变 | 确认是「先清空再复制」，不是叠加复制 |
| 校验发现版本仍是旧的 | 检查是否复制到了缓存目录，或会话未刷新 |
