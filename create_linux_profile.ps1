"Get-Module -ListAvailable PowerCLI* | Import-Module
. `"$HOME/WindowsPowerShell/Modules/zCore/init.ps1`"" | New-Item -Path ../.config/powershell -Name Microsoft.PowerShell_profile.ps1 -Force -Confirm:$false 2>&1 | Out-Null
#mkdir $CD/.local > /dev/null
#mkdir $HOME/.local/share > /dev/null
#mkdir $HOME/.local/share/powershell > /dev/null
#mkdir $HOME/.local/share/powershell/Modules > /dev/null
unzip ./Include/PowerCLI.ViCore.zip -d $HOME/.local/share/powershell/Modules > /dev/null
unzip ./Include/PowerCLI.Vds.zip -d $HOME/.local/share/powershell/Modules > /dev/null
powershell -Command "Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:\$false"
exit; exit