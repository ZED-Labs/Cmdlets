Get-module -ListAvailable PowerCLI* | Import-module

$productName = "vSphere PowerCLI"
$productShortName = "PowerCLI"
$version = Get-PowerCLIVersion
$windowTitle = "VMware $productName {0}.{1}" -f $version.Major, $version.Minor
$host.ui.RawUI.WindowTitle = "$windowTitle"
$CustomInitScriptName = "Initialize-PowerCLIEnvironment_Custom.ps1"
$currentDir = Split-Path $MyInvocation.MyCommand.Path
$CustomInitScript = Join-Path $currentDir $CustomInitScriptName

#returns the version of Powershell
# Note: When using, make sure to surround Get-PSVersion with parentheses to force value comparison
function Get-PSVersion { 
    if (test-path variable:psversiontable) {
		$psversiontable.psversion
	} else {
		[version]"1.0.0.0"
	} 
}

# Update PowerCLI version after snap-in load
$version = Get-PowerCLIVersion
$windowTitle = "VMware $productName {0}.{1} Release 1" -f $version.Major, $version.Minor
$host.ui.RawUI.WindowTitle = "$windowTitle"


# Launch text
write-host "          Welcome to VMware $productName!"
write-host ""
write-host "Log in to a vCenter Server or ESX host:              " -NoNewLine
write-host "Connect-VIServer" -foregroundcolor yellow
write-host "To find out what commands are available, type:       " -NoNewLine
write-host "Get-VICommand" -foregroundcolor yellow
write-host "Once you've connected, display all virtual machines: " -NoNewLine
write-host "Get-VM" -foregroundcolor yellow
write-host ""
write-host "       Copyright (C) VMware, Inc. All rights reserved."
write-host ""
write-host ""

# Modify the prompt function to change the console prompt.
# Save the previous function, to allow restoring it back.
# THERE IS A POWERSHELL ISSUE WITH THIS AT THE MOMENT
#$originalPromptFunction = $function:prompt
#function global:prompt{

    # change prompt text
#    Write-Host "$productShortName " -NoNewLine -foregroundcolor Green
#    Write-Host ((Get-location).Path + ">") -NoNewLine
#    return " "
#}
