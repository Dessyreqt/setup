$unistallPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"

$unistallWow6432Path = "\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"

if (!([Diagnostics.Process]::GetCurrentProcess().Path -match '\\syswow64\\')) {
    @(
        if (Test-Path "HKLM:$unistallWow6432Path" ) { Get-ChildItem "HKLM:$unistallWow6432Path"}
        if (Test-Path "HKLM:$unistallPath" ) { Get-ChildItem "HKLM:$unistallPath" }
        if (Test-Path "HKCU:$unistallWow6432Path") { Get-ChildItem "HKCU:$unistallWow6432Path"}
        if (Test-Path "HKCU:$unistallPath" ) { Get-ChildItem "HKCU:$unistallPath" }
    ) |
    ForEach-Object {
        Get-ItemProperty $_.PSPath
    } |
    Where-Object {
        $_.DisplayName -and !$_.SystemComponent -and !$_.ReleaseType -and !$_.ParentKeyName -and ($_.UninstallString -or $_.NoRemove)
    } |
    Sort-Object DisplayName |
    Select-Object DisplayName, InstallDate, DisplayVersion, Publisher | Format-Table -AutoSize
}