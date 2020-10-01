$base_dir = resolve-path .

function Format-XML ([xml]$xml)
{
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.OmitXmlDeclaration = $true
    $xmlWriterSettings.Indent = $true
    $xmlWriter = [System.XML.XmlWriter]::Create($stringWriter, $xmlWriterSettings)
    $xml.WriteContentTo($xmlWriter)
    $xmlWriter.Flush()
    $stringWriter.Flush()
    Write-Output $stringWriter.ToString()
}

# Backup-Data "$env:APPDATA\Notepad++" ".\Notepad++" @("session.xml") @("backup") # Sample usage
function Backup-Data($from, $to, $exclude, $excludeMatch) {
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

function Remove-NppConfig {
    Remove-Item -Recurse -Force ".\Notepad++" -ErrorAction SilentlyContinue
}

# Keeping for now as example of how to work with xml
function Update-NppConfig {
    $configXmlPath = "$base_dir\Notepad++\config.xml"
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

    $configXml.Save($configXmlPath)
    Format-XML $configXml | Out-File $configXmlPath
}

function Backup-NppConfig() {
    Remove-NppConfig

    mkdir ".\Notepad++\themes" | Out-Null
    Copy-Item -Path "$env:APPDATA\Notepad++\themes\VS2012-Dark.xml" -Destination ".\Notepad++\themes" -Force

    # Update-NppConfig
}

Backup-NppConfig