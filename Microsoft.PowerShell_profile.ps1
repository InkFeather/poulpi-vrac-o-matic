Register-ArgumentCompleter -Native -CommandName nuke -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        nuke :complete "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

function prompt {
    Write-Host("[$Env:username@$($env:COMPUTERNAME)]") -nonewline -foregroundcolor Gray
	Write-Host(" (∩``-´)⊃") -nonewline -foregroundcolor Red
	Write-Host("━☆ﾟ.*･｡ﾟ ") -nonewline -foregroundcolor DarkCyan
	Write-Host("$PWD>") -nonewline -foregroundcolor Blue
    return " "
}

function Edit-Profile {
   if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
   notepad++ $PROFILE
}

function Set-Revoli-Dev {
	wt -w 0 new-tab --title "Revoli - Git" --suppressApplicationTitle --tabColor "#6699FF" #Set-Git-Env -environment Revoli
	wt -w 0 new-tab --title "Revoli - Nuke" --suppressApplicationTitle --tabColor "#FF9900" #Set-Revoli-Location
	wt -w 0 new-tab --title "Céréales - Watch" --suppressApplicationTitle --tabColor "#CC0000" #Launch-Cereales-Watch
	wt -w 0 new-tab --title "Legacy - Web" --suppressApplicationTitle --tabColor "#009933" #Launch-Legacy-Web
	wt -w 0 new-tab --title "Ordonnanceur" --suppressApplicationTitle --tabColor "#FFB580" #Launch-Ordonnanceur
	wt -w 0 new-tab --title "Extranet - Git" --suppressApplicationTitle --tabColor "#00BAA8" #Set-Git-Env -environment Extranet
	wt -w 0 new-tab --title "Extranet - Watch" --suppressApplicationTitle --tabColor "#A30065" #Launch-Extranet-Watch
}

function Set-Revoli-Location {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)
   
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\revoliWT\d' }
		'main' { 'C:\dev\git\revoliWT\m' }
		'nextProd' { 'C:\dev\git\revoliWT\n' }
		default { 'C:\dev\git\revoli' }
	}
   
	Set-Location $location
	Clear-Host
}

function Set-Extranet-Location {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev')]
		[string]$worktree
	)
	
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\extranetWT\d' }
		default { 'C:\dev\git\extranet' }
	}
	
	Set-Location $location
	Clear-Host
}

function Set-Git-Env {
	param(
		[parameter(Mandatory=$true)]
		[ValidateSet('Revoli','Extranet')]
		[string]$environment,
	  
		[parameter(Mandatory=$false)]
		[string]$theme='powerlevel10k_rainbow',

		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)

   import-module posh-git
   import-module oh-my-posh
   Set-PoshPrompt -Theme $theme

   If($environment -eq 'Revoli')
   {
	   if ($worktree -ne '') { Set-Revoli-Location -worktree $worktree }
	   else { Set-Revoli-Location }
	   Git-Update-Full
   }
   Elseif($environment -eq 'Extranet')
   {
	   Set-Extranet-Location
	   
	   Write-Host 'Synchronisation des branches' -ForegroundColor Blue
	   git fetch -p
	   
	   Write-Host 'Mise à jour de la branche de travail' -ForegroundColor Green
	   git pull

	   Set-Location ../ExtranetWT/d
	   Write-Host 'Mise à jour de la branche Dev' -ForegroundColor Green
	   git pull
	   
	   if ($worktree -ne '') { Set-Extranet-Location -worktree $worktree }
	   else { Set-Extranet-Location }
   }

   Clear-Host
}

function Git-Update-Full {
   $currentLocation = Get-Location
   
   Set-Location C:\dev\git\revoli
   Write-Host 'Synchronisation des branches' -ForegroundColor Blue
   git fetch -p
   
   Write-Host 'Mise à jour de la branche de travail' -ForegroundColor Green
   git pull

   Set-Location C:\dev\git\RevoliWT\d
   Write-Host 'Mise à jour de la branche Dev' -ForegroundColor Green
   git pull

   Set-Location C:\dev\git\RevoliWT\m
   Write-Host 'Mise à jour de la branche Main' -ForegroundColor Green
   git pull

   Set-Location C:\dev\git\RevoliWT\n
   Write-Host 'Mise à jour de la branche NextProd' -ForegroundColor Green
   git pull

   Set-Location $currentLocation
}

function Launch-Legacy-Web {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)
	
    Clear-Host
	
    $location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\revoliWT\d\revoli\.vs\Revoli.Core\config\applicationhost.config' }
		'main' { 'C:\dev\git\revoliWT\m\revoli\.vs\Revoli.Core\config\applicationhost.config' }
		'nextProd' { 'C:\dev\git\revoliWT\n\revoli\.vs\Revoli.Core\config\applicationhost.config' }
		default { 'C:\DEV\GIT\Revoli\Revoli\.vs\Revoli.Core\config\applicationhost.config' }
	}

    ."C:\Program Files (x86)\IIS Express\iisexpress.exe" /config:$location /site:"Web" /apppool:"Clr4IntegratedAppPool"
}

function Compile-Legacy-Typescript {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)
	
	Clear-Host
   
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\revoliWT\d\revoli\web' }
		'main' { 'C:\dev\git\revoliWT\m\revoli\web' }
		'nextProd' { 'C:\dev\git\revoliWT\n\revoli\web' }
		default { 'C:\dev\git\revoli\revoli\web' }
	}

	Set-Location $location
	./TypeScriptCompil
}

function Launch-Ordonnanceur {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)
	
	Clear-Host
   
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\revoliWT\d\revoli\Build\Debug\net48' }
		'main' { 'C:\dev\git\revoliWT\m\revoli\Build\Debug\net48' }
		'nextProd' { 'C:\dev\git\revoliWT\n\revoli\Build\Debug\net48' }
		default { 'C:\dev\git\revoli\revoli\Build\Debug\net48' }
	}

	Set-Location $location
	./Ordonnanceur
}

function Launch-Cereales-Watch {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev','main','nextProd')]
		[string]$worktree
	)
	
	Clear-Host
   
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\revoliWT\d\revoli\Web.Cereales\AngularSources' }
		'main' { 'C:\dev\git\revoliWT\m\revoli\Web.Cereales\AngularSources' }
		'nextProd' { 'C:\dev\git\revoliWT\n\revoli\Web.Cereales\AngularSources' }
		default { 'C:\dev\git\revoli\revoli\Web.Cereales\AngularSources' }
	}

   Set-Location $location
   ./Watch
}

function Launch-Extranet-Watch {
	param( 
		[parameter(Mandatory=$false)]
		[ValidateSet('dev')]
		[string]$worktree
	)
	
	$location = switch ($worktree)
	{
		'dev' { 'C:\dev\git\extranetWT\d\extranet\ExtranetWeb.Core\ClientApp' }
		default { 'C:\dev\git\extranet\extranet\ExtranetWeb.Core\ClientApp' }
	}
	
	Clear-Host
   
	Set-Location $location
	npm install --no-save && npm start
}
