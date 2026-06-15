@echo off
title Android Fast Emulator Creator (Windows)

:: Default paths on Windows
set "ANDROID_HOME=C:\Android\Sdk"
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

:: Add directories to PATH
set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\emulator;%PATH%"

echo === Android Fast Emulator Creator (Windows) ===
echo Using Java: %JAVA_HOME%
echo Using Android SDK: %ANDROID_HOME%
echo.

:: Check if SDK is available
if not exist "%ANDROID_HOME%" (
    echo Error: Android SDK not found at %ANDROID_HOME%
    echo Please make sure Android Studio / SDK is installed.
    pause
    exit /b 1
)

:: Define default emulator options
set "AVD_NAME=Maui_Solo"
set "SYS_IMAGE=system-images;android-28;google_apis;x86_64"
set "DEVICE_PROFILE=pixel_3a"

echo Creating AVD with:
echo  - Name: %AVD_NAME%
echo  - System Image: %SYS_IMAGE%
echo  - Device Profile: %DEVICE_PROFILE%
echo  - RAM: 4096MB
echo  - CPU cores: 2
echo  - GPU: swiftshader_indirect
echo.

:: Create the AVD (piping "no" to bypass custom hardware profile prompt)
if exist "%USERPROFILE%\.android\avd\%AVD_NAME%.avd" (
    rmdir /s /q "%USERPROFILE%\.android\avd\%AVD_NAME%.avd"
)

echo no| avdmanager create avd -n "%AVD_NAME%" -k "%SYS_IMAGE%" -d "%DEVICE_PROFILE%" --force

if exist "%USERPROFILE%\.android\avd\%AVD_NAME%.avd\config.ini" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$p = '%USERPROFILE%\.android\avd\%AVD_NAME%.avd\config.ini';" ^
        "$c = Get-Content $p;" ^
        "$map = @{ 'hw.cpu.ncore=.*'='hw.cpu.ncore=2'; 'hw.ramSize=.*'='hw.ramSize=4096M'; 'vm.heapSize=.*'='vm.heapSize=256M'; 'hw.gpu.enabled=.*'='hw.gpu.enabled=yes'; 'hw.gpu.mode=.*'='hw.gpu.mode=swiftshader_indirect'; 'hw.audioInput=.*'='hw.audioInput=no'; 'hw.audioOutput=.*'='hw.audioOutput=no'; 'hw.camera.back=.*'='hw.camera.back=none'; 'hw.camera.front=.*'='hw.camera.front=none'; 'showDeviceFrame=.*'='showDeviceFrame=no'; 'fastboot.forceColdBoot=.*'='fastboot.forceColdBoot=yes'; 'fastboot.forceFastBoot=.*'='fastboot.forceFastBoot=no' };" ^
        "foreach ($k in $map.Keys) { $c = $c -replace $k, $map[$k] };" ^
        "Set-Content -Path $p -Value $c -Encoding ASCII"
)

if %ERRORLEVEL% equ 0 (
    echo.
    echo =============================================
    echo Success! Emulator '%AVD_NAME%' has been created.
    echo =============================================
    echo To start your new emulator, run:
    echo   start-fast-emulator-avd.bat
    echo.
    echo Or manually run:
    echo   emulator -avd %AVD_NAME% -gpu swiftshader_indirect -accel on
    echo =============================================
) else (
    echo.
    echo Error: Failed to create the emulator. 
    echo Make sure the system image is downloaded in Android Studio or via sdkmanager:
    echo   sdkmanager "%SYS_IMAGE%"
)

pause
