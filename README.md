# zg_pyq · 军工航空私域朋友圈文案技能

> **当前版本 v1.3**（2026-11-10）｜ **本次有更新**：新增**朋友圈防折叠设计** —— 适合的内容出稿即写成
> 首句自足、篇幅受控、去营销腔的形态；信息交付型长文明确不做；只做内容／排版层优化，不做符号规避。
> 完整版本记录见 [更新说明.md](更新说明.md)；**已经装过旧版的，看下方「升级到最新版本」**。

> **English** — A portable skill for writing WeChat *Moments* (private-domain) copy from a single image, video frames, multiple screenshots, payment screenshots, or just a one-line brief. It bundles a defined expert persona, material-parsing rules, compliance guardrails, an adaptive output spec, a fill-in input template and worked examples. Use it as a `SKILL.md` skill, or copy `专家提示词.md` as a standalone system prompt. **Current version: v1.3** — adds anti-fold copy design (content/layout optimisation only, no detection-evasion tricks).

一个面向 **微信朋友圈（私域触达、配图/视频配文、轻量互动）** 的文案技能包。
给定素材或一句需求，输出若干条**可直接复制发布**的候选文案，并附上本次判定、合规自检与需人工确认事项。

技能面向的行业场景是「退伍军人就业 / 航空军工厂 / 央国企招录」，专家人设为**招录政策顾问**（稳重可信 + 活人感，只讲公开可查的信息）。其他行业可按 `skills/zg_pyq/专家提示词.md` 里的参数自行调整。

---

## 它能做什么

| 输入 | 输出 |
|---|---|
| 单张图片 | 3 条 / 30–80 字，含 1 条更短的互动向 |
| 视频或视频截帧 | 2–3 条 / 40–100 字 |
| 只有一句话、没有素材 | 3 条 / 30–80 字，三个不同角度 |
| 多图 / 聊天截图 | 2 条 / 30–70 字 + 强制打码提示 |
| 成交金额截图 | 按业务规则判定「定金位 / 全款位」后出稿，默认不写金额数字 |

条数与字数**按素材和场景自适应**（16 行决策表），单次输入可覆盖。

除日常配文的顾问口吻外，还支持**专家／官方视角**：第三人称或去人称、资讯密度高、结构感强，
按素材自动路由到 6 类产出（价值凝练、政策解读、岗位通告、人物纪实、节点关联、服务逻辑说明）。
判定信号与结构规则见 `skills/zg_pyq/references/06_专家官方视角类型库.md`。

**v1.3 · 朋友圈防折叠设计**：适合的短文案（日常配文、单图／视频配文、轻互动、节点、P1／P5、
中短的 P2／P6）**出稿即写成防折叠形态**——首句自足、篇幅受控、自然分段、去营销腔、候选首句信息点不同；
`P3` 岗位通告、`P4` 人物纪实等**信息交付型长文明确不做**，保持完整清单并写明「未优化（原因）」。
依据来自官方《微信个人账号使用规范》（2026-10-15 更新生效）、腾讯客服朋友圈规范与 2025-05-31 折叠回应；
**官方未公布字数阈值**，第三方流传的 6 行 / 99 / 100 / 120 / 200 字互相矛盾，故不写死。
只做内容与排版优化，**禁用零宽字符、特殊符号、防折叠码与第三方工具，也不承诺「保证不折叠」**。
详见 `skills/zg_pyq/references/07_朋友圈防折叠设计.md`。

---

## 快速开始

### 1. 安装（任选一种）

> 技能本质就是一个含 `SKILL.md` 的目录 —— 把 `skills/zg_pyq/` 放进 `~/.workbuddy/skills/zg_pyq/` 即完成安装。
> WorkBuddy 官方的「一句话安装技能」入口只覆盖**技能市场已收录的技能**，**不支持直接输入 GitHub 地址**；
> 但 Agent 能操作本地文件，所以下面的**方式 B** 可以让它自己完成远程安装，效果等同一键安装。

**方式 A · 下载压缩包 + 双击安装（Windows，零依赖）**

完整解压 `dist/zg_pyq_技能包_20261110.zip` → 双击 `安装.bat`。
脚本会把 `skills/zg_pyq/` 复制到 `%USERPROFILE%\.workbuddy\skills\zg_pyq\`，不改动其他技能、不需要管理员权限、不需要 Python 或 ffmpeg。

> `安装.bat` 为 **GBK 编码**（中文 Windows cmd 直接可运行）。用编辑器查看时请按 GBK 打开，勿转成 UTF-8。

**方式 B · 一句话让 Agent 从 GitHub 远程安装（推荐）**

把下面整段发给 WorkBuddy 或任何能操作本地文件的 Agent：

```
请帮我安装这个技能：https://github.com/630886916/zg_pyq_skill

