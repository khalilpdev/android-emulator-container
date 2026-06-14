#!/bin/bash

# Configuration and Paths
export ANDROID_HOME="$HOME/Android/Sdk"
export JAVA_HOME="/media/leandro/DADOS/AndroidStudio/android-studio/jbr"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

echo "=== Android Fast Emulator Creator ==="
echo "Using Java from Android Studio: $JAVA_HOME"
echo "Using Android SDK: $ANDROID_HOME"

# Check if SDK is available
if [ ! -d "$ANDROID_HOME" ]; then
    echo "Error: Android SDK not found at $ANDROID_HOME"
    exit 1
fi

# Define default emulator options
AVD_NAME="Fast_Android_15"
SYS_IMAGE="system-images;android-35;google_apis_playstore;x86_64"
DEVICE_PROFILE="pixel_6"

echo ""
echo "Creating AVD with:"
echo " - Name: $AVD_NAME"
echo " - System Image: $SYS_IMAGE"
echo " - Device Profile: $DEVICE_PROFILE"
echo ""

# Create the AVD (echo "no" to bypass custom hardware profile prompt)
echo "no" | avdmanager create avd -n "$AVD_NAME" -k "$SYS_IMAGE" -d "$DEVICE_PROFILE" --force

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================="
    echo "Success! Emulator '$AVD_NAME' has been created."
    echo "============================================="
    echo "To start your new emulator, run:"
    echo "  emulator -avd $AVD_NAME -gpu host -qemu -enable-kvm"
    echo ""
    echo "Or just use the run script in TrendNews to build and deploy:"
    echo "  ./android/scripts/run-android-linux.sh"
    echo "============================================="
else
    echo "Error: Failed to create the emulator. Make sure the system image is downloaded."
    exit 1
fi
