@echo off
title Start Fast Android Emulator (Windows)

:: Default paths on Windows
set "ANDROID_HOME=C:\Android\Sdk"
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.3.9-hotspot"

set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\emulator;%PATH%"

set "AVD_NAME=Maui_Solo"

echo === Starting Fast Android Emulator (%AVD_NAME%) ===
echo.

:: Check if emulator exists by listing and checking with findstr
emulator -list-avds | findstr /x /c:"%AVD_NAME%" >nul
if %ERRORLEVEL% neq 0 (
    echo Error: AVD '%AVD_NAME%' not found.
    echo Run create-fast-emulator-android.bat first!
    pause
    exit /b 1
)

echo Launching emulator with WHPX + software GPU in background...
:: 'start' starts it in a new window so this command line can close/continue
start "" emulator -avd "%AVD_NAME%" -accel on -gpu swiftshader_indirect -no-boot-anim -no-audio -no-snapshot-load -no-snapshot-save -camera-back none -camera-front none -memory 4096 -cores 2

if %ERRORLEVEL% equ 0 (
    echo.
    echo Emulator '%AVD_NAME%' is starting.
    echo You can close this window now.
    timeout /t 5 >nul
) else (
    echo Error: Failed to launch the emulator.
    pause
    exit /b 1
)
