New-Alias Npp "C:\Program Files\Notepad++\notepad++.exe"
New-Alias GitSummary "$env:CodeFolder\Dessyreqt\GitSummary\GitSummary.ps1"
New-Alias IisExpress "C:\Program Files\IIS Express\iisexpress.exe"

function Cover {
	param([string]$path)
	& "C:\apps\dotCover\dotCover.exe" cover --targetExecutable="C:\Program Files\dotnet\dotnet.exe" --output="C:\CoverageReport\CoverageReport.html" --reportType=HTML -- test $path
	Invoke-Item "C:\CoverageReport\CoverageReport.html"
}

function CoverFeatures {
	param([string]$path)
	& "C:\apps\dotCover\dotCover.exe" cover --targetExecutable="C:\Program Files\dotnet\dotnet.exe" --output="C:\CoverageReport\CoverageReport.html" --reportType=HTML --filters="+:type=*.Features.*;-:type=*.Tests.Features.*;-:type=*Controller" -- test $path
	Invoke-Item "C:\CoverageReport\CoverageReport.html"
}
