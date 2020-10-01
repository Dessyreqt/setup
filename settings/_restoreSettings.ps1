function Format-XML ([xml]$xml, $indent=2)
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

function Update-NppConfig {
    $configXmlPath = "$env:APPDATA\Notepad++\config.xml"
    $configXml = [xml](Get-Content $configXmlPath)

    $stylerThemeNode = $configXml.SelectSingleNode("/NotepadPlus/GUIConfigs/GUIConfig[@name='stylerTheme']")
    $stylerThemeNode.path = $stylerThemeNode.path.Replace("%APPDATA%", $env:APPDATA)

    $configXml.Save($configXmlPath)
    Format-XML $configXml -indent 4 | Out-File $configXmlPath
}

function Restore-NppConfig {
    $from = ".\Notepad++"
    $to = "$env:appdata"
    Copy-Item -Path $from -Destination $to -Recurse -Force -Container

    Update-NppConfig
}

Restore-NppConfig
