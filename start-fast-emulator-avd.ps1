# Start Fast Android Emulator (Windows PowerShell)

$AndroidHome = "E:\Android\Sdkwin"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

$env:ANDROID_HOME = $AndroidHome
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$AndroidHome\emulator;$env:PATH"

$AvdName = "Pixel_3a_API_28_Lite_2"

Write-Host "Starting $AvdName..." -ForegroundColor Cyan
& "$AndroidHome\emulator\emulator.exe" -avd $AvdName -gpu off -accel auto
