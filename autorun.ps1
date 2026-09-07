$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$batPath = Join-Path $scriptPath "start.bat"
$taskName = "ILoving"

# Remove old task if exists
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

# Create scheduled task to run at logon
$action = New-ScheduledTaskAction -Execute "wscript.exe" -Argument "`"$batPath`""
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Seconds 0) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "I Loving - Virtual girlfriend game" -Force

Write-Host "I Loving добавлен в автозагрузку!" -ForegroundColor Green
Write-Host "Теперь он будет запускаться при входе в Windows." -ForegroundColor Cyan
