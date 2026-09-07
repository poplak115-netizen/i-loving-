# I Loving - Deploy to GitHub Pages
# Usage:
#   powershell -ExecutionPolicy Bypass -File deploy.ps1 <your_github_username>

param(
    [Parameter(Mandatory = $true)]
    [string]$Username
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "  [I Loving] Deploy to GitHub Pages..." -ForegroundColor Magenta
Write-Host "  =====================================" -ForegroundColor DarkGray
Write-Host ""

# 1. Login
Write-Host "  [1/5] Checking GitHub auth..." -ForegroundColor Cyan
$whoami = gh api user 2>$null | ConvertFrom-Json
if (-not $whoami.login) {
    Write-Host "  Auth required. Browser will open - sign in to github.com" -ForegroundColor Yellow
    gh auth login --web --git-protocol https
    $whoami = gh api user | ConvertFrom-Json
}
Write-Host "  [OK] Logged in as: $($whoami.login)" -ForegroundColor Green

if ($Username -ne $whoami.login) {
    Write-Host "  NOTE: your GitHub username is: $($whoami.login)" -ForegroundColor Yellow
}

# 2. Set git identity
git config user.name $whoami.login
git config user.email "$($whoami.login)@users.noreply.github.com"
git remote remove origin 2>$null

# 3. Create repo
Write-Host "  [2/5] Creating repository..." -ForegroundColor Cyan
try {
    gh repo create "$($whoami.login)/iloving" --public --source $scriptDir --push
} catch {
    Write-Host "  Repo exists, pushing..." -ForegroundColor Yellow
    git remote add origin "https://github.com/$($whoami.login)/iloving.git"
    git push -u origin master
}

# 4. Enable GitHub Pages
Write-Host "  [3/5] Enabling GitHub Pages..." -ForegroundColor Cyan
Start-Sleep -Seconds 2
try {
    gh api "repos/$($whoami.login)/iloving/pages" -X POST -f "source[branch]=master" -f "source[path]=/" | Out-Null
} catch {
    gh api "repos/$($whoami.login)/iloving/pages" -X PUT -f "source[branch]=master" -f "source[path]=/" | Out-Null
}

# 5. Show URL
$url = "https://$($whoami.login).github.io/iloving/"
Write-Host ""
Write-Host "  [DONE] Your game is live at: $url" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor Magenta
Write-Host "  1. Open https://discord.com/developers/applications"
Write-Host "  2. Create 'I Loving' application"
Write-Host "  3. In Activity section paste the URL: $url"
Write-Host "  4. Join a voice channel in Discord -> Activities -> I Loving"
Write-Host ""

# Save URL for next step
$url | Out-File "$scriptDir\.deploy_url" -NoNewline