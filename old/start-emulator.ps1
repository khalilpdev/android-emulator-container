# Script para iniciar o emulador Android otimizado
$sdkRoot = "E:\android\Sdk"
$studioRoot = "E:\android\Android Studio"
$javaHome = Join-Path $studioRoot "jbr"
$avdName = "Pixel_3a_API_28_Lite"

$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $sdkRoot
$env:ANDROID_SDK_ROOT = $sdkRoot
$env:PATH = "$javaHome\bin;$sdkRoot\platform-tools;$sdkRoot\emulator;$env:PATH"

$emulatorPath = Join-Path $sdkRoot "emulator\emulator.exe"
$arguments = @(
    "-avd", $avdName,
    "-gpu", "swiftshader_indirect",
    "-accel", "on",
    "-no-boot-anim",
    "-noaudio",
    "-camera-back", "none",
    "-camera-front", "none",
    "-no-snapshot-load",
    "-no-snapshot-save"
)

Write-Host "=== Iniciando Emulador Android Otimizado: $avdName ===" -ForegroundColor Green
Start-Process -FilePath $emulatorPath -ArgumentList $arguments
Write-Host "O emulador esta iniciando com WHPX e GPU SwiftShader." -ForegroundColor Cyan
