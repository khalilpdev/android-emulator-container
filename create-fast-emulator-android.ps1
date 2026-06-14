# Android Fast Emulator Creator (Windows PowerShell)

$AndroidHome = "$env:LOCALAPPDATA\Android\Sdk"
$JavaHome = "C:\Program Files\Android\Android Studio\jbr"

if (-not (Test-Path $JavaHome)) {
    $JavaHome = "C:\Program Files\Java\jdk-17"
}

# Update PATH for this session
$env:PATH = "$JavaHome\bin;$AndroidHome\cmdline-tools\latest\bin;$AndroidHome\platform-tools;$AndroidHome\emulator;$env:PATH"

Write-Host "=== Android Fast Emulator Creator (PowerShell) ===" -ForegroundColor Cyan
Write-Host "Using Java: $JavaHome"
Write-Host "Using Android SDK: $AndroidHome"
Write-Host ""

if (-not (Test-Path $AndroidHome)) {
    Write-Error "Android SDK not found at $AndroidHome"
    return
}

$AvdName = "Fast_Android_15"
$SysImage = "system-images;android-35;google_apis_playstore;x86_64"
$DeviceProfile = "pixel_6"

Write-Host "Creating AVD with:"
Write-Host " - Name: $AvdName"
Write-Host " - System Image: $SysImage"
Write-Host " - Device Profile: $DeviceProfile"
Write-Host ""

# Pipe "no" to bypass custom hardware profile prompt
"no" | avdmanager create avd -n $AvdName -k $SysImage -d $DeviceProfile --force

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "Success! Emulator '$AvdName' has been created." -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "To start your new emulator, run:"
    Write-Host "  .\start-fast-emulator-avd.ps1"
    Write-Host ""
    Write-Host "Or manually:"
    Write-Host "  emulator -avd $AvdName -gpu host"
    Write-Host "=============================================" -ForegroundColor Green
} else {
    Write-Error "Failed to create the emulator. Make sure the system image is downloaded."
}
