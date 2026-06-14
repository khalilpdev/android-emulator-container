# Android Fast Emulator Creator (Windows PowerShell)

$AndroidHome = "E:\Android\Sdkwin"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

# Set JAVA_HOME environment variable
$env:JAVA_HOME = $JavaHome

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

$AvdName = "Android_28_Fast"
$SysImage = "system-images;android-28;google_apis;x86_64"
$DeviceProfile = "pixel"

Write-Host "Creating AVD with:"
Write-Host " - Name: $AvdName"
Write-Host " - System Image: $SysImage"
Write-Host " - Device Profile: $DeviceProfile"
Write-Host ""

# Pipe "no" to bypass custom hardware profile prompt
"no" | avdmanager create avd -n "$AvdName" -k "$SysImage" -d "$DeviceProfile" --force

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
