function Format-XML ([xml]$xml, $indent=2)
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
    Write-Output $stringWriter.ToString()
}

function Update-NppConfig {
    $configXmlPath = "$env:APPDATA\Notepad++\config.xml"
    $configXml = [xml](Get-Content $configXmlPath)

    $stylerThemeNode = $configXml.SelectSingleNode("/NotepadPlus/GUIConfigs/GUIConfig[@name='stylerTheme']")
    $stylerThemeNode.path = "$env:APPDATA\Notepad++\themes\VS2012-Dark.xml"

    [System.IO.File]::WriteAllLines($configXmlPath, (Format-XML $configXml))
}

function Restore-NppConfig {
    $from = ".\Notepad++"
    $to = "$env:appdata"
    Copy-Item -Path $from -Destination $to -Recurse -Force -Container

    Update-NppConfig
}

Restore-NppConfig
