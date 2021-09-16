$baseDir = resolve-path .

function Write-FormattedXml ($path, [xml]$xml)
{
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.OmitXmlDeclaration = $true
    $xmlWriterSettings.Indent = $true
    $xmlWriterSettings.IndentChars = '    '
    $xmlWriter = [System.XML.XmlWriter]::Create($stringWriter, $xmlWriterSettings)
    $xml.WriteContentTo($xmlWriter)
    $xmlWriter.Flush()
    $stringWriter.Flush()
    [System.IO.File]::WriteAllLines($path, $stringWriter.ToString())
}

function Backup-Folder($from, $to, $exclude, $excludeMatch) {
    [regex] $excludeMatchRegEx = '(?i)' + (($excludeMatch | ForEach-Object { [regex]::escape($_) }) -join "|") + ''
    Copy-Item -Path $from -Destination $to -Recurse -Force -Filter {PSIsContainer}
    Get-ChildItem -Path $from -Recurse -Exclude $exclude | 
    Where-Object { $null -eq $excludeMatch -or $_.FullName.Replace($from, "") -notmatch $excludeMatchRegEx } |
    Copy-Item -Destination {
        if ($_.PSIsContainer) {
            Join-Path $to $_.Parent.FullName.Substring($from.length)
        }
        else {
            Join-Path $to $_.FullName.Substring($from.length)
        }
    } -Force -Exclude $exclude -Container
}

function Backup-File($from, $to) {
    mkdir $to | Out-Null
    Copy-Item -Path $from -Destination $to -Force
}

function Remove-BackupData($path) {
    Remove-Item -Recurse -Force $path -ErrorAction SilentlyContinue
}

function Update-NppConfig {
    $configXmlPath = "$baseDir\Notepad++\config.xml"
    $configXml = [xml](Get-Content $configXmlPath)
    
    $findHistoryNode = $configXml.NotepadPlus.FindHistory
    $findHistoryNode.SelectNodes("Path") | ForEach-Object{ $findHistoryNode.RemoveChild($_) } | Out-Null
    $findHistoryNode.SelectNodes("Filter") | ForEach-Object{ $findHistoryNode.RemoveChild($_) } | Out-Null
    $findHistoryNode.SelectNodes("Find") | ForEach-Object{ $findHistoryNode.RemoveChild($_) } | Out-Null
    $findHistoryNode.SelectNodes("Replace") | ForEach-Object{ $findHistoryNode.RemoveChild($_) } | Out-Null

    $historyNode = $configXml.NotepadPlus.History
    $historyNode.SelectNodes("File") | ForEach-Object{ $historyNode.RemoveChild($_) } | Out-Null

    $stylerThemeNode = $configXml.SelectSingleNode("/NotepadPlus/GUIConfigs/GUIConfig[@name='stylerTheme']")
    $stylerThemeNode.path = $stylerThemeNode.path.Replace($env:APPDATA, "%APPDATA%")

    Write-FormattedXml $configXmlPath $configXml
}

function Backup-NppConfig {
    Remove-BackupData ".\Notepad++"
    Backup-Folder "$env:APPDATA\Notepad++" ".\Notepad++" @("session.xml") @("backup")
    Update-NppConfig
}

function Backup-WindowsTerminalConfig {
    Remove-BackupData ".\WindowsTerminal"
    Backup-File "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" ".\WindowsTerminal"
}

function Backup-PowerShell {
    Remove-BackupData ".\PowerShell"
    Backup-File $profile ".\PowerShell"
}

Backup-NppConfig
Backup-WindowsTerminalConfig
Backup-PowerShell

