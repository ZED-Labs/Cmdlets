function zCore([string]$Name){
	Get-Command -Module zCore | Where {$_.Name -like "*$Name*"}
}
function Mods([string]$Name){
	if ($profile -like "*\*"){$ProfilePath = $profile.Replace($profile.split("\")[-1],"").trim('\')}
	if ($profile -like "*/*"){$ProfilePath = '/'+$profile.Replace($profile.split("/")[-1],"").trim('/')}
	foreach ($mod in (Get-Module | Where {$_.Name -like "*$Name*" -And $_.Path -like "*$ProfilePath*"})){get-module $mod.Name}
}
Function zUpdate([string]$Name){
	zInit

	if ($ProfilePath -like "*\*"){
			write-host "`nChecking for module updates..." -Foregroundcolor Yellow
			write-host "  core..." -Foregroundcolor Yellow -NoNewLine
			$AvailableVer = (Get-Item '\\c.zed-labs.com\cmdlet$\modules\zCore\zCore.psm1').LastWriteTime
			$InstalledVer = (Get-Item (Get-Module zCore).Path).LastWriteTime
			$InstallTo = (Get-Module zCore).Path
			$InitVer = (Get-Item '\\c.zed-labs.com\cmdlet$\modules\zCore\init.ps1').LastWriteTime
			$InitInstalled = (Get-Item ("$ProfilePath\Modules\zCore\init.ps1")).LastWriteTime
			if ($AvailableVer -gt $InstalledVer -Or $InitVer -gt $InitInstalled){
				write-host " updating to " -ForegroundColor DarkGreen -NoNewLine; write-host "$AvailableVer" -ForegroundColor Cyan
				Copy-Item '\\c.zed-labs.com\cmdlet$\modules\zCore\zCore.psm1' $InstallTo
				Copy-Item '\\c.zed-labs.com\cmdlet$\modules\zCore\init.ps1' "$ProfilePath\Modules\zCore\init.ps1"
				import-module (($InstallTo).Replace(".psm1",".psd1")) -Scope Global -DisableNameChecking -Force
			}else{write-host " already current." -ForegroundColor DarkGreen}
			$WarningPreference = "SilentlyContinue"
			$errorActionPreference = "SilentlyContinue"
			if ($Name){$Target = Get-ChildItem -Recurse '\\c.zed-labs.com\cmdlet$\modules\' | Where {$_.Name -like "$Name"}}else{$Target = Get-ChildItem -Recurse '\\c.zed-labs.com\cmdlet$\modules\'}
			foreach ($module in ($Target | Where {$_.Name -like "*.psm1"} | Sort LastWriteTime)){
				$modulename = $module.Name
				$shortname = ($modulename).Split(".")[0]
				if ($shortname -eq "zCore"){continue}
				write-host "  $shortname`..." -Foregroundcolor Yellow -NoNewLine

				if (Test-Path "$ProfilePath\Modules\$shortname\Block.txt"){
					if ($Block -eq $false){
						Remove-Item -Force -Confirm:$false "$ProfilePath\Modules\$shortname\Block.txt" 2>&1 | Out-Null
						write-host " unblocked"
					}else{
						write-host " blocked" -ForegroundColor Cyan
					}
					continue
				}
				
				$psm = ($profile.Replace($profile.split("\")[-1],"")+$module.FullName.Replace("\\c.zed-labs.com\cmdlet$\",""))
				$psd = (($psm).Replace(".psm1",".psd1"))
				$ParentFolder = $profile.Replace($profile.split("\")[-1],"")+"modules\"+$module.psParentPath.Split("\")[-1]
				if (! (Test-Path $ParentFolder)){md $ParentFolder 2>&1 | Out-Null}
				if (get-item ($module.fullName.Replace(".psm1",".psd1")) -ea 0 -wa 0){
				if (! (get-childItem -Recurse $ParentFolder | Where {$_.Name -like "*.psd1"})){
					copy-item -Recurse -force -confirm:$false (get-item ($module.fullName.Replace(".psm1",".psd1"))) $psd -wa 0 2>&1 | Out-Null
				}}
				if (! (get-childItem -Recurse $ParentFolder | Where {$_.Name -like "*.psm1"})){
					copy-item -Recurse -force -confirm:$false ($module).fullname $psm -wa 0
					if ((Test-Path $psd)){import-module $psd -Scope Global -DisableNameChecking -Force 2>&1 | Out-Null}else{if ((Test-Path "$psm")){import-module $psm -Scope Global -DisableNameChecking -Force 2>&1 | Out-Null}}
					write-host " installing." -ForegroundColor Cyan
					continue
				}
				$AvailableVer = (($module) | Get-FileHash).hash
				$InstalledVer = ((get-item $psm) | Get-FileHash).hash
				if ($AvailableVer -ne $InstalledVer){
					write-host " updating." -ForegroundColor DarkGreen
					Copy-Item -recurse -force -confirm:$false (($module.fullname).Replace(".psm1",".psd1")) "$psd" -wa 0 2>&1 | Out-Null
					Copy-Item -recurse -force -confirm:$false ($module.fullname) "$psm" -wa 0
					if ((Test-Path "$psd")){import-module "$psd" -Scope Global -DisableNameChecking -Force 2>&1 | Out-Null}else{if ((Test-Path "$psm")){import-module $psm -Scope Global -DisableNameChecking -Force 2>&1 | Out-Null}}
				}else{write-host " already current." -ForegroundColor DarkGreen}
			}
	}else{
			$Available = @(Invoke-WebRequest http://c.zed-labs.com/cmdlets/modules).links.href
			clear;
			write-host "`nChecking for module updates..." -Foregroundcolor Yellow
			foreach ($mod in ($Available | Select -Skip 1)){
				$Mod = $Mod.Split('/')[0]
				write-host "  $Mod`..." -ForegroundColor Yellow
				if (! (test-path "$ModulePath/$Mod")){md "$ModulePath/$Mod" -p | Out-Null}
				$ModFiles = @(Invoke-WebRequest http://c.zed-labs.com/cmdlets/modules/$Mod).links.href
				foreach ($modFile in ($ModFiles | Select -Skip 1)){
					write-host "    $ModFile" -ForegroundColor DarkGreen
					wget "http://c.zed-labs.com/cmdlets/modules/$Mod/$ModFile" -q -O "$ModulePath/$Mod/$modFile" | Out-Null
				}
				import-module -Global -Force -DisableNameChecking $Mod 2>&1 | Out-Null
			}
	}
	""
}
Function zRemove([string]$Name,[Switch]$Block,[Switch]$UnBlock){
	if (! $Name){write-host "`nPlease specify " -NoNewLine; write-host "-Name`n" -Foreground Cyan; return}


	write-host "`nChecking for module: $Name" -Foregroundcolor Yellow

	$ModLoaded = (Get-Module | Where {$_.Name -like "$Name"})
	$ProfilePath = ($profile.Replace($profile.split("\")[-1],""))
	$AllProfileFiles = (Get-ChildItem -Recurse $ProfilePath)
	$ProfileFiles = (Get-ChildItem -Recurse $ProfilePath | Where {$_.Name -like "$Name.*"})

	write-host "  Loaded   : " -NoNewLine
	if ($ModLoaded){write-host "yes"}else{write-host "no"}
	write-host "  Installed: " -NoNewLine
	if ($ProfileFiles){write-host "yes"}else{write-host "no"}
	if (! $ModLoaded -And ! $ProfileFiles){
		if ((Test-Path "$ProfilePath\Modules\$Name\Block.txt")){
			if ($Unblock){Remove-Item -Force -Confirm:$false "$ProfilePath\Modules\$Name\Block.txt" 2>&1 | Out-Null; write-host "`n$Name has been unblocked.`n" -ForegroundColor Cyan}else{write-host "`n$Name is already blocked.`n"}
		}else{
			write-host "`nNot loaded, installed, or blocked.`n"
		}
		continue
	}
	write-host "`nRemoving $Name`..." -NoNewLine -ForegroundColor Yellow
	Remove-Module $Name -Force -Confirm:$false 2>&1 | Out-Null
	foreach ($Item in ($ProfileFiles.FullName)){Remove-Item -Force -Confirm:$false $Item }
	$ModLoaded = (Get-Module | Where {$_.Name -like "$Name"})
	$ProfileFiles = (Get-ChildItem -Recurse $ProfilePath | Where {$_.Name -like "$Name.*"})
	if ($ModLoaded){write-host " Failed to unload module" -ForegroundColor Cyan -NoNewLine}
	if ($ProfileFiles){write-host " Failed to remove local files" -ForegroundColor Cyan -NoNewLine}
	if ($ModLoaded -Or $ProfileFiles){
		write-host "`n"
		return
	}else{
		if ($Block){
			
			"Blocked by "+($env:userdomain)+"\"+($env:username)+" on "+(get-date) | Out-File "$ProfilePath\Modules\$Name\Block.txt"
			write-host " unloaded, deleted, `& blocked.`n" -ForegroundColor DarkGreen
		}else{
			if ($Unblock){
				if (Test-Path "$ProfilePath\Modules\$Name\Block.txt"){
					Remove-Item -Force -Confirm:$false "$ProfilePath\Modules\$Name\Block.txt" 2>&1 | Out-Null
				}
			write-host " unloaded, deleted, `& unblocked`n" -ForegroundColor DarkGreen
			}else{
			write-host " unloaded and deleted.`n" -ForegroundColor DarkGreen
			}
		}
	}
}
