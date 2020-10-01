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

function Remove-NppConfig {
    Remove-Item -Recurse -Force ".\Notepad++" -ErrorAction SilentlyContinue
}

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

function Backup-NppConfig {
    Remove-NppConfig

    $from = "$env:APPDATA\Notepad++"
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

    Update-NppConfig
}

Backup-NppConfig