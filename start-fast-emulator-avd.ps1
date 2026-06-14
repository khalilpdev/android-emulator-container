# Start Fast Android Emulator (Windows PowerShell)

$AndroidHome = "E:\Android\Sdkwin"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

$env:ANDROID_HOME = $AndroidHome
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$AndroidHome\emulator;$env:PATH"

$AvdName = "Maui_Dev_3GB"

Write-Host "Starting $AvdName..." -ForegroundColor Cyan
Write-Host "Checking acceleration..." -ForegroundColor Yellow

$accel = & "$AndroidHome\emulator\emulator.exe" -accel-check 2>&1
if ($accel -match "WHPX.*usable") {
    Write-Host "✅ Using WHPX acceleration" -ForegroundColor Green
    & "$AndroidHome\emulator\emulator.exe" -avd $AvdName -accel whpx -no-boot-anim -no-audio -gpu off
} else {
    Write-Host "⚠️  Using CPU (no acceleration available)" -ForegroundColor Yellow
    Write-Host "   For faster emulator, enable Hyper-V in Windows" -ForegroundColor Gray
    & "$AndroidHome\emulator\emulator.exe" -avd $AvdName -accel off -no-boot-anim -no-audio -gpu off
}