1. 把仓库克隆到临时目录：git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git
2. 把仓库里的 skills/zg_pyq/ 整个文件夹复制到我的技能目录
   ~/.workbuddy/skills/zg_pyq/（Windows：%USERPROFILE%\.workbuddy\skills\zg_pyq\）。
3. 校验：SKILL.md 存在、frontmatter 里 name: zg_pyq，且 references/、templates/、专家提示词.md 都在。
4. 告诉我安装结果。不要改动我已有的其他技能，也不要运行 安装.bat。
```

装完刷新会话，说触发词即可。Claude Code / Cursor 等同样适用，把目标目录换成各自的 skills 目录即可。

**方式 C · 手动命令**

```powershell
# Windows PowerShell
git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git "$env:TEMP\zg_pyq_skill"
New-Item -ItemType Directory -Force "$env:USERPROFILE\.workbuddy\skills" | Out-Null
Copy-Item -Recurse -Force "$env:TEMP\zg_pyq_skill\skills\zg_pyq" "$env:USERPROFILE\.workbuddy\skills\zg_pyq"
```

```bash
# macOS / Linux / Git Bash
git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git /tmp/zg_pyq_skill
mkdir -p ~/.workbuddy/skills
cp -r /tmp/zg_pyq_skill/skills/zg_pyq ~/.workbuddy/skills/
```

**安装后自检**：`SKILL.md` 存在且 frontmatter 为 `name: zg_pyq`；`references/`、`templates/`、`专家提示词.md` 齐全；
刷新会话后说「zg_pyq，给这张图配文」能触发。目录名保持 `zg_pyq`，**不要改成中文**。
以上三种方式都只写技能目录，**不动其他技能、不写共享目录、不需要管理员权限**。

**只想用提示词、不想装技能**：直接把仓库根目录的 `专家提示词.md` 整份复制成 system prompt 即可独立工作，不依赖本仓库其他文件。

### 2. 触发

在对话里说以下任一句：

```
zg_pyq，给这张图配文
用军工朋友圈文案技能，给这张图配文
帮我发条朋友圈
金额截图配文
```

完整触发词见 `skills/zg_pyq/SKILL.md` 的 frontmatter。

### 3. 最小输入

只给一张图：

```
【素材】：（把图片拖进对话）
【需求】：配一条日常朋友圈
```

只给一句话、没有任何素材：

```
【需求】：招录季快到了，想发一条提醒性质的朋友圈
```

完整填空模板见 `skills/zg_pyq/templates/输入占位模板.md`，**所有占位都可留空**。

### 4. 输出长什么样

```
【文案 1｜现场感｜约 46 字】
今天在车间站了会儿，看几个战友跟着师傅走装配流程。这行不靠嘴，靠手上的活儿慢慢熬。
适用：单图直发，最贴画面，稳重但不端着。

【文案 2｜答疑向｜约 60 字】
常有家长问，进航空制造岗到底干什么。多数人是从装配、质检这些基础工序起步，门槛写的是大专及以上。剩下的，看能不能沉住气。
适用：想顺带做一次轻答疑，不承诺任何结果。

【本次判定】
素材类型＝单张图片（现场照）；产出类型＝默认；视角档位＝顾问；场景＝日常配图；发布对象＝混合；
条数与字数＝3 条 / 30–80 字（决策表 #1）；本次按默认：…；
防折叠＝已优化（首句自足 / 篇幅受控 / 去营销腔 / 候选首句信息点不同）；
发布节奏＝三条建议错峰发，避免同一时段连发高度相似内容。
【合规自检】
硬红线：通过｜基线：通过｜类型改写项：通过
防折叠边界：仅内容/排版层，未使用符号规避或第三方工具
【需人工确认】
画面中设备铭牌不可辨；若原图含单位名或内部编号，请打码后再发。
```

正文不带引号、标题、markdown、emoji、话题标签，复制即发。四个小节不可省，后三个是质检凭证。

更多完整示例见 `skills/zg_pyq/references/05_示例库.md`（单图、一句话、视频截帧、聊天截图、定金位、全款位、敏感画面拦截、政策解读与岗位通告的专家／官向示例，以及防折叠「适合 / 不适合」示例 11–12）。

---

## 升级到最新版本（已装过旧版必看）

技能是**本地目录，不会自动更新**。仓库更新后，已安装的同事需要把
`~/.workbuddy/skills/zg_pyq/` 覆盖成最新版。三种方式任选一种，**都只覆盖这一个技能，不动其他技能**。

### 方式 1 · 一句话让 Agent 更新（推荐）

把下面整段发给 WorkBuddy 或任何能操作本地文件的 Agent：

```
请把已安装的 zg_pyq 技能更新到最新版本：https://github.com/630886916/zg_pyq_skill

