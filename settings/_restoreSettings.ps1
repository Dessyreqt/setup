$baseDir = resolve-path .

function Set-EnvironmentVariables {
    $codeFolder = resolve-path $baseDir\..\..\..
    setx CodeFolder $codeFolder | Out-Null
    $env:CodeFolder = $codeFolder
}

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

function Restore-Folder($from, $to) {
    Copy-Item -Path "$from\*" -Destination $to -Recurse -Force -Container
}

function Restore-File($from, $to) {
    Copy-Item -Path $from -Destination $to -Force
}

function Update-NppConfig {
    $configXmlPath = "$env:APPDATA\Notepad++\config.xml"
    $configXml = [xml](Get-Content $configXmlPath)

    $stylerThemeNode = $configXml.SelectSingleNode("/NotepadPlus/GUIConfigs/GUIConfig[@name='stylerTheme']")
    $stylerThemeNode.path = "$env:APPDATA\Notepad++\themes\VS2012-Dark.xml"

    Write-FormattedXml $configXmlPath $configXml
}

function Restore-NppConfig {
    Restore-Folder ".\Notepad++" "$env:appdata\Notepad++" 
    Update-NppConfig
}

function Restore-WindowsTerminalConfig {
    Restore-Folder ".\WindowsTerminalConfig" "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
}

function Restore-PowerShell {
    Restore-File ".\PowerShell\Microsoft.PowerShell_profile.ps1" $profile
    . $profile
}

Set-EnvironmentVariables
Restore-NppConfig
Restore-WindowsTerminalConfig
Restore-PowerShell
