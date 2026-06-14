# Start Pixel 3a API 28 Lite AVD (PowerShell)
# Usage: Open PowerShell as your user and run this script.

$SdkRoot = 'E:\Android\SdkWin'
$JavaHome = 'E:\Android\Android Studio\jbr'
$AvdName = 'Pixel_3a_API_28_Lite_2'

# Set environment for this session
$env:ANDROID_SDK_ROOT = $SdkRoot
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$SdkRoot\cmdline-tools\latest\bin;$SdkRoot\platform-tools;$SdkRoot\emulator;$env:PATH"

Write-Host "Starting AVD: $AvdName (SDK: $SdkRoot)" -ForegroundColor Cyan

# Check acceleration support and launch with optimized args: memory, cores, no boot anim, no audio, no cameras, network full.
$commonArgs = "-avd $AvdName -no-snapshot -no-snapshot-load -no-boot-anim -no-audio -camera-back none -camera-front none -netspeed full -netdelay none -memory 2048 -cores 2"

# Show accel status
& (Join-Path $SdkRoot 'emulator\emulator.exe') -accel-check

# Try GPU host first (better performance). If it fails, try software renderer (swiftshader_indirect).
Try {
    $args = "$commonArgs -gpu host"
    Start-Process -FilePath (Join-Path $SdkRoot 'emulator\emulator.exe') -ArgumentList $args -ErrorAction Stop
    Write-Host "Launched emulator with GPU host." -ForegroundColor Green
} Catch {
    Write-Warning "Falha ao iniciar com GPU host. Tentando com renderizador por software (swiftshader_indirect)..."
    $args = "$commonArgs -gpu swiftshader_indirect"
    Start-Process -FilePath (Join-Path $SdkRoot 'emulator\emulator.exe') -ArgumentList $args
}

Write-Host "Se o emulador travar ou não abrir, verifique HAXM/Hyper-V/Windows Hypervisor Platform e drivers de GPU." -ForegroundColor Yellow
