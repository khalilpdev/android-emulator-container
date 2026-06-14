#!/bin/bash

# Configuration and Paths (ensures it works even if run from desktop or cron without full .bashrc)
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/media/leandro/DADOS/AndroidStudio/android-studio/jbr"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

AVD_NAME="Fast_Android_15"

echo "=== Starting Fast Android Emulator ($AVD_NAME) ==="

# Check if emulator exists
if ! emulator -list-avds | grep -q "^$AVD_NAME$"; then
    echo "Error: AVD '$AVD_NAME' not found. Run ~/create-fast-emulator-android.sh first!"
    exit 1
fi

# Start the emulator with hardware acceleration
echo "Launching emulator with GPU acceleration and KVM..."
emulator -avd "$AVD_NAME" -gpu host -qemu -enable-kvm > /dev/null 2>&1 &

if [ $? -eq 0 ]; then
    echo "Emulator '$AVD_NAME' is starting in the background."
    echo "You can close this terminal or use it for other tasks."
else
    echo "Error: Failed to launch the emulator."
    exit 1
fi
