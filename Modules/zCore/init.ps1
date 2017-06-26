write-host "Initializing Cmdlets..." -ForegroundColor Yellow -NonewLine
function zInit(){
	if ($profile -like "*\*"){
		$Global:ProfilePath = $profile.Replace($profile.split("\")[-1],"").trim('\')
		$Global:ModulePath = "$ProfilePath\Modules"
	}
	if ($profile -like "*/*"){
		$Global:ProfilePath = '/'+$profile.Replace($profile.split("/")[-1],"").trim('/')
		$Global:ModulePath = "$HOME/WindowsPowerShell/Modules"
	}
}

zInit

foreach ($Module in (Get-ChildItem -Recurse:$true $ModulePath\*.psm1)){
	$ModuleName = ($Module.Name).Split('.')[0]
	import-module -Global -Force -DisableNameChecking $Module.FullName 2>&1 | Out-Null
	if ((get-module | Where {$_.Name -eq "$ModuleName"})){
		write-host " $ModuleName" -ForegroundColor DarkGreen -NoNewLine
	}else{
		write-host " $ModuleName" -ForegroundColor Red -NoNewLine
	}
}