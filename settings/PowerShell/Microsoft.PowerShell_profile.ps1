Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

function Prompt { 
    $prompt = Write-Prompt "[" -ForegroundColor DarkGray
    $prompt += Write-Prompt "$(Get-Date)" -ForegroundColor DarkCyan
    $prompt += Write-Prompt "] " -ForegroundColor DarkGray
    $prompt += Write-Prompt "$($ExecutionContext.SessionState.Path.CurrentLocation)" -ForegroundColor Green
    $prompt += Write-VcsStatus
    $prompt += Write-Prompt "`r`n>" -ForegroundColor DarkGray
    if ($prompt) {$prompt} else {" "}
}

New-Alias Npp "C:\Program Files\Notepad++\notepad++.exe"
New-Alias GitSummary "$env:CodeFolder\Dessyreqt\GitSummary\GitSummary.ps1"
New-Alias IisExpress "C:\Program Files\IIS Express\iisexpress.exe"

function Cover {
	param([string]$path)
	& "C:\apps\dotCover\dotCover.exe" cover --targetExecutable="C:\Program Files\dotnet\dotnet.exe" --output="C:\CoverageReport\CoverageReport.html" --reportType=HTML -- test $path
	Invoke-Item "C:\CoverageReport\CoverageReport.html"
}

function CoverFeatures {
	param([string]$path)
	& "C:\apps\dotCover\dotCover.exe" cover --targetExecutable="C:\Program Files\dotnet\dotnet.exe" --output="C:\CoverageReport\CoverageReport.html" --reportType=HTML --filters="+:type=*.Features.*;-:type=*.Tests.Features.*;-:type=*Controller" -- test $path
	Invoke-Item "C:\CoverageReport\CoverageReport.html"
}

# PowerShell parameter completion shim for the dotnet CLI 
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

Register-ArgumentCompleter -Native -CommandName nuke -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        nuke :complete "$wordToComplete" | ForEach-Object {
           [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


