# zg-pyq 技能 · Windows 一键安装 / 升级
#
# 用法（复制这一行到 PowerShell 回车）：
#   irm https://raw.githubusercontent.com/630886916/zg_pyq_skill/main/install.ps1 | iex
#
# 只安装 zg-pyq 这一个技能，不删除、不修改其他技能。
# 想装到别处：先设环境变量 ZG_PYQ_DIR，再执行上面的命令。

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch {}

$Repo   = '630886916/zg_pyq_skill'
$Branch = 'main'

if ($env:ZG_PYQ_DIR) { $Dest = $env:ZG_PYQ_DIR }
else { $Dest = Join-Path $env:USERPROFILE '.workbuddy\skills\zg-pyq' }

$Tmp = Join-Path $env:TEMP ('zg-pyq_' + [guid]::NewGuid().ToString('N'))

Write-Host ""
Write-Host "  zg-pyq · 朋友圈文案技能" -ForegroundColor Cyan
Write-Host "  ----------------------------------------" -ForegroundColor DarkGray

try {
    New-Item -ItemType Directory -Force -Path $Tmp | Out-Null
    $Zip = Join-Path $Tmp 'pkg.zip'

    if ($env:ZG_PYQ_URL) { $Url = $env:ZG_PYQ_URL }
    else { $Url = "https://github.com/$Repo/archive/refs/heads/$Branch.zip" }

    Write-Host "  [1/3] 下载 ..."
    Invoke-WebRequest -Uri $Url -OutFile $Zip -UseBasicParsing -TimeoutSec 180

    Write-Host "  [2/3] 解压 ..."
    Expand-Archive -Path $Zip -DestinationPath $Tmp -Force

    $Src = $null
    foreach ($d in (Get-ChildItem -Path $Tmp -Directory)) {
        $cand = Join-Path $d.FullName 'skills\zg-pyq'
        if (Test-Path (Join-Path $cand 'SKILL.md')) { $Src = $cand; break }
    }
    if (-not $Src) { throw '安装包里没有找到 skills\zg-pyq\SKILL.md' }

    Write-Host "  [3/3] 安装到 $Dest ..."
    $Parent = Split-Path $Dest -Parent
    if (-not (Test-Path $Parent)) { New-Item -ItemType Directory -Force -Path $Parent | Out-Null }

    # 只清理本技能目录，其他技能一律不碰
    if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    Copy-Item -Path (Join-Path $Src '*') -Destination $Dest -Recurse -Force

    # 校验
    $SkillMd = Join-Path $Dest 'SKILL.md'
    if (-not (Test-Path $SkillMd)) { throw '安装后缺少 SKILL.md' }
    $Head = (Get-Content -Path $SkillMd -TotalCount 15 -Encoding UTF8) -join "`n"
    if ($Head -notmatch 'name:\s*zg-pyq') { throw 'SKILL.md 的 name 不是 zg-pyq' }

    $Ver = ''
    $SkillHead = (Get-Content -Path $SkillMd -TotalCount 20 -Encoding UTF8) -join "`n"
    $vm = [regex]::Match($SkillHead, 'v(\d+\.\d+)')
    if ($vm.Success) { $Ver = $vm.Groups[1].Value }

    $RefDir = Join-Path $Dest 'references'
    $HasAntiFold = $false
    if (Test-Path $RefDir) {
        $HasAntiFold = @(Get-ChildItem -Path $RefDir -Filter '07_*').Count -gt 0
    }

    Write-Host ""
    Write-Host "  [OK] 安装完成" -ForegroundColor Green
    Write-Host "       目录：$Dest"
    if ($Ver) { Write-Host "       版本：v$Ver" }
    if ($HasAntiFold) { Write-Host "       防折叠模块：已包含" }
    else { Write-Host "       防折叠模块：未包含（可能下载到了旧版）" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "  下一步：刷新或重启会话，然后直接说 ——" -ForegroundColor Cyan
    Write-Host "       zg-pyq 给这张图配文" -ForegroundColor Yellow
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "  [X] 安装失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  换个办法（任选一个）：" -ForegroundColor Cyan
    Write-Host "   1. 下载 https://github.com/$Repo 里 dist 下的 zip，解压后双击 安装.bat"
    Write-Host "   2. 把这句话发给 Agent：帮我装这个技能 https://github.com/$Repo"
    Write-Host "   3. 检查网络 / 代理后重试本命令"
    Write-Host ""
}
finally {
    if ($Tmp -and (Test-Path $Tmp)) { Remove-Item -Recurse -Force $Tmp -ErrorAction SilentlyContinue }
}
