#!/bin/bash

# Run script for SimpleApp - deploys to device or emulator
# This script installs and launches the app on a connected device/emulator

set -e

echo "======================================"
echo "SimpleApp Run Script"
echo "======================================"
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "Error: adb not found. Please ensure Android SDK platform-tools are installed."
    exit 1
fi

# Check for connected devices
echo "Checking for connected devices/emulators..."
DEVICE_COUNT=$(adb devices | grep -v "List of devices" | grep -E "device|emulator" | wc -l)

if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "✗ No devices or emulators found."
    echo ""
    echo "Please:"
    echo "  1. Connect an Android device via USB with USB debugging enabled"
    echo "  OR"
    echo "  2. Start an Android emulator"
    echo ""
    echo "Then run this script again."
    exit 1
fi

echo "✓ Found $DEVICE_COUNT device(s)/emulator(s)"
echo ""

# Use Debug build by default
BUILD_CONFIG=${1:-Debug}
APK_PATH="SimpleApp/bin/$BUILD_CONFIG/net10.0-android/com.companyname.simpleapp-Signed.apk"

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "APK not found at: $APK_PATH"
    echo "Building application first..."
    ./build-app.sh $BUILD_CONFIG
fi

echo "Installing application..."
adb install -r "$APK_PATH"

echo ""
echo "Launching application..."
adb shell am start -n com.companyname.simpleapp/.MainActivity

echo ""
echo "======================================"
echo "✓ Application launched successfully!"
echo "======================================"
echo ""
echo "To view logs:"
echo "  adb logcat | grep SimpleApp"
echo ""
echo "To uninstall:"
echo "  adb uninstall com.companyname.simpleapp"
