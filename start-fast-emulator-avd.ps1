# Start Fast Android Emulator (Windows PowerShell)

$AndroidHome = "E:\Android\Sdkwin"
$JavaHome = "C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

$env:ANDROID_HOME = $AndroidHome
$env:JAVA_HOME = $JavaHome
$env:PATH = "$JavaHome\bin;$AndroidHome\emulator;$env:PATH"

$AvdName = "Fast_Android_34"

Write-Host "Starting $AvdName..." -ForegroundColor Cyan
& "$AndroidHome\emulator\emulator.exe" -avd $AvdName -no-boot-anim -no-audio -gpu off -no-accel
