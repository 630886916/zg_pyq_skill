@echo off
setlocal
chcp 936 >nul 2>&1
title zg_pyq · 技能安装

set "SRC=%~dp0skills\zg_pyq"
set "DST=%USERPROFILE%\.workbuddy\skills\zg_pyq"

echo.
echo   zg_pyq · 军工航空朋友圈文案 技能包 v1.2
echo   ----------------------------------------

if not exist "%SRC%\SKILL.md" (
  echo   [X] 未找到 SKILL.md，请先完整解压 zip 后再运行本文件。
  echo.
  pause
  exit /b 1
)

if exist "%DST%\SKILL.md" (
  echo   [i] 检测到已安装，本次将覆盖更新，不影响其他技能。
) else (
  echo   [i] 首次安装。
)

if not exist "%USERPROFILE%\.workbuddy\skills" mkdir "%USERPROFILE%\.workbuddy\skills" 2>nul
xcopy /E /I /Y "%SRC%\*" "%DST%\" >nul 2>&1
if errorlevel 1 (
  echo   [X] 复制失败，请手动把 skills\zg_pyq 整个文件夹复制到：
  echo       %USERPROFILE%\.workbuddy\skills\
  echo.
  pause
  exit /b 1
)

echo   [√] 安装完成：%DST%
echo.
echo   用法：在 WorkBuddy 里说「zg_pyq，给这张图配文」或「用军工朋友圈文案技能，给这张图配文」
echo   本技能不需要 Python / ffmpeg / 联网，也不需要环境检查。
echo   详细说明见同目录 使用说明.md
echo.
pause
