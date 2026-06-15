# Start Fast Android Emulator (Windows PowerShell)

$ErrorActionPreference = "Stop"

$AndroidHome = "C:\Android\Sdk"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"
$AvdName = "Maui_Solo"

$env:ANDROID_HOME = $AndroidHome
$env:ANDROID_SDK_ROOT = $AndroidHome
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$AndroidHome\emulator;$AndroidHome\platform-tools;$env:PATH"

$emulatorPath = Join-Path $AndroidHome "emulator\emulator.exe"
$avdList = & $emulatorPath -list-avds

if ($avdList -notcontains $AvdName) {
    throw "AVD '$AvdName' not found. Run create-fast-emulator-android.ps1 first."
}

$baseArgs = @(
    "-avd", $AvdName,
    "-accel", "on",
    "-gpu", "swiftshader_indirect",
    "-no-boot-anim",
    "-no-audio",
    "-no-snapshot-load",
    "-no-snapshot-save",
    "-camera-back", "none",
    "-camera-front", "none",
    "-memory", "4096",
    "-cores", "2"
)

Write-Host "Starting $AvdName..." -ForegroundColor Cyan
Write-Host "Using: accel=on, gpu=swiftshader_indirect, memory=4096, cores=2" -ForegroundColor Yellow

try {
    Start-Process -FilePath $emulatorPath -ArgumentList $baseArgs -ErrorAction Stop
    Write-Host "Emulator launched." -ForegroundColor Green
} catch {
    Write-Warning "Falha com accel=on. Tentando CPU puro com a mesma GPU por software..."
    $fallbackArgs = @(
        "-avd", $AvdName,
        "-accel", "off",
        "-gpu", "swiftshader_indirect",
        "-no-boot-anim",
        "-no-audio",
        "-no-snapshot-load",
        "-no-snapshot-save",
        "-camera-back", "none",
        "-camera-front", "none",
        "-memory", "4096",
        "-cores", "2"
    )
    Start-Process -FilePath $emulatorPath -ArgumentList $fallbackArgs -ErrorAction Stop
    Write-Host "Emulator launched in fallback mode." -ForegroundColor Green
}
