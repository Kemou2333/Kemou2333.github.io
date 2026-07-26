$ErrorActionPreference = "Stop"

$blogRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $blogRoot

function Stop-WithMessage {
    param([string]$Message)
    Write-Host ""
    Write-Host $Message -ForegroundColor Red
    exit 1
}

Write-Host "Kemou 博客一键发布" -ForegroundColor Cyan
Write-Host "只会上传文章和文章图片，其他本地改动不会加入提交。"
Write-Host ""

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Stop-WithMessage "没有找到 Git，请联系 Codex 检查环境。"
}

if (-not (Get-Command pnpm.cmd -ErrorAction SilentlyContinue)) {
    Stop-WithMessage "没有找到 pnpm，请联系 Codex 检查环境。"
}

$branch = (& git branch --show-current).Trim()
if ($LASTEXITCODE -ne 0 -or $branch -ne "main") {
    Stop-WithMessage "当前不在 main 分支，为避免传错位置，本次发布已停止。"
}

Write-Host "[1/4] 检查 GitHub 上是否有更新..."
& git fetch origin main
if ($LASTEXITCODE -ne 0) {
    Stop-WithMessage "无法连接 GitHub，本次发布没有继续。"
}

$counts = (& git rev-list --left-right --count HEAD...origin/main).Trim() -split "\s+"
$behind = [int]$counts[1]
if ($behind -gt 0) {
    Stop-WithMessage "GitHub 上有更新尚未同步。请先让 Codex 帮你同步，再重新双击发布。"
}

$unexpectedStaged = @(
    & git diff --cached --name-only |
        Where-Object {
            $_ -notlike "src/content/posts/*" -and
            $_ -notlike "public/assets/images/*"
        }
)
if ($unexpectedStaged.Count -gt 0) {
    Stop-WithMessage "暂存区里有文章之外的改动。为避免误上传，请先让 Codex 检查。"
}

Write-Host "[2/4] 检查博客能否正常生成..."
& pnpm.cmd build
if ($LASTEXITCODE -ne 0) {
    Stop-WithMessage "博客构建失败，本次发布没有上传任何内容。"
}

Write-Host "[3/4] 整理本次文章和图片..."
& git add -- "src/content/posts" "public/assets/images"
if ($LASTEXITCODE -ne 0) {
    Stop-WithMessage "整理发布内容失败，本次发布没有继续。"
}

& git diff --cached --quiet
$hasNoContentChanges = $LASTEXITCODE -eq 0

if (-not $hasNoContentChanges) {
    $commitMessage = "publish blog content $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    & git commit -m $commitMessage
    if ($LASTEXITCODE -ne 0) {
        Stop-WithMessage "创建发布记录失败，本次发布没有继续。"
    }
}

Write-Host "[4/4] 上传到 GitHub Pages..."
& git push origin main
if ($LASTEXITCODE -ne 0) {
    Stop-WithMessage "上传失败。本地内容仍然安全，请稍后让 Codex 帮你检查。"
}

Write-Host ""
if ($hasNoContentChanges) {
    Write-Host "没有发现新的文章改动；已确认现有提交同步到 GitHub。" -ForegroundColor Yellow
} else {
    Write-Host "上传完成。GitHub Pages 通常会在一两分钟内更新。" -ForegroundColor Green
}