1. 取仓库最新内容：临时目录里已有该仓库的 clone 就执行 git pull --ff-only，
   没有就 git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git 到临时目录。
2. 用仓库里的 skills/zg_pyq/ 整个覆盖我的技能目录
   ~/.workbuddy/skills/zg_pyq/（Windows：%USERPROFILE%\.workbuddy\skills\zg_pyq\）。
3. 校验并告诉我结果：SKILL.md 的 frontmatter 仍为 name: zg_pyq、顶部版本为 v1.3、
   references/07_朋友圈防折叠设计.md 存在、更新说明.md 首条是 v1.3。
4. 不要删除或改动我已有的其他技能，不要运行 安装.bat，不要改目录名。
```

### 方式 2 · 手动命令覆盖

```powershell
# Windows PowerShell
$p = "$env:TEMP\zg_pyq_skill"
if (Test-Path "$p\.git") { git -C $p pull --ff-only } else { git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git $p }
New-Item -ItemType Directory -Force "$env:USERPROFILE\.workbuddy\skills\zg_pyq" | Out-Null
Copy-Item -Recurse -Force "$p\skills\zg_pyq\*" "$env:USERPROFILE\.workbuddy\skills\zg_pyq\"
```

```bash
# macOS / Linux / Git Bash
P=/tmp/zg_pyq_skill
if [ -d "$P/.git" ]; then git -C "$P" pull --ff-only; else git clone --depth 1 https://github.com/630886916/zg_pyq_skill.git "$P"; fi
mkdir -p ~/.workbuddy/skills/zg_pyq
cp -r "$P"/skills/zg_pyq/. ~/.workbuddy/skills/zg_pyq/
```

### 方式 3 · 重新下载 zip 覆盖

下载 `dist/zg_pyq_技能包_20261110.zip` → 完整解压 → 双击 `安装.bat`。
脚本检测到已安装会提示「本次将覆盖更新」，覆盖同名技能，不影响其他技能。

### 版本核对

| 检查项 | 最新版应为 |
|---|---|
| `skills/zg_pyq/专家提示词.md` 顶部 | `版本：v1.3` |
| `skills/zg_pyq/SKILL.md` 顶部 | `版本 v1.3：新增朋友圈防折叠设计` |
| `skills/zg_pyq/references/` | 存在 `07_朋友圈防折叠设计.md` |
| `更新说明.md` 首条 | `v1.3 · 2026-11-10 · 新增朋友圈防折叠设计` |

> **升级后刷新 / 重启会话**，否则内存里仍是旧规则。
> 若还残留 v1.0 的中文目录 `skills\军工航空朋友圈文案\`，先手动删掉，避免两个技能并存。

---

## 规则一览

| 维度 | 要点 |
|---|---|
| **人设** | 招录政策顾问；第一人称「我」、称呼「战友/家长」；不署名、不编造姓名/年限/单位/履历/客户数量 |
| **调性** | 稳重可信 **+ 活人感**：具体细节、口语短句、长短交错、结尾留白；**活人感 ≠ 网红腔**（禁家人们/速看/炸了、标题党、堆 emoji、制造焦虑） |
| **硬红线** | 禁涉密与未公开信息，**不可关闭**：不复述画面里的型号参数、内部编号、厂区布局、人员姓名、内部文件与未公开招录计划；拿不准 = 不写 |
| **默认克制基线** | 不承诺结果（含谐音变体）、不引导至风险不可控渠道、不编造事实、不蹭时政军事热点；`BASELINE_STRICT=true`，可关闭 |
| **素材解析** | 五类素材逐一给解析步骤；截图强制脱敏提示；无素材时禁止虚构具体经历 |
| **视角档位** | 顾问（默认，活人感）／专家（第三人称解读）／官方（去人称通告）；6 类产出类型按素材自动路由，单次可覆盖 |
| **防折叠（v1.3）** | `ANTI_FOLD=auto`：适合的内容出稿即首句自足／篇幅受控／去营销腔；`P3`／`P4` 等信息交付型明确不做并写明原因。**只做内容／排版层**，禁用零宽字符、特殊符号、防折叠工具，不承诺「保证不折叠」 |
| **输出** | 固定四小节 + **16 行**自适应决策表；单次可覆盖条数与字数；防折叠只加判定／自检两行，不新增小节 |
| **金额截图** | 单张 <5 万且合计 <5 万 → 定金位；合计 ≥5 万 → 全款位；显式标注可覆盖；默认不写数字。详见 `references/03_素材解析规则.md` |

### 常用参数

| 参数 | 默认 | 说明 |
|---|---|---|
| `PERSONA_NAME` | `""` | 署名，默认不署名 |
| `AUDIENCE` | 混合 | 战友 / 家长 / 混合 |
| `TONE_LIVELY` | 0.6 | 活人感强度 0~1 |
| `VOICE` / `OUTPUT_TYPE` | `auto` | 视角档位 / P1–P6 产出类型，按素材自动路由 |
| `ANTI_FOLD` | `auto` | auto / on / off；适合即优化、不适合写明原因不做；**不做符号规避** |
| `CANDIDATES` / `LENGTH` | `auto` | 条数 / 字数区间，走决策表 |
| `BASELINE_STRICT` | `true` | 默认克制基线开关 |
| `SHOW_AMOUNT` | `false` | false / blur / exact |
| `DEPOSIT_THRESHOLD` | `50000` | 定金位/全款位分界（元） |
| `ALLOW_DEPOSIT_WORD` | `false` | 是否允许「定金」二字 |
| `DISCLAIMER` | `auto` | none / auto / always |
| `HARD_REDLINE` | 涉密与未公开信息 | **常量，不可关闭** |

完整参数表与覆盖写法见 `references/04_输出规范与自适应参数.md`。

---

## 目录结构

```
zg_pyq_skill/
├── README.md                       本文件（使用方法）
├── LICENSE                         MIT
├── 专家提示词.md                    可直接整份粘贴的独立提示词
├── 使用说明.md                      安装、输入、输出、合规、维护
├── 更新说明.md                      版本与规则来源
├── 安装.bat                        Windows 一键安装（GBK）
├── dist/
│   └── zg_pyq_技能包_20261110.zip   可直接下载分发的完整包
└── skills/zg_pyq/
    ├── SKILL.md                    技能入口（触发词 / 工作流 / 速查）
    ├── 专家提示词.md                ★ 唯一权威规则源
    ├── references/
    │   ├── 01_人设与调性.md
    │   ├── 02_合规红线与脱敏.md
    │   ├── 03_素材解析规则.md
    │   ├── 04_输出规范与自适应参数.md
    │   ├── 05_示例库.md
    │   ├── 06_专家官方视角类型库.md
    │   └── 07_朋友圈防折叠设计.md    v1.3 能力知识库（官方依据 / 适合判定 / 禁做清单）
    └── templates/
        ├── 输入占位模板.md
        └── 输出模板.md
