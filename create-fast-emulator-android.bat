@echo off
title Android Fast Emulator Creator (Windows)

:: Default paths on Windows
set "ANDROID_HOME=%LOCALAPPDATA%\Android\Sdk"

:: Try to find Android Studio Java Runtime
if exist "C:\Program Files\Android\Android Studio\jbr" (
    set "JAVA_HOME=C:\Program Files\Android\Android Studio\jbr"
) else (
    :: Fallback if they have JDK installed or customized
    set "JAVA_HOME=C:\Program Files\Java\jdk-17"
)

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
set "AVD_NAME=Fast_Android_15"
set "SYS_IMAGE=system-images;android-35;google_apis_playstore;x86_64"
set "DEVICE_PROFILE=pixel_6"

echo Creating AVD with:
echo  - Name: %AVD_NAME%
echo  - System Image: %SYS_IMAGE%
echo  - Device Profile: %DEVICE_PROFILE%
echo.

:: Create the AVD (piping "no" to bypass custom hardware profile prompt)
echo no| avdmanager create avd -n "%AVD_NAME%" -k "%SYS_IMAGE%" -d "%DEVICE_PROFILE%" --force

if %ERRORLEVEL% equ 0 (
    echo.
    echo =============================================
    echo Success! Emulator '%AVD_NAME%' has been created.
    echo =============================================
    echo To start your new emulator, run:
    echo   start-fast-emulator-avd.bat
    echo.
    echo Or manually run:
    echo   emulator -avd %AVD_NAME% -gpu host
    echo =============================================
) else (
    echo.
    echo Error: Failed to create the emulator. 
    echo Make sure the system image is downloaded in Android Studio or via sdkmanager:
    echo   sdkmanager "%SYS_IMAGE%"
)

pause
