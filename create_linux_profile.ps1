"Get-Module -ListAvailable PowerCLI* | Import-Module
. `"$HOME/WindowsPowerShell/Modules/zCore/init.ps1`"" | New-Item -Path ../.config/powershell -Name Microsoft.PowerShell_profile.ps1 -Force -Confirm:$false 2>&1 | Out-Null
exit; exit