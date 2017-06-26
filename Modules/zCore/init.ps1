write-host "Cmdlet initialization has started..." -ForegroundColor Yellow -NonewLine
if ($profile -like "*\*"){
	$ProfilePath = $profile.Replace($profile.split("\")[-1],"").trim('\')
    $ModulePath = "$ProfilePath\Modules"
}
if ($profile -like "*/*"){
	$ProfilePath = '/'+$profile.Replace($profile.split("/")[-1],"").trim('/')
	$ModulePath = "$HOME/WindowsPowerShell/Modules"
}
write-host "`n  my profile path:  $ProfilePath`n  my module path: $ModulePath"