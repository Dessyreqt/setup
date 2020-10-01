function Restore-Npp {
    $from = ".\Notepad++"
    $to = "$env:appdata"
    Copy-Item -Path $from -Destination $to -Recurse -Force -Container
}

Restore-Npp
