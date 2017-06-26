mkdir -p $HOME/.local 2>&1 | Out-Null
mkdir -p $HOME/.local/share 2>&1 | Out-Null
mkdir -p $HOME/.local/share/powershell 2>&1 | Out-Null
mkdir -p $HOME/.local/share/powershell/Modules 2>&1 | Out-Null
# unzip -n ./Include/PowerCLI.ViCore.zip -d $HOME/.local/share/powershell/Modules 2>&1 | Out-Null
# unzip -n ./Include/PowerCLI.Vds.zip -d $HOME/.local/share/powershell/Modules 2>&1 | Out-Null
# Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false 2>&1 | Out-Null

'If (Test-Path "$HOME/WindowsPowerShell/Modules/zCore/init.ps1"){. "$HOME/WindowsPowerShell/Modules/zCore/init.ps1"}' | New-Item -Path ../.config/powershell -Name Microsoft.PowerShell_profile.ps1 -Force -Confirm:$false 2>&1 | Out-Null

write-host "Cmdlets have been successfully install!`n"
Mods