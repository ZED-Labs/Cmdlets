Function Common([string]$Name){
    Get-Command -Module Common | Where {$_.Name -like "*$Name*"}
}
Function CheckPreReq([string]$FriendlyName,[string]$ModuleName,[string]$StdModulePath,[string]$InstallCommand,$Confirm){
    <#
    .SYNOPSIS
    Validates that a PowerShell module is installed and loaded.
    .DESCRIPTION
    Validates that a PowerShell module is installed and loaded.
    If module is installed, but missing due to being installed within a directory not listed within the PSModulePath system variable, the directory will be added to the PSModulePath system variable.
    If module is installed, but not loaded, the module will be loaded.
    If module is not installed, will be installed using $InstallCommand.  Default behavior to is to prompt for confirmation before installing.
    If module not installed, will be installed using $InstallCommand.  If $Confirm is set to $false, install will proceed without user interaction.
    If $FriendlyName is set to one of the below strings, then $ModuleName, $StdModulePath, and $InstallCommand can be ommitted and will be populated according to standard.
    
        Cisco-IMC
        Cisco-Central
        Cisco-Manager
        EMC-SI
        HP-BIOS
        HP-iLO
        HP-OS
        MS-AD
        MS-SQL
        VM-PCLI
        VM-VUM
    .EXAMPLE
    CheckPreReq -FriendlyName "Cisco-Central"
    .EXAMPLE
    CheckPreReq -FriendlyName "MS-AD"
    .EXAMPLE
    CheckPreReq -FriendlyName "MS-SQL"
    .EXAMPLE
    CheckPreReq -FriendlyName "VMware PowerCLI" -ModuleName "VMware.VimAutomation.Core" -InstallCommand "cmd /c start /wait $repo\software\VMware-PowerCLI-6.0.0-3205540.exe /S /V`"/qn`""
    or, using a standard FriendlyName
    CheckPreReq -FriendlyName "VM-PCLI"
    .PARAMETER FriendlyName
    If $FriendlyName is set to one of the below strings, then $ModuleName, $StdModulePath, and $InstallCommand can be ommitted.  These variable will be automatically populated according to standard.
        Cisco-IMC
        Cisco-Central
        Cisco-Manager
        EMC-SI
        HP-BIOS
        HP-iLO
        HP-OS
        MS-AD
        MS-SQL
        VM-PCLI
        VM-VUM
    $FriendlyName can also be used when testing for custom modules.
    .PARAMETER ModuleName
    Not required if using a standard $FriendlyName.
    If testing for custom module, this should be the module name listed using the "Get-Module -ListAvailable" or "Get-PSSnapin -Registered" commands.
    .PARAMETER StdModulePath
    Not required if using a standard $FriendlyName.
    If testing for custom module, this should be the folder path to the module.  This is also not required if the path already exists within the $PSModulePath system variable.  If provided, but missing from $PSModulePath, it will be added.
    .PARAMETER InstallCommand
    Not required if using a standard $FriendlyName.
    If testing for custom module, this should be the silent automated setup command.  The Invoke-Expression command is used to launch setup, and can be used to prevalidate syntax prior to use.
    .PARAMETER Confirm
    If $Confirm is set to $false, install will proceed without user interaction.
    Default behavior: console will prompt for confirmation before any installations.
    #>
    if ($IsLinux){write-host "`nWindows only. (for now)`n"; return}
    if (! $FriendlyName){
        write-host "`nPlease specify at least " -NoNewLine; write-host "-FriendlyName`n" -ForegroundColor Cyan
        write-host "    Cisco-Central" -ForegroundColor DarkGreen
        write-host "    Cisco-IMC" -ForegroundColor DarkGreen
        write-host "    Cisco-Manager" -ForegroundColor DarkGreen
        write-host "    EMC-SI" -ForegroundColor DarkGreen
        write-host "    HP-BIOS" -ForegroundColor DarkGreen
        write-host "    HP-ILO" -ForegroundColor DarkGreen
        write-host "    HP-OA" -ForegroundColor DarkGreen
        write-host "    MS-AD" -ForegroundColor DarkGreen
        write-host "    MS-SQL" -ForegroundColor DarkGreen
        write-host "    MySQL" -ForegroundColor DarkGreen
        write-host "    PS-5" -ForegroundColor DarkGreen
        write-host "    VM-PCLI" -ForegroundColor DarkGreen
        write-host "    VM-VUM" -ForegroundColor DarkGreen
        "";return
    }
    $script:ProgressPreference = "SilentlyContinue"
    $repo = "\\cc-clvi51\cmdlet$"
    if ($FriendlyName -eq "Cisco-IMC"){$FriendlyName = "Cisco IMC PowerTool"; $ModuleName = "CiscoImcPS"; $StdModulePath = "C:\Program Files (x86)\Cisco\Cisco IMC PowerTool\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\CiscoIMC-PowerTool-1.4.2.0.exe /S /v/qn"	}
    if ($FriendlyName -eq "Cisco-Central"){$FriendlyName = "Cisco UCS Central PowerTool"; $ModuleName = "CiscoUcsCentralPS"; $StdModulePath = "C:\Program Files (x86)\Cisco\Cisco UCS Central PowerTool\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\CiscoUcsCentral-PowerTool-1.0.1.0.exe /S /v/qn"}
    if ($FriendlyName -eq "Cisco-Manager"){$FriendlyName = "Cisco UCS Manager PowerTool"; $ModuleName = "CiscoUcsPS"; $StdModulePath = "C:\Program Files (x86)\Cisco\Cisco UCS Manager PowerTool\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\CiscoUcs-ManagerPowerTool-1.5.3.0.exe /S /v/qn"}
    if ($FriendlyName -eq "EMC-SI"){$FriendlyName = "EMC Storage Integrator"; $ModuleName = "ESIPSToolKit"; $StdModulePath = "C:\Program Files\EMC\EMC Storage Integrator"; $InstallCommand = "cmd /c start /wait $repo\software\ESI.3.9.0.62.Setup.msi /qn"}
    if ($FriendlyName -eq "HP-BIOS"){$FriendlyName = "HP BIOS Cmdlets"; $ModuleName = "HPBIOSCmdlets"; $StdModulePath = "C:\Program Files\Hewlett-Packard\PowerShell\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\HPBIOSCmdlets-x64.msi /qn"}
    if ($FriendlyName -eq "HP-iLO"){$FriendlyName = "HP iLO Cmdlets"; $ModuleName = "HPiLOCmdlets"; $StdModulePath = "C:\Program Files\Hewlett-Packard\PowerShell\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\HPiLOCmdlets-x64.msi /qn"}
    if ($FriendlyName -eq "HP-OA"){$FriendlyName = "HP OA Cmdlets"; $ModuleName = "HPOACmdlets"; $StdModulePath = "C:\Program Files\Hewlett-Packard\PowerShell\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\HPOACmdlets-x64.msi /qn"}
    if ($FriendlyName -eq "MS-AD"){$FriendlyName = "Microsoft Active Directory"; $ModuleName = "ActiveDirectory"; $InstallCommand = "dism /online /enable-feature /featurename:RSATClient-Roles-AD-Powershell"}
    if ($FriendlyName -eq "MS-SQL"){$FriendlyName = "Microsoft SQL Cmdlets"; $ModuleName = "SQLASCMDLETS"; $StdModulePath = "C:\Program Files (x86)\Microsoft SQL Server\120\Tools\PowerShell\Modules"; $InstallCommand = "$repo\software\sql\setup /q /ACTION=Install /IAcceptSQLServerLicenseTerms /UpdateEnabled=0 /ErrorReporting=0 /FEATURES=SSMS"}
    if ($FriendlyName -eq "VM-PCLI"){$FriendlyName = "VMware PowerCLI"; $ModuleName = "VMware.VimAutomation.Core"; $InstallCommand = "cmd /c start /wait $repo\software\VMware-PowerCLI-6.0.0-3205540.exe /S /V`"/qn`""}
    if ($FriendlyName -eq "VM-VUM"){$FriendlyName = "VMware UpdateManagerCLI"; $ModuleName = "VMware.VumAutomation"; $StdModulePath = "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Modules"; $InstallCommand = "cmd /c start /wait $repo\software\VMware-UpdateManager-Pscli-6.0.0-2503190.exe /S /V`"/qn`""}
    if ($FriendlyName -eq "MySQL"){
        $FriendlyName = "MySQL Connector"
        $ModuleName = "Software"
        $Install = "$repo\software\mysql-connector-net-6.9.9.msi"
        $Parameters = "/qn"
    }
    if ($FriendlyName -eq "PS-5"){
        if ($PSVersionTable.PSVersion.Major -lt 5){
            $script:WindowsVer = (Get-WmiObject -class Win32_OperatingSystem).Caption
            if ($confirm -ne $false -And $InstallAll -ne "Yes"){
                    write-host "    Powershell v5 is " -NoNewLine; write-host "not installed" -ForegroundColor Cyan -NoNewLine; Write-host ".  Install now? " -NoNewLine; $Response = Read-Host "[Yes/No/All]"
                    if (! $Response){write-host "`nNo response given.  Script will not exit.`n" -ForegroundColor Red; exit}
                    if ($Response -eq "All" -Or $Response -eq "A"){$script:InstallAll = "Yes"}
                    if ($Response -eq "Yes" -Or $Response -eq "Y" -Or $script:InstallAll -eq "Yes"){
                        if ($WindowsVer -like "*Server 2012*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\W2K12-KB3066438-x64.msu /quiet /norestart"}
                        if ($WindowsVer -like "*Windows 7*" -Or $WindowsVer -like "*Server 2008 R2*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\Win7AndW2K8R2-KB3066439-x64.msu /quiet /norestart"}
                        if ($WindowsVer -like "*Windows 8*" -Or $WindowsVer -like "*Server 2012 R2*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\Win8.1AndW2K12R2-KB3066437-x64.msu /quiet /norestart"}
                        if ($WindowsVer){
                            write-host "      Installing Powershell v5...`n      $InstallCommand"
                            Invoke-Expression $InstallCommand 2>&1 | out-null
                        }else{
                            write-host "      No version available for $WindowsVer."
                            return
                        }
                        
                        
                    } else {return}
            }else{
                if ($WindowsVer -like "*Server 2012*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\W2K12-KB3066438-x64.msu /quiet /norestart"}
                if ($WindowsVer -like "*Windows 7*" -Or $WindowsVer -like "*Server 2008 R2*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\Win7AndW2K8R2-KB3066439-x64.msu /quiet /norestart"}
                if ($WindowsVer -like "*Windows 8*" -Or $WindowsVer -like "*Server 2012 R2*"){$InstallCommand = "cmd /c start /wait wusa.exe $repo\software\Win8.1AndW2K12R2-KB3066437-x64.msu /quiet /norestart"}
                if ($WindowsVer){
                    write-host "      Installing Powershell v5...`n      $InstallCommand"
                    Invoke-Expression $InstallCommand 2>&1 | out-null
                }else{
                    write-host "      No version available for $WindowsVer."
                    return
                }
            }
        } else {write-host "    Powershell v5 is already installed."}
    return
    }

    if ($ModuleName -eq "Software"){
    write-host "    $FriendlyName " -NoNewLine; write-host "(" -NoNewLine -ForegroundColor DarkGray
    if (! (Get-InstalledSoftware "*$FriendlyName*")){
        write-host "missing" -ForegroundColor Cyan -NoNewLine; write-host ") " -NoNewLine -ForegroundColor DarkGray
        if ($confirm -ne $false -And $InstallAll -ne "Yes"){
            write-host "install now? " -NoNewLine; $Response = Read-Host "[Yes/No/All]"
            if (! $Response){write-host "`nNo response given.  Script will not exit.`n" -ForegroundColor Red; return}
            if ($Response -eq "All" -Or $Response -eq "A"){$script:InstallAll = "Yes"}
            if ($Response -eq "Yes" -Or $Response -eq "Y" -Or $script:InstallAll -eq "Yes"){
                if ($FriendlyName -like "*Microsoft SQL*"){write-host "      starting a lengthy install... a good opportunity to grab a cup of coffee"}else{write-host "      starting install..."}
                if (! (Test-Path $Install)){write-host "`nUnable to locate install: $Install`n"; return}
                $tmpInstall = "$env:temp"+$Install.Split('\')[-1]
                Copy-Item $Install $tmpInstall -Force -Confirm:$false 2>&1 | Out-Null
                if (! (Test-Path $tmpInstall)){write-host "`nFailed to copy install to $env:temp`n"; return}
                Start-Process -Wait $tmpInstall $Parameters
                write-host "      validating install... " -NoNewLine
                if (Get-InstalledSoftware "*$FriendlyName*"){write-host "[successful]`n" -ForegroundColor DarkGreen; return}else{write-host "[failed]`n" -ForegroundColor Cyan; return}
                }
        }else{
                if ($FriendlyName -like "*Microsoft SQL*"){write-host "      starting a lengthy install... a good opportunity to grab a cup of coffee"}else{write-host "      starting install..."}
                if (! (Test-Path $Install)){write-host "`nUnable to locate install: $Install`n"; return}
                $tmpInstall = "$env:temp"+$Install.Split('\')[-1]
                Copy-Item $Install $tmpInstall -Force -Confirm:$false 2>&1 | Out-Null
                if (! (Test-Path $tmpInstall)){write-host "`nFailed to copy install to $env:temp`n"; return}
                Start-Process -Wait $tmpInstall $Parameters
                write-host "      validating install... " -NoNewLine
                if (Get-InstalledSoftware "*$FriendlyName*"){write-host "[successful]`n" -ForegroundColor DarkGreen; return}else{write-host "[failed]`n" -ForegroundColor Cyan; return}
        }

    }else{
        write-host "available" -NoNewline -ForegroundColor DarkGreen; Write-host ")" -ForegroundColor DarkGray
    }


    }else{
        if ($StdModulePath){
            if (Test-Path $StdModulePath){
                if (! ($Env:PSModulePath -like "*$StdModulePath*")){
                    write-host "    correcting missing PSModulePath:  $StdModulePath"
                    $Env:PSModulePath = "$Env:PSModulePath;$StdModulePath"
                    [Environment]::SetEnvironmentVariable("PSModulePath","$Env:PSModulePath","Machine")
                    #$PSModulePath = $script:PSModulePath + ";" + $StdModulePath
                    $script:AvailableModules = Get-Module -ListAvailable
                    $script:AvailableSnapins = Get-PSSnapin -Registered
                }
            }
        }
        if (! $script:AvailableModules){$script:AvailableModules = Get-Module -ListAvailable}
        if (! $script:AvailableSnapins){$script:AvailableSnapins = Get-PSSnapin -Registered}
        write-host "    $FriendlyName " -NoNewLine; write-host "(" -NoNewLine -ForegroundColor DarkGray
        if (! (get-module | Where {$_.Name -eq $ModuleName}) -And ! (get-PSSNapin | Where {$_.Name -eq $ModuleName})){
            
            
            
                if (($AvailableModules | Where {$_.Name -eq "$ModuleName"}) -Or ($AvailableSnapins | Where {$_.Name -eq "$ModuleName"})){
                    if ($AvailableModules | Where {$_.Name -eq "$ModuleName"}){
                        write-host "loading module" -NoNewline -ForegroundColor DarkGreen; Write-host ")" -ForegroundColor DarkGray
                        Import-Module -Force -Global $ModuleName 2>&1 | out-null
                    }else{
                        if ($AvailableSnapins | Where {$_.Name -eq "$ModuleName"}){
                        write-host "loading snapin" -NoNewline -ForegroundColor DarkGreen; Write-host ")" -ForegroundColor DarkGray
                        Add-PSSnapin $ModuleName -ErrorAction SilentlyContinue 2>&1 | out-null
                        if (($ModuleName -eq "VMware.VimAutomation.Core")){Add-PSSnapin VMware.VimAutomation.Vds -ErrorAction SilentlyContinue 2>&1 | out-null}
                        #return
                        }
                    }
                    
                    
                    
                }else{
                    write-host "missing" -ForegroundColor Cyan -NoNewLine; write-host ") " -NoNewLine -ForegroundColor DarkGray
                    if ($confirm -ne $false -And $InstallAll -ne "Yes"){
                        write-host "install now? " -NoNewLine; $Response = Read-Host "[Yes/No/All]"
                        if (! $Response){write-host "`nNo response given.  Script will not exit.`n" -ForegroundColor Red; exit}
                        if ($Response -eq "All" -Or $Response -eq "A"){$script:InstallAll = "Yes"}
                        if ($Response -eq "Yes" -Or $Response -eq "Y" -Or $script:InstallAll -eq "Yes"){
                            if ($FriendlyName -like "*Microsoft SQL*"){write-host "      starting a lengthy install... a good opportunity to grab a cup of coffee"}else{write-host "      starting install..."}
                            Invoke-Expression $InstallCommand 2>&1 | out-null
                            write-host "      validating install..."
                            Remove-Variable AvailableModules -Scope Script
                            Remove-Variable AvailableSnapins -Scope Script
                            foreach ($Parameter in ((Get-Command -Name CheckPreReq).Parameters | Get-Variable -Name {$_.Values.Name} -ErrorAction SilentlyContinue)){$MyParams+=" -"+$Parameter.Name+" `'"+$Parameter.Value+"`'"}
                            Invoke-Expression "CheckPreReq$MyParams"
                            }
                    }else{
                        if ($FriendlyName -like "*Microsoft SQL*"){write-host "`n      starting a lengthy install... a good opportunity to grab a cup of coffee"}else{write-host "`n      starting install..."}
                        Invoke-Expression $InstallCommand 2>&1 | out-null
                        write-host "      validating install..."
                        Remove-Variable AvailableModules -Scope Script
                        Remove-Variable AvailableSnapins -Scope Script
                        foreach ($Parameter in ((Get-Command -Name CheckPreReq).Parameters | Get-Variable -Name {$_.Values.Name} -ErrorAction SilentlyContinue)){$MyParams+=" -"+$Parameter.Name+" `'"+$Parameter.Value+"`'"}
                        Invoke-Expression "CheckPreReq$MyParams"
                    }

                }
            }else{
            write-host "active" -ForegroundColor DarkGreen -NoNewline; Write-host ")" -ForegroundColor DarkGray
            }
    }


}
Function Set-Priv($Credential,$Key,[string]$File){
    if (! $Credential){$Credential = Get-Credential}
    if (! $Key){$Key = (3,3,0,4,6,8,32,58,2,1,6,5,2,6,50,05,4,4,0,7,3,8,47,98)}
    if (! $File){write-host "Filename: " -NoNewLine -ForegroundColor Yellow; $File = Read-Host}
    if ($File -like "*\*"){$shortFile = ($File).Split("\")[-1]}
    $User = ("$Env:USERDOMAIN\$Env:USERNAME").ToLower(); $From = ("$Env:COMPUTERNAME").ToLower()
    Add-zAudit -User $User -From $From -Action "updated priviledge file: $$shortFile" -Status "complete" -Date (get-date)
    $Credential.Password | ConvertFrom-SecureString -Key $Key | Out-File $File
}
Function IsConnectedToInternet{
    if ($IsWindows){
        return [bool]([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet)
    }else{
        if (((Invoke-WebRequest google.com).StatusDescription) -eq "OK"){return $TRUE}else{return $FALSE}
    }
}
Function IsAdmin{
    if ($IsWindows){
        if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")){return $true}else{return $false}
    }else{
        $UID = (id).Split('=')[1].Split('(')[0]
        # $UNAME = (id).Split('(')[1].Split(')')[0]
        if ($UID -eq 0){return $true}else{return $false}
    }
}
Function Get-IP([string]$Name){
    if ($IsWindows){
        return [System.Net.Dns]::GetHostAddresses("$Name").IPAddressToString | Where {$_ -NotLike "*:*"}
    }else{
        $DefaultDev = (route -n | Where {$_ -like '0.0.0.0*'}).Split(' ')[-1]
        $IPAddr = (ip addr show dev $DefaultDev | Where {$_ -like "*inet *"}).Split('/')[0].Split(' ')[5]
        return $IPAddr
    }
}
Function Get-PublicIP {
    (Invoke-WebRequest http://c.zed-labs.com/ip.php).Content
    #(Invoke-WebRequest ifconfig.me/ip).Content
}
Function Get-Geo{
    $MyPublicIP = (Invoke-WebRequest 'http://myip.dnsomatic.com' -UseBasicParsing).Content
    $html = Invoke-WebRequest -Uri "http://freegeoip.net/xml/$myPublicIP" -UseBasicParsing
    $content = [xml]$html.Content
    $content.response
}
Function Move-Window {            
    param(            
 [int]$PxlFromLeft,            
 [int]$PxlFromTop            
 )             
    BEGIN {
    if ($IsLinux){write-host "`nWindows only (for now)`n"; return}        
    $signature = @'

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(
        IntPtr hWnd,
        int X,
        int Y,
        int nWidth,
        int nHeight,
        bool bRepaint);

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(
        HandleRef hWnd,
        out RECT lpRect);

    public struct RECT
    {
        public int Left;        // x position of upper-left corner
        public int Top;         // y position of upper-left corner
        public int Right;       // x position of lower-right corner
        public int Bottom;      // y position of lower-right corner
    }

'@            
            
    Add-Type -MemberDefinition $signature -Name Wutils -Namespace WindowsUtils             
                
    }            
    PROCESS{
    if ($IsLinux){write-host "`nWindows only (for now)`n"; return}        
    $phandle = [WindowsUtils.Wutils]::GetForegroundWindow()            
                
    $o = New-Object -TypeName System.Object            
    $href = New-Object -TypeName System.RunTime.InteropServices.HandleRef -ArgumentList $o, $phandle            
                
    $rct = New-Object WindowsUtils.Wutils+RECT            
                
    [WindowsUtils.Wutils]::GetWindowRect($href, [ref]$rct) | Out-Null       
    if (! $PxlFromLeft -And ! $PxlFromTop){
        $PxlFromLeft = -9
        $PxlFromTop = 0
    }else{
        if (! $PxlFromLeft){$PxlFromLeft = $rct.Left}else{$PxlFromLeft = [int]$PxlFromLeft-9}
        if (! $PxlFromTop){$PxlFromTop = $rct.Top}
    }
    $width = $rct.Right - $rct.Left
    $height = $rct.Bottom - $rct.Top 
    #$height = 700            
    <#

    $rct.Right
    $rct.Left
    $rct.Bottom
    $rct.Top
    
    $width
    $height
    #>             
    [WindowsUtils.Wutils]::MoveWindow($phandle, $PxlFromLeft, $PxlFromTop, $width, $height, $true) | Out-Null          
                
    }             
}
Function PrintBanner($Width,$Height){
	if ($Width -gt $Host.UI.RawUI.MaxPhysicalWindowSize.Width){$Width = $Host.UI.RawUI.MaxPhysicalWindowSize.Width}
	if ($Height -gt $Host.UI.RawUI.MaxPhysicalWindowSize.Height){$Height = $Host.UI.RawUI.MaxPhysicalWindowSize.Height}
	write-host " "
	if (! $Width){
		write-host -ForegroundColor darkblue  "             /ccccccccc\     /ccccccccc\"
		write-host -ForegroundColor darkblue  "             ccccccccccc     ccccccccccc"
		write-host -ForegroundColor darkblue  "             ccccccccccc     ccccccccccc"
		write-host -ForegroundColor darkblue  "             cccccc               cccccc"
		write-host -ForegroundColor darkblue  "             cccccc               cccccc"
		write-host -ForegroundColor darkblue  "             cccccc               cccccc"
		write-host -ForegroundColor white     "                   CCHS Powershell      "
		write-host -ForegroundColor white     "                       Cmdlets          "
		write-host -ForegroundColor darkgreen "             hhhhhh               ssssss"
		write-host -ForegroundColor darkgreen "             hhhhhh               ssssss"
		write-host -ForegroundColor darkgreen "             hhhhhh               ssssss"
		write-host -ForegroundColor darkgreen "             hhhhhhhhhhh     sssssssssss"
		write-host -ForegroundColor darkgreen "             hhhhhhhhhhh     sssssssssss"
		write-host -ForegroundColor darkgreen "             \hhhhhhhhh/     \sssssssss/"
	}else{
		if ($Width -match "[0-9]"){
			if ($Width -lt 35){$Width = 35}
			$NewSize = $Host.UI.RawUI.WindowSize
			$NewBuffer = $Host.UI.RawUI.BufferSize
			$NewBuffer.Width = $Width
			$NewSize.Width = $Width
			if ($Height){$NewSize.Height = $Height}
			if ($Host.UI.RawUI.BufferSize.Width -gt $NewSize.Width){
				$Host.UI.RawUI.WindowSize = $NewSize
				$Host.UI.RawUI.BufferSize = $NewBuffer
			}else{
				$Host.UI.RawUI.BufferSize = $NewBuffer
				$Host.UI.RawUI.WindowSize = $NewSize
			}
			[int]$Center = ($Width/2)
			[int]$Center = ($Center-16)
			Foreach ($i in (1..$Center)){if ($pad){$pad="$pad` "}else{$pad = "` "}}
			write-host -ForegroundColor darkblue  "$pad /ccccccccc\     /ccccccccc\"
			write-host -ForegroundColor darkblue  "$pad ccccccccccc     ccccccccccc"
			write-host -ForegroundColor darkblue  "$pad ccccccccccc     ccccccccccc"
			write-host -ForegroundColor darkblue  "$pad cccccc               cccccc"
			write-host -ForegroundColor darkblue  "$pad cccccc               cccccc"
			write-host -ForegroundColor darkblue  "$pad cccccc               cccccc"
			write-host -ForegroundColor white     "$pad       CCHS Powershell      "
			write-host -ForegroundColor white     "$pad           Cmdlets          "
			write-host -ForegroundColor darkgreen "$pad hhhhhh               ssssss"
			write-host -ForegroundColor darkgreen "$pad hhhhhh               ssssss"
			write-host -ForegroundColor darkgreen "$pad hhhhhh               ssssss"
			write-host -ForegroundColor darkgreen "$pad hhhhhhhhhhh     sssssssssss"
			write-host -ForegroundColor darkgreen "$pad hhhhhhhhhhh     sssssssssss"
			write-host -ForegroundColor darkgreen "$pad \hhhhhhhhh/     \sssssssss/"
			write-host ""
			Foreach ($i in (1..$Width)){write-host "-" -NoNewLine}
		}else{write-host "Size parameter must be numeric." -ForegroundColor Red}
	}
	write-host ""
}
Function Join-Object{
    <#
    .SYNOPSIS
        Join data from two sets of objects based on a common value

    .DESCRIPTION
        Join data from two sets of objects based on a common value
		Credit Warren F

    .PARAMETER Left
        'Left' collection of objects to join.  You can use the pipeline for Left.

        The objects in this collection should be consistent.
        We look at the properties on the first object for a baseline.
    
    .PARAMETER Right
        'Right' collection of objects to join.

        The objects in this collection should be consistent.
        We look at the properties on the first object for a baseline.

    .PARAMETER LeftJoinProperty
        Property on Left collection objects that we match up with RightJoinProperty on the Right collection

    .PARAMETER RightJoinProperty
        Property on Right collection objects that we match up with LeftJoinProperty on the Left collection

    .PARAMETER LeftProperties
        One or more properties to keep from Left.  Default is to keep all Left properties (*).

        Each property can:
            - Be a plain property name like "Name"
            - Contain wildcards like "*"
            - Be a hashtable like @{Name="Product Name";Expression={$_.Name}}.
                 Name is the output property name
                 Expression is the property value ($_ as the current object)
                
                 Alternatively, use the Suffix or Prefix parameter to avoid collisions
                 Each property using this hashtable syntax will be excluded from suffixes and prefixes

    .PARAMETER RightProperties
        One or more properties to keep from Right.  Default is to keep all Right properties (*).

        Each property can:
            - Be a plain property name like "Name"
            - Contain wildcards like "*"
            - Be a hashtable like @{Name="Product Name";Expression={$_.Name}}.
                 Name is the output property name
                 Expression is the property value ($_ as the current object)
                
                 Alternatively, use the Suffix or Prefix parameter to avoid collisions
                 Each property using this hashtable syntax will be excluded from suffixes and prefixes

    .PARAMETER Prefix
        If specified, prepend Right object property names with this prefix to avoid collisions

        Example:
            Property Name                   = 'Name'
            Suffix                          = 'j_'
            Resulting Joined Property Name  = 'j_Name'

    .PARAMETER Suffix
        If specified, append Right object property names with this suffix to avoid collisions

        Example:
            Property Name                   = 'Name'
            Suffix                          = '_j'
            Resulting Joined Property Name  = 'Name_j'

    .PARAMETER Type
        Type of join.  Default is AllInLeft.

        AllInLeft will have all elements from Left at least once in the output, and might appear more than once
          if the where clause is true for more than one element in right, Left elements with matches in Right are
          preceded by elements with no matches.
          SQL equivalent: outer left join (or simply left join)

        AllInRight is similar to AllInLeft.
        
        OnlyIfInBoth will cause all elements from Left to be placed in the output, only if there is at least one
          match in Right.
          SQL equivalent: inner join (or simply join)
         
        AllInBoth will have all entries in right and left in the output. Specifically, it will have all entries
          in right with at least one match in left, followed by all entries in Right with no matches in left, 
          followed by all entries in Left with no matches in Right.
          SQL equivalent: full join

    .EXAMPLE
        #
        #Define some input data.

        $l = 1..5 | Foreach-Object {
            [pscustomobject]@{
                Name = "jsmith$_"
                Birthday = (Get-Date).adddays(-1)
            }
        }

        $r = 4..7 | Foreach-Object{
            [pscustomobject]@{
                Department = "Department $_"
                Name = "Department $_"
                Manager = "jsmith$_"
            }
        }

        #We have a name and Birthday for each manager, how do we find their department, using an inner join?
        Join-Object -Left $l -Right $r -LeftJoinProperty Name -RightJoinProperty Manager -Type OnlyIfInBoth -RightProperties Department


            # Name    Birthday             Department  
            # ----    --------             ----------  
            # jsmith4 4/14/2015 3:27:22 PM Department 4
            # jsmith5 4/14/2015 3:27:22 PM Department 5

    .EXAMPLE  
        #
        #Define some input data.

        $l = 1..5 | Foreach-Object {
            [pscustomobject]@{
                Name = "jsmith$_"
                Birthday = (Get-Date).adddays(-1)
            }
        }

        $r = 4..7 | Foreach-Object{
            [pscustomobject]@{
                Department = "Department $_"
                Name = "Department $_"
                Manager = "jsmith$_"
            }
        }

        #We have a name and Birthday for each manager, how do we find all related department data, even if there are conflicting properties?
        $l | Join-Object -Right $r -LeftJoinProperty Name -RightJoinProperty Manager -Type AllInLeft -Prefix j_

            # Name    Birthday             j_Department j_Name       j_Manager
            # ----    --------             ------------ ------       ---------
            # jsmith1 4/14/2015 3:27:22 PM                                    
            # jsmith2 4/14/2015 3:27:22 PM                                    
            # jsmith3 4/14/2015 3:27:22 PM                                    
            # jsmith4 4/14/2015 3:27:22 PM Department 4 Department 4 jsmith4  
            # jsmith5 4/14/2015 3:27:22 PM Department 5 Department 5 jsmith5  

    .EXAMPLE
        #
        #Hey!  You know how to script right?  Can you merge these two CSVs, where Path1's IP is equal to Path2's IP_ADDRESS?
        
        #Get CSV data
        $s1 = Import-CSV $Path1
        $s2 = Import-CSV $Path2

        #Merge the data, using a full outer join to avoid omitting anything, and export it
        Join-Object -Left $s1 -Right $s2 -LeftJoinProperty IP_ADDRESS -RightJoinProperty IP -Prefix 'j_' -Type AllInBoth |
            Export-CSV $MergePath -NoTypeInformation

    .EXAMPLE
        #
        # "We need to match up SSNs to Active Directory users, and check if they are enabled or not.
        
        # Import some SSNs. 
        $SSNs = Import-CSV -Path D:\SSNs.csv

        #Get AD users, and match up by a common value, samaccountname in this case:
        Get-ADUser -Filter "samaccountname -like 'wframe*'" |
            Join-Object -LeftJoinProperty samaccountname -Right $SSNs `
                        -RightJoinProperty samaccountname -RightProperties ssn `
                        -LeftProperties samaccountname, enabled, objectclass

    .NOTES

    .LINK

    .FUNCTIONALITY
        PowerShell Language

    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeLine = $true)]
        [object[]] $Left,

        # List to join with $Left
        [Parameter(Mandatory=$true)]
        [object[]] $Right,

        [Parameter(Mandatory = $true)]
        [string] $LeftJoinProperty,

        [Parameter(Mandatory = $true)]
        [string] $RightJoinProperty,

        [object[]]$LeftProperties = '*',

        # Properties from $Right we want in the output.
        # Like LeftProperties, each can be a plain name, wildcard or hashtable. See the LeftProperties comments.
        [object[]]$RightProperties = '*',

        [validateset( 'AllInLeft', 'OnlyIfInBoth', 'AllInBoth', 'AllInRight')]
        [Parameter(Mandatory=$false)]
        [string]$Type = 'AllInLeft',

        [string]$Prefix,
        [string]$Suffix
    )
    Begin
    {
        function AddItemProperties($item, $properties, $hash)
        {
            if ($null -eq $item)
            {
                return
            }

            foreach($property in $properties)
            {
                $propertyHash = $property -as [hashtable]
                if($null -ne $propertyHash)
                {
                    $hashName = $propertyHash["name"] -as [string]         
                    $expression = $propertyHash["expression"] -as [scriptblock]

                    $expressionValue = $expression.Invoke($item)[0]
            
                    $hash[$hashName] = $expressionValue
                }
                else
                {
                    foreach($itemProperty in $item.psobject.Properties)
                    {
                        if ($itemProperty.Name -like $property)
                        {
                            $hash[$itemProperty.Name] = $itemProperty.Value
                        }
                    }
                }
            }
        }

        function TranslateProperties
        {
            [cmdletbinding()]
            param(
                [object[]]$Properties,
                [psobject]$RealObject,
                [string]$Side)

            foreach($Prop in $Properties)
            {
                $propertyHash = $Prop -as [hashtable]
                if($null -ne $propertyHash)
                {
                    $hashName = $propertyHash["name"] -as [string]         
                    $expression = $propertyHash["expression"] -as [scriptblock]

                    $ScriptString = $expression.tostring()
                    if($ScriptString -notmatch 'param\(')
                    {
                        Write-Verbose "Property '$HashName'`: Adding param(`$_) to scriptblock '$ScriptString'"
                        $Expression = [ScriptBlock]::Create("param(`$_)`n $ScriptString")
                    }
                
                    $Output = @{Name =$HashName; Expression = $Expression }
                    Write-Verbose "Found $Side property hash with name $($Output.Name), expression:`n$($Output.Expression | out-string)"
                    $Output
                }
                else
                {
                    foreach($ThisProp in $RealObject.psobject.Properties)
                    {
                        if ($ThisProp.Name -like $Prop)
                        {
                            Write-Verbose "Found $Side property '$($ThisProp.Name)'"
                            $ThisProp.Name
                        }
                    }
                }
            }
        }

        function WriteJoinObjectOutput($leftItem, $rightItem, $leftProperties, $rightProperties)
        {
            $properties = @{}

            AddItemProperties $leftItem $leftProperties $properties
            AddItemProperties $rightItem $rightProperties $properties

            New-Object psobject -Property $properties
        }

        #Translate variations on calculated properties.  Doing this once shouldn't affect perf too much.
        foreach($Prop in @($LeftProperties + $RightProperties))
        {
            if($Prop -as [hashtable])
            {
                foreach($variation in ('n','label','l'))
                {
                    if(-not $Prop.ContainsKey('Name') )
                    {
                        if($Prop.ContainsKey($variation) )
                        {
                            $Prop.Add('Name',$Prop[$Variation])
                        }
                    }
                }
                if(-not $Prop.ContainsKey('Name') -or $Prop['Name'] -like $null )
                {
                    Throw "Property is missing a name`n. This should be in calculated property format, with a Name and an Expression:`n@{Name='Something';Expression={`$_.Something}}`nAffected property:`n$($Prop | out-string)"
                }


                if(-not $Prop.ContainsKey('Expression') )
                {
                    if($Prop.ContainsKey('E') )
                    {
                        $Prop.Add('Expression',$Prop['E'])
                    }
                }
            
                if(-not $Prop.ContainsKey('Expression') -or $Prop['Expression'] -like $null )
                {
                    Throw "Property is missing an expression`n. This should be in calculated property format, with a Name and an Expression:`n@{Name='Something';Expression={`$_.Something}}`nAffected property:`n$($Prop | out-string)"
                }
            }        
        }

        $leftHash = @{}
        $rightHash = @{}

        # Hashtable keys can't be null; we'll use any old object reference as a placeholder if needed.
        $nullKey = New-Object psobject
        
        $bound = $PSBoundParameters.keys -contains "InputObject"
        if(-not $bound)
        {
            [System.Collections.ArrayList]$LeftData = @()
        }
    }
    Process
    {
        #We pull all the data for comparison later, no streaming
        if($bound)
        {
            $LeftData = $Left
        }
        Else
        {
            foreach($Object in $Left)
            {
                [void]$LeftData.add($Object)
            }
        }
    }
    End
    {
        foreach ($item in $Right)
        {
            $key = $item.$RightJoinProperty

            if ($null -eq $key)
            {
                $key = $nullKey
            }

            $bucket = $rightHash[$key]

            if ($null -eq $bucket)
            {
                $bucket = New-Object System.Collections.ArrayList
                $rightHash.Add($key, $bucket)
            }

            $null = $bucket.Add($item)
        }

        foreach ($item in $LeftData)
        {
            $key = $item.$LeftJoinProperty

            if ($null -eq $key)
            {
                $key = $nullKey
            }

            $bucket = $leftHash[$key]

            if ($null -eq $bucket)
            {
                $bucket = New-Object System.Collections.ArrayList
                $leftHash.Add($key, $bucket)
            }

            $null = $bucket.Add($item)
        }

        $LeftProperties = TranslateProperties -Properties $LeftProperties -Side 'Left' -RealObject $LeftData[0]
        $RightProperties = TranslateProperties -Properties $RightProperties -Side 'Right' -RealObject $Right[0]

        #I prefer ordered output. Left properties first.
        [string[]]$AllProps = $LeftProperties

        #Handle prefixes, suffixes, and building AllProps with Name only
        $RightProperties = foreach($RightProp in $RightProperties)
        {
            if(-not ($RightProp -as [Hashtable]))
            {
                Write-Verbose "Transforming property $RightProp to $Prefix$RightProp$Suffix"
                @{
                    Name="$Prefix$RightProp$Suffix"
                    Expression=[scriptblock]::create("param(`$_) `$_.'$RightProp'")
                }
                $AllProps += "$Prefix$RightProp$Suffix"
            }
            else
            {
                Write-Verbose "Skipping transformation of calculated property with name $($RightProp.Name), expression:`n$($RightProp.Expression | out-string)"
                $AllProps += [string]$RightProp["Name"]
                $RightProp
            }
        }

        $AllProps = $AllProps | Select -Unique

        Write-Verbose "Combined set of properties: $($AllProps -join ', ')"

        foreach ( $entry in $leftHash.GetEnumerator() )
        {
            $key = $entry.Key
            $leftBucket = $entry.Value

            $rightBucket = $rightHash[$key]

            if ($null -eq $rightBucket)
            {
                if ($Type -eq 'AllInLeft' -or $Type -eq 'AllInBoth')
                {
                    foreach ($leftItem in $leftBucket)
                    {
                        WriteJoinObjectOutput $leftItem $null $LeftProperties $RightProperties | Select $AllProps
                    }
                }
            }
            else
            {
                foreach ($leftItem in $leftBucket)
                {
                    foreach ($rightItem in $rightBucket)
                    {
                        WriteJoinObjectOutput $leftItem $rightItem $LeftProperties $RightProperties | Select $AllProps
                    }
                }
            }
        }

        if ($Type -eq 'AllInRight' -or $Type -eq 'AllInBoth')
        {
            foreach ($entry in $rightHash.GetEnumerator())
            {
                $key = $entry.Key
                $rightBucket = $entry.Value

                $leftBucket = $leftHash[$key]

                if ($null -eq $leftBucket)
                {
                    foreach ($rightItem in $rightBucket)
                    {
                        WriteJoinObjectOutput $null $rightItem $LeftProperties $RightProperties | Select $AllProps
                    }
                }
            }
        }
    }
}
Function Get-InstalledSoftware([string]$Name){
    if ($IsWindows){
        if ($Name){
            Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where {$_.DisplayName -And $_.DisplayName -like "$Name"} | Sort DisplayName | Select-Object DisplayName, InstallDate, DisplayVersion, Publisher | Sort InstallDate -Descending
        }else{
            Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where {$_.DisplayName} | Sort DisplayName | Select-Object DisplayName, InstallDate, DisplayVersion, Publisher | Sort InstallDate -Descending
        }
    }else{
        rpm -qa
    }
}
Function Which([string]$Name){
	foreach ($dir in ($env:path).split(';')){
		if (test-path "$dir\$Name"){
			(get-item "$dir\$Name").Fullname
		}elseif(test-path "$dir\$Name`.exe"){
			(get-item "$dir\$Name`.exe").Fullname
		}elseif(test-path "$dir\$Name`.com"){
			(get-item "$dir\$Name`.com").Fullname
		}elseif(test-path "$dir\$Name`.bat"){
			(get-item "$dir\$Name`.bat").Fullname
		}elseif(test-path "$dir\$Name`.cmd"){
			(get-item "$dir\$Name`.cmd").Fullname
		}elseif(test-path "$dir\$Name`.lnk"){
			(get-item "$dir\$Name`.lnk").Fullname
		}elseif(test-path "$dir\$Name`.vbs"){
			(get-item "$dir\$Name`.vbs").Fullname
		}elseif(test-path "$dir\$Name`.ps1"){
			(get-item "$dir\$Name`.ps1").Fullname
		}
	}
}
Function New-SyslogMessage($Server,$Message,$Severity,$Facility,$Hostname,$UDPPort){

 if (! $UDPPort){[int]$UDPPort}
    # Create a UDP Client Object
    $UDPCLient = New-Object System.Net.Sockets.UdpClient
    $UDPCLient.Connect($Server, $UDPPort)
    
    # Evaluate the facility and severity based on the enum types
    $Facility_Number = $Facility.value__
    $Severity_Number = $Severity.value__
    Write-Verbose "Syslog Facility, $Facility_Number, Severity is $Severity_Number"
    
    # Calculate the priority
    $Priority = ($Facility_Number * 8) + $Severity_Number
    Write-Verbose "Priority is $Priority"
    
    # If no hostname parameter specified, then set it
    if (($Hostname -eq "") -or ($Hostname -eq $null))
    {
            $Hostname = Hostname
    }
    
    # I the hostname hasn't been specified, then we will use the current date and time
    if (($Timestamp -eq "") -or ($Timestamp -eq $null))
    {
            $Timestamp = Get-Date -Format "yyyy:MM:dd:-HH:mm:ss"
    }
    
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "<{0}>{1} {2} {3}" -f $Priority, $null, $Hostname, $Message
    
    # create an ASCII Encoding object
    $Encoding = [System.Text.Encoding]::ASCII
    
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    
    # If the message is too long, shorten it
    if ($ByteSyslogMessage.Length -gt 1024)
    {
        $ByteSyslogMessage = $ByteSyslogMessage.SubString(0, 1024)
    }
    
    # Send the Message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
 
}
Function yt{
    Param (
        [Parameter(Mandatory=$True)]
        [string]$VideoUrl
    )
    if (! $inpath){$script:inpath = (split-path -parent $PSScriptRoot)+"\etc\"}
    Write-Host "Downloading..."
    . $inpath`yt.exe -o '%(upload_date)s - %(uploader)s - %(title)s - %(id)s.%(ext)s' $VideoUrl
}
Function Putty-Shuffle {
    <#
    .SYNOPSIS
    Shuffles putty sessions.
    .DESCRIPTION
    Shuffles putty sessions.
    #>
    if ($IsLinux){write-host "`nWindows only (for now)`n"; return}
    foreach ($ps in (tasklist /fi "imagename eq putty.exe" /fo csv /v)){[array]$MyPS += $ps.split("`",`"")[26]}
    foreach ($i in ($MyPS | sort)){nircmd win settopmost ititle $i 1; nircmd win settopmost ititle $i 0}
}
Function Putty-Stack {
    <#
    .SYNOPSIS
    Shuffles putty sessions.
    .DESCRIPTION
    Shuffles putty sessions.
    #>
    if ($IsLinux){write-host "`nWindows only (for now)`n"; return}
    foreach ($ps in (tasklist /fi "imagename eq putty.exe" /nh /fo csv /v)){[array]$MyPS += $ps.split("`",`"")[26]}

    $x = (Get-WmiObject win32_videocontroller).CurrentHorizontalResolution
    $y = (Get-WmiObject win32_videocontroller).CurrentVerticalResolution
    if ($x -is [system.array]){[int]$x = $x[0]} else {[int]$x = $x}
    if ($y -is [system.array]){[int]$y = $y[0]} else {[int]$y = $y}
    $wins = ($MyPS).count
    foreach ($slam in 1..$wins){
    write-host "$slam of $wins"
    [int]$spacing = ($y / $wins)
    [int]$MyTop = 0 - $spacing

    foreach ($i in ($MyPS | sort)){
        if (-Not $first){$first=$i}
        nircmd win setsize ititle $i 0 $MyTop $x $Spacing
        [int]$MyTop = $MyTop + $spacing
        nircmd win -style ititle $i 0x00C00000
        nircmd win -style ititle $i 0x00C0000
        }
    }
    nircmd win center ititle $first ; nircmd win setsize ititle $first 300 100 1280 720 ; 
}
Function Get-Stockquote{
    <#
    .Synopsis
    Get Stock quote for a company Symbol 
    .Description
    Get Stock quote for a company Symbol 
    Parameter symbol
    Enter the Symbol of the company/
    .Example
    ./Get-stockquote -Symbols ge
    This example shows how to return the stock quote for the GE stock. 
    .Example
    ./Get-stockquote -Symbols "ge","mmm" | format-table
    In this example the function will return the stock quotes for GE and 3m
    
    #>
    [cmdletBinding()]
    Param(
        [parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Mandatory=$TRUE)]
        $Symbols
        )
        $Results = @()
    if ($IsLinux){write-host "`nWindows only (for now)`n"; return}
    foreach ($symbol in $symbols){
        $c = 0
        $row = New-Object psobject
        $Response = (Invoke-WebRequest -Uri "http://download.finance.yahoo.com/d/quotes.csv?s=$Symbol&f=aa2a5bb2b3b4b6cc1c3c6c8dd1d2ee1e7e8e9f6ghjkg1g3g4g5g6ii5j1j3j4j5j6k1k2k3k4k5ll1l2l3mm2m3m4m5m6m7m8nn4opp1p2p5p6qrr1r2r5r6r7ss1s7t1t6t7t8vv1v7ww1w4xy").ToString()
        foreach ($v in $Response.Split(',')){
        $v = $v.Replace('"','')
        $c++
        switch ($c){
            "1" {$PropName = "Ask"}
            "2" {$PropName = "Average-Daily-Volume"}
            "3" {$PropName = "Ask-Size"}
            "4" {$PropName = "Bid"}
            "5" {$PropName = "Ask-Real-time"}
            "6" {$PropName = "Bid-Real-time"}
            "7" {$PropName = "Book-Value"}
            "8" {$PropName = "Bid-Size"}
            "9" {$PropName = "Change-Percent-Change"}
            "10" {$PropName = "Change"}
            "11" {$PropName = "Commission"}
            "12" {$PropName = "Change-Real-time"}
            "13" {$PropName = "After-Hours-Change-Real-time"}
            "14" {$PropName = "Dividend-Share"}
            "15" {$PropName = "Last-Trade-Date"}
            "16" {$PropName = "Trade-Date"}
            "17" {$PropName = "Earnings-Share"}
            "18" {$PropName = "Error-Indication"}
            "19" {$PropName = "EPS-Estimate-Current-Year"}
            "20" {$PropName = "EPS-Estimate-Next-Year"}
            "21" {$PropName = "EPS-Estimate-Next-Quarter"}
            "22" {$PropName = "Float-Shares"}
            "23" {$PropName = "Day-Low"}
            "24" {$PropName = "Day-High"}
            "25" {$PropName = "52-week-Low"}
            "26" {$PropName = "52-week-High"}
            "27" {$PropName = "Holdings-Gain-Percent"}
            "28" {$PropName = "Annualized-Gain"}
            "29" {$PropName = "Holdings-Gain"}
            "30" {$PropName = "Holdings-Gain-Percent-Real-time"}
            "31" {$PropName = "Holdings-Gain-Real-time"}
            "32" {$PropName = "More-Info"}
            "33" {$PropName = "Order-Book-Real-time"}
            "34" {$PropName = "Market-Capitalization"}
            "35" {$PropName = "Market-Cap-Real-time"}
            "36" {$PropName = "EBITDA"}
            "37" {$PropName = "Change-From-52-week-Low"}
            "38" {$PropName = "Percent-Change-From-52-week-Low"}
            "39" {$PropName = "Last-Trade-Real-time-With-Time"}
            "40" {$PropName = "Change-Percent-Real-time"}
            "41" {$PropName = "Last-Trade-Size"}
            "42" {$PropName = "Change-From-52-week-High"}
            "43" {$PropName = "Percent-Change-From-52-week-High"}
            "44" {$PropName = "Last-Trade-With-Time"}
            "45" {$PropName = "Last-Trade-Price-Only"}
            "46" {$PropName = "High-Limit"}
            "47" {$PropName = "Low-Limit"}
            "48" {$PropName = "Day-Range"}
            "49" {$PropName = "Day-Range-Real-time"}
            "50" {$PropName = "50-day-Moving-Average"}
            "51" {$PropName = "200-day-Moving-Average"}
            "52" {$PropName = "Change-From-200-day-Moving-Average"}
            "53" {$PropName = "Percent-Change-From-200-day-Moving-Average"}
            "54" {$PropName = "Change-From-50-day-Moving-Average"}
            "55" {$PropName = "Percent-Change-From-50-day-Moving-Average"}
            "56" {$PropName = "Name"}
            "57" {$PropName = "Notes"}
            "58" {$PropName = "Open"}
            "59" {$PropName = "Previous-Close"}
            "60" {$PropName = "Price-Paid"}
            "61" {$PropName = "Change-in-Percent"}
            "62" {$PropName = "Price-Sales"}
            "63" {$PropName = "Price-Book"}
            "64" {$PropName = "Ex-Dividend-Date"}
            "65" {$PropName = "PE-Ratio"}
            "66" {$PropName = "Dividend-Pay-Date"}
            "67" {$PropName = "PE-Ratio-Real-time"}
            "68" {$PropName = "PEG-Ratio"}
            "69" {$PropName = "Price-EPS-Estimate-Current-Year"}
            "70" {$PropName = "Price-EPS-Estimate-Next-Year"}
            "71" {$PropName = "Symbol"}
            "72" {$PropName = "Shares-Owned"}
            "73" {$PropName = "Short-Ratio"}
            "74" {$PropName = "Last-Trade-Time"}
            "75" {$PropName = "Trade-Links"}
            "76" {$PropName = "Ticker-Trend"}
            "77" {$PropName = "1-yr-Target-Price"}
            "78" {$PropName = "Volume"}
            "79" {$PropName = "Holdings-Value"}
            "80" {$PropName = "Holdings-Value-Real-time"}
            "81" {$PropName = "52-week-Range"}
            "82" {$PropName = "Day-Value-Change"}
            "83" {$PropName = "Day-Value-Change-Real-time"}
            "84" {$PropName = "Stock-Exchange"}
            "85" {$PropName = "Dividend-Yield"}
        }
        if ($v -eq "N/A"){
            $row | Add-Member -MemberType Noteproperty "$PropName" -value "$null"
        }else{
            $row | Add-Member -MemberType Noteproperty "$PropName" -value "$v"
        }
        
        }
        $results += $row
        return $results
    #return $Response
    
    <#

    a	Ask
    a2	Average Daily Volume
    a5	Ask Size
    b	Bid
    b2	Ask (Real-time)
    b3	Bid (Real-time)
    b4	Book Value
    b6	Bid Size
    c	Change & Percent Change
    c1	Change
    c3	Commission
    c6	Change (Real-time)
    c8	After Hours Change (Real-time)
    d	Dividend/Share
    d1	Last Trade Date
    d2	Trade Date
    e	Earnings/Share
    e1	Error Indication (returned for symbol changed / invalid)
    e7	EPS Estimate Current Year
    e8	EPS Estimate Next Year
    e9	EPS Estimate Next Quarter
    f6	Float Shares
    g	Day’s Low
    h	Day’s High
    j	52-week Low
    k	52-week High
    g1	Holdings Gain Percent
    g3	Annualized Gain
    g4	Holdings Gain
    g5	Holdings Gain Percent (Real-time)
    g6	Holdings Gain (Real-time)
    i	More Info
    i5	Order Book (Real-time)
    j1	Market Capitalization
    j3	Market Cap (Real-time)
    j4	EBITDA
    j5	Change From 52-week Low
    j6	Percent Change From 52-week Low
    k1	Last Trade (Real-time) With Time
    k2	Change Percent (Real-time)
    k3	Last Trade Size
    k4	Change From 52-week High
    k5	Percent Change From 52-week High
    l	Last Trade (With Time)
    l1	Last Trade (Price Only)
    l2	High Limit
    l3	Low Limit
    m	Day’s Range
    m2	Day’s Range (Real-time)
    m3	50-day Moving Average
    m4	200-day Moving Average
    m5	Change From 200-day Moving Average
    m6	Percent Change From 200-day Moving Average
    m7	Change From 50-day Moving Average
    m8	Percent Change From 50-day Moving Average
    n	Name
    n4	Notes
    o	Open
    p	Previous Close
    p1	Price Paid
    p2	Change in Percent
    p5	Price/Sales
    p6	Price/Book
    q	Ex-Dividend Date
    r	P/E Ratio
    r1	Dividend Pay Date
    r2	P/E Ratio (Real-time)
    r5	PEG Ratio
    r6	Price/EPS Estimate Current Year
    r7	Price/EPS Estimate Next Year
    s	Symbol
    s1	Shares Owned
    s7	Short Ratio
    t1	Last Trade Time
    t6	Trade Links
    t7	Ticker Trend
    t8	1 yr Target Price
    v	Volume
    v1	Holdings Value
    v7	Holdings Value (Real-time)
    w	52-week Range
    w1	Day’s Value Change
    w4	Day’s Value Change (Real-time)
    x	Stock Exchange
    y	Dividend Yield

    #>




    }   
}
