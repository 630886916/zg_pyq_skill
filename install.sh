#!/usr/bin/env bash
# zg-pyq 技能 · macOS / Linux 一键安装 / 升级
#
# 用法（复制这一行到终端回车）：
#   curl -fsSL https://raw.githubusercontent.com/630886916/zg_pyq_skill/main/install.sh | bash
#
# 只安装 zg-pyq 这一个技能，不删除、不修改其他技能。
# 想装到别处：ZG_PYQ_DIR=/your/path bash install.sh

set -euo pipefail

REPO="630886916/zg_pyq_skill"
BRANCH="main"
DEST="${ZG_PYQ_DIR:-$HOME/.workbuddy/skills/zg-pyq}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo ""
echo "  zg-pyq · 朋友圈文案技能"
echo "  ----------------------------------------"

SRC=""
if command -v git >/dev/null 2>&1; then
  echo "  [1/3] 下载 ..."
  if ! git clone --depth 1 "https://github.com/$REPO.git" "$TMP/repo" >/dev/null 2>&1; then
    echo "  [X] 下载失败：连不上 GitHub"
    echo "      换个办法：下载仓库 dist 下的 zip 解压，或把仓库地址发给 Agent 安装"
    exit 1
  fi
  SRC="$TMP/repo/skills/zg-pyq"
else
  echo "  [1/3] 下载（未装 git，改用 zip）..."
  if ! curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip" -o "$TMP/pkg.zip"; then
    echo "  [X] 下载失败：连不上 GitHub"
    exit 1
  fi
  echo "  [2/3] 解压 ..."
  unzip -q "$TMP/pkg.zip" -d "$TMP"
  SRC="$(find "$TMP" -maxdepth 3 -type d -path '*/skills/zg-pyq' | head -1)"
fi

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "  [X] 安装包里没有找到 skills/zg-pyq/SKILL.md"
  exit 1
fi

echo "  [3/3] 安装到 $DEST ..."
mkdir -p "$(dirname "$DEST")"
# 只清理本技能目录，其他技能一律不碰
rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC"/. "$DEST"/

if ! grep -q 'name: zg-pyq' "$DEST/SKILL.md"; then
  echo "  [X] 校验失败：SKILL.md 的 name 不是 zg-pyq"
  exit 1
fi

VER="$(grep -o '版本：v[0-9]*\.[0-9]*' "$DEST/专家提示词.md" 2>/dev/null | head -1 | sed 's/.*v//' || true)"

echo ""
echo "  [OK] 安装完成"
echo "       目录：$DEST"
if [ -n "${VER:-}" ]; then echo "       版本：v$VER"; fi
if [ -f "$DEST/references/07_朋友圈防折叠设计.md" ]; then
  echo "       防折叠模块：已包含"
else
  echo "       防折叠模块：未包含（可能下载到了旧版）"
fi
echo ""
echo "  下一步：刷新或重启会话，然后直接说 ——"
echo "       zg-pyq 给这张图配文"
echo ""
