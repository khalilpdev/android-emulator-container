$ErrorActionPreference = "Stop"

$sdkRoot = "E:\android\Sdk"
$studioRoot = "E:\android\Android Studio"
$javaHome = Join-Path $studioRoot "jbr"
$avdName = "Pixel_3a_API_28_Lite"
$packageId = "system-images;android-28;google_apis;x86_64"
$deviceId = "pixel_3a"

$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $sdkRoot
$env:ANDROID_SDK_ROOT = $sdkRoot
$env:PATH = "$javaHome\bin;$sdkRoot\platform-tools;$sdkRoot\emulator;$env:PATH"

$avdManager = Join-Path $sdkRoot "cmdline-tools\latest\bin\avdmanager.bat"
$configPath = Join-Path $env:USERPROFILE ".android\avd\$avdName.avd\config.ini"

try {
    & $avdManager delete avd -n $avdName | Out-Null
} catch {
}

"no" | & $avdManager create avd -n $avdName -k $packageId -g "google_apis" -d $deviceId --force

if (-not (Test-Path $configPath)) {
    throw "Config do AVD nao encontrada em $configPath"
}

$config = Get-Content $configPath
$replacements = @{
    "avd.id=.*" = "avd.id=$avdName"
    "avd.name=.*" = "avd.name=$avdName"
    "hw.cpu.ncore=.*" = "hw.cpu.ncore=2"
    "hw.ramSize=.*" = "hw.ramSize=1024M"
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
Write-Host "AVD $avdName recriado e otimizado."
