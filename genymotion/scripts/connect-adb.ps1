param(
    [string]$Target = "127.0.0.1:5555"
)

$ErrorActionPreference = "Stop"

$adb = "adb"
if ($env:ANDROID_HOME) {
    $candidate = Join-Path $env:ANDROID_HOME "platform-tools\adb.exe"
    if (Test-Path $candidate) {
        $adb = $candidate
    }
}

Write-Host "Connecting to $Target..." -ForegroundColor Cyan
& $adb connect $Target
& $adb devices -l
