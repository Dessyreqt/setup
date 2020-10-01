function Remove-Npp {
    Remove-Item -Recurse -Force ".\Notepad++" -ErrorAction SilentlyContinue
}

function Backup-Npp {
    $from = "$env:appdata\Notepad++"
    $to = ".\Notepad++"
    $exclude = @("") # @("main.js")
    $excludeMatch = @("backup") # @("app1", "app2", "app3")
    [regex] $excludeMatchRegEx = '(?i)' + (($excludeMatch | foreach { [regex]::escape($_) }) -join "|") + ''
    Copy-Item -Path $from -Destination $to -Recurse -Force -Filter {PSIsContainer}
    Get-ChildItem -Path $from -Recurse -Exclude $exclude | 
    Where-Object { $excludeMatch -eq $null -or $_.FullName.Replace($from, "") -notmatch $excludeMatchRegEx } |
    Copy-Item -Destination {
        if ($_.PSIsContainer) {
            Join-Path $to $_.Parent.FullName.Substring($from.length)
        }
        else {
            Join-Path $to $_.FullName.Substring($from.length)
        }
    } -Force -Exclude $exclude -Container
}

Remove-Npp
Backup-Npp