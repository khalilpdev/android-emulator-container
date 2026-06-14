@echo off
title Start Fast Android Emulator (Windows)

:: Default paths on Windows
set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"
if exist "C:\Program Files\Android\Android Studio\jbr" (
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
) else (
    set "JAVA_HOME=C:\Program Files\Java\jdk-17"
)

set "PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\cmdline-tools\latest\bin;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\emulator;%PATH%"

set "AVD_NAME=Fast_Android_15"

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

echo Launching emulator with GPU acceleration in background...
:: 'start' starts it in a new window so this command line can close/continue
start "" emulator -avd "%AVD_NAME%" -gpu host

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
