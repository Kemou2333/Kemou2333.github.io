@echo off
chcp 65001 >nul
set "BLOG_ROOT=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%BLOG_ROOT%scripts\publish-blog.ps1"
echo.
pause
