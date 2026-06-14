# Start Fast Android Emulator (Windows PowerShell)

$AndroidHome = "$env:LOCALAPPDATA\Android\Sdk"
$JavaHome = "C:\Program Files\Android\Android Studio\jbr"

if (-not (Test-Path $JavaHome)) {
    $JavaHome = "C:\Program Files\Java\jdk-17"
}

$env:PATH = "$JavaHome\bin;$AndroidHome\cmdline-tools\latest\bin;$AndroidHome\platform-tools;$AndroidHome\emulator;$env:PATH"

$AvdName = "Fast_Android_15"

Write-Host "=== Starting Fast Android Emulator ($AvdName) ===" -ForegroundColor Cyan

$Avds = emulator -list-avds
if ($Avds -notcontains $AvdName) {
    Write-Error "AVD '$AvdName' not found. Run create-fast-emulator-android.ps1 first!"
    return
}

Write-Host "Launching emulator with GPU acceleration..."
Start-Process emulator -ArgumentList "-avd $AvdName -gpu host"

if ($?) {
    Write-Host "Emulator '$AvdName' is starting." -ForegroundColor Green
} else {
    Write-Error "Failed to launch the emulator."
}