```

## 维护规则

`skills/zg_pyq/专家提示词.md` 是**唯一权威源**；`SKILL.md` 负责触发与调度，`references/` 只做展开说明。
改规则的顺序：权威源 → `SKILL.md` 速查表 → `references/` → 在 `05_示例库.md` 补一个完整示例 → 更新 `更新说明.md` 版本号 → 重新打包 `dist/` 里的 zip → 同步 README 的「当前版本」与「升级到最新版本」核对项。
仓库根目录的 `专家提示词.md` 是权威源的字节级副本，**不要单独手改**。
平台折叠规则会变，但 `07_朋友圈防折叠设计.md` 里的**合规边界（禁符号规避 / 禁第三方工具 / 不承诺结果）不得随规则变动放宽**。

技能 ID 为 `zg_pyq`：目录名必须与 `SKILL.md` frontmatter 的 `name: zg_pyq` 一致，改名时两处一起改。

## 适用范围与注意

- 本技能面向特定行业场景编写，人设、话术尺度与合规边界都是为该场景定的；用于其他行业前请先通读 `专家提示词.md` 并调参。
- 技能**不改图**。截图里的姓名、头像、账号、订单号、单位名、铭牌、看板等，需由发布者自行打码；技能只负责不把这些写进文案并给出提示。
- 只处理微信朋友圈语境；抖音标题、简介、话题标签、评论区话术不在范围内。
- 合规自检由模型执行，**发布责任在人**。

## License

MIT — 见 [LICENSE](LICENSE)。
