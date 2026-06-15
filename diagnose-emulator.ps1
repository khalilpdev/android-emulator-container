# Android Emulator Diagnostics for Windows 10

Write-Host "=== ANDROID EMULATOR DIAGNOSTICS ===" -ForegroundColor Cyan
Write-Host "Windows 10 + Virtualization Check`n"

$env:ANDROID_HOME = "C:\Android\Sdk"

Write-Host "1. Emulator Acceleration Check:" -ForegroundColor Yellow
$accelCheck = & "$env:ANDROID_HOME\emulator\emulator.exe" -accel-check 2>&1
Write-Host $accelCheck
Write-Host ""

if ($accelCheck -match "WHPX.*usable") {
    Write-Host "✅ WHPX (Windows Hypervisor) está disponível!" -ForegroundColor Green
    Write-Host "   Use: -accel on + -gpu swiftshader_indirect" -ForegroundColor Cyan
} elseif ($accelCheck -match "0") {
    Write-Host "⚠️  WHPX não está usável" -ForegroundColor Yellow
    Write-Host "   Soluções:" -ForegroundColor Cyan
    Write-Host "   a) Ativar Hyper-V: dism /Online /Enable-Feature /FeatureName:Microsoft-Hyper-V /All" -ForegroundColor Yellow
    Write-Host "   b) Verificar BIOS: VT-x/AMD-V deve estar habilitado" -ForegroundColor Yellow
    Write-Host "   c) Usar pure CPU: -accel off (mais lento, mas funciona)" -ForegroundColor Yellow
}

Write-Host "`n2. System Information:" -ForegroundColor Yellow
$sysinfo = systeminfo 2>&1 | Select-String "Processor|Physical Memory|Hyper-V"
Write-Host $sysinfo

Write-Host "`n3. Memory para AVD (recomendado):" -ForegroundColor Yellow
$ram = (Get-WmiObject CIM_PhysicalMemory -ErrorAction SilentlyContinue | Measure-Object -Property Capacity -Sum).Sum / 1GB
Write-Host "   RAM Total: $([math]::Round($ram))GB" -ForegroundColor Cyan
if ($ram -ge 8) {
    Write-Host "   ✅ Recomendado: hw.ramSize=3072M, 2 cores, GPU swiftshader_indirect" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  RAM baixa - usar hw.ramSize=2048M e GPU por software" -ForegroundColor Yellow
}

Write-Host "`n4. Sugestão de inicialização:" -ForegroundColor Yellow
if ($accelCheck -match "WHPX.*usable") {
    Write-Host "   & `"$env:ANDROID_HOME\emulator\emulator.exe`" -avd Maui_Perf -accel on -gpu swiftshader_indirect -memory 3072 -cores 2" -ForegroundColor Cyan
} else {
    Write-Host "   & `"$env:ANDROID_HOME\emulator\emulator.exe`" -avd Maui_Perf -accel off -gpu swiftshader_indirect -memory 3072 -cores 2" -ForegroundColor Cyan
}
