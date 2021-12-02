Clear-Host
Write-Host "Lock screen avoider ..."

$WShell = New-Object -com "Wscript.Shell"
$sleep = 30

while ($true) {
    $WShell.sendkeys("{SCROLLLOCK}")
    Start-Sleep -Milliseconds 100
    $WShell.sendkeys("{SCROLLLOCK}")
    Start-Sleep -Seconds $sleep
}
