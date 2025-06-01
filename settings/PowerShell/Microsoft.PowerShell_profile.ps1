Import-Module posh-git

Function Get-LastCommandExecutionTime {
    $history = Get-History
    
    if ($null -eq $history)
    {
        return $null
    }
    
    $lastCommand = $history[-1]
    $executionTime = $lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime
        
    return ("{0:0d ;; }{1:0h ;; }{2:0m ;; }{3:0;;0}{4:\.000s;;s}" -f $executionTime.Days, $executionTime.Hours, $executionTime.Minutes, $executionTime.Seconds, $executionTime.Milliseconds).Trim()
}

function Prompt { 
    $lastExecutionTime = Get-LastCommandExecutionTime
    $prompt = Write-Prompt "[" -ForegroundColor DarkGray
    $prompt += Write-Prompt "$(Get-Date)" -ForegroundColor DarkCyan
    $prompt += Write-Prompt "] " -ForegroundColor DarkGray
    
    if ($null -ne $lastExecutionTime)
    {
        $prompt += Write-Prompt "[" -ForegroundColor DarkGray
        $prompt += Write-Prompt $lastExecutionTime -ForegroundColor Yellow
        $prompt += Write-Prompt "] " -ForegroundColor DarkGray
    }
    
    $prompt += Write-Prompt "$($ExecutionContext.SessionState.Path.CurrentLocation)" -ForegroundColor Green
    $prompt += Write-VcsStatus
    $prompt += Write-Prompt "`r`n>" -ForegroundColor DarkGray
    if ($prompt) {$prompt} else {" "}
}

function ArcPlayers {
    explorer "C:\ProgramData\Archipelago\Players"
}

function ArcHost {
    code "C:\ProgramData\Archipelago\options.yaml"
}

if (Test-Path Alias:Npp) { Remove-Item Alias:Npp }
New-Alias Npp "C:\Program Files\Notepad++\notepad++.exe"

if (Test-Path Alias:GitSummary) { Remove-Item Alias:GitSummary }
New-Alias GitSummary "$env:CodeFolder\Dessyreqt\GitSummary\GitSummary.ps1"

if (Test-Path Alias:IisExpress) { Remove-Item Alias:IisExpress }
New-Alias IisExpress "C:\Program Files\IIS Express\iisexpress.exe"

if (Test-Path Alias:ArcGen) { Remove-Item Alias:ArcGen }
New-Alias ArcGen "C:\ProgramData\Archipelago\ArchipelagoGenerate.exe"

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


