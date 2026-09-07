$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$batPath = Join-Path $scriptPath "start.bat"

# Register in HKCU Run key (works without admin rights)
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$valueName = "ILoving"

Set-ItemProperty -Path $regPath -Name $valueName -Value "`"$batPath`"" -Force

Write-Host "I Loving добавлен в автозагрузку (HKCU\Run)!" -ForegroundColor Green
Write-Host "Игра будет запускаться при входе в Windows." -ForegroundColor Cyan
