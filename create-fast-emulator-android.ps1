# Android Fast Emulator Creator (Windows PowerShell)

$ErrorActionPreference = "Stop"

$AndroidHome = "C:\Android\Sdk"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"
$AvdName = "Maui_Solo"
$SysImage = "system-images;android-28;google_apis;x86_64"
$DeviceProfile = "pixel_3a"

$env:ANDROID_HOME = $AndroidHome
$env:ANDROID_SDK_ROOT = $AndroidHome
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$AndroidHome\cmdline-tools\latest\bin;$AndroidHome\platform-tools;$AndroidHome\emulator;$env:PATH"

Write-Host "=== Android Fast Emulator Creator (PowerShell) ===" -ForegroundColor Cyan
Write-Host "Using Java: $JavaHome"
Write-Host "Using Android SDK: $AndroidHome"
Write-Host ""

if (-not (Test-Path $AndroidHome)) {
    throw "Android SDK not found at $AndroidHome"
}

$avdManager = Join-Path $AndroidHome "cmdline-tools\latest\bin\avdmanager.bat"
$avdPath = Join-Path $env:USERPROFILE ".android\avd\$AvdName.avd"
$configPath = Join-Path $avdPath "config.ini"

Write-Host "Creating AVD with:" -ForegroundColor Yellow
Write-Host " - Name: $AvdName"
Write-Host " - System Image: $SysImage"
Write-Host " - Device Profile: $DeviceProfile"
Write-Host " - RAM: 4096MB"
Write-Host " - CPU cores: 2"
Write-Host " - GPU: swiftshader_indirect"
Write-Host ""

if (Test-Path $avdPath) {
    Remove-Item $avdPath -Recurse -Force
}

"no" | & $avdManager create avd -n "$AvdName" -k "$SysImage" -d "$DeviceProfile" --force

if ($LASTEXITCODE -ne 0) {
    throw "Failed to create the emulator. Make sure the system image is downloaded."
}

if (-not (Test-Path $configPath)) {
    throw "AVD config not found at $configPath"
}

$config = Get-Content $configPath
$replacements = @{
    "avd.id=.*" = "avd.id=$AvdName"
    "avd.name=.*" = "avd.name=$AvdName"
    "hw.cpu.ncore=.*" = "hw.cpu.ncore=2"
    "hw.ramSize=.*" = "hw.ramSize=4096M"
    "vm.heapSize=.*" = "vm.heapSize=256M"
    "hw.gpu.enabled=.*" = "hw.gpu.enabled=yes"
    "hw.gpu.mode=.*" = "hw.gpu.mode=swiftshader_indirect"
    "hw.keyboard=.*" = "hw.keyboard=yes"
    "hw.audioInput=.*" = "hw.audioInput=no"
    "hw.audioOutput=.*" = "hw.audioOutput=no"
    "hw.camera.back=.*" = "hw.camera.back=none"
    "hw.camera.front=.*" = "hw.camera.front=none"
    "showDeviceFrame=.*" = "showDeviceFrame=no"
    "fastboot.forceColdBoot=.*" = "fastboot.forceColdBoot=yes"
    "fastboot.forceFastBoot=.*" = "fastboot.forceFastBoot=no"
    "firstboot.bootFromDownloadableSnapshot=.*" = "firstboot.bootFromDownloadableSnapshot=no"
    "firstboot.bootFromLocalSnapshot=.*" = "firstboot.bootFromLocalSnapshot=no"
    "firstboot.saveToLocalSnapshot=.*" = "firstboot.saveToLocalSnapshot=no"
}

foreach ($pattern in $replacements.Keys) {
    $config = $config -replace $pattern, $replacements[$pattern]
}

Set-Content -Path $configPath -Value $config -Encoding ASCII

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "Success! Emulator '$AvdName' has been created." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host "To start your new emulator, run:"
Write-Host "  .\start-fast-emulator-avd.ps1"
Write-Host ""
Write-Host "Or manually:"
Write-Host "  emulator -avd $AvdName -gpu swiftshader_indirect -accel on"
Write-Host "=============================================" -ForegroundColor Green
