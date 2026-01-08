#!/bin/bash

# Run script for Espresso Tests
# This script runs the Espresso tests on a connected device/emulator

set -e

echo "======================================"
echo "Espresso Tests Run Script"
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

cd EspressoTests

# Check if gradle wrapper exists
if [ ! -f "./gradlew" ]; then
    echo "Gradle wrapper not found. Creating..."
    gradle wrapper --gradle-version=8.5 || {
        echo "Warning: Could not create Gradle wrapper"
        echo "Continuing with system Gradle..."
    }
fi

echo "Running Espresso tests..."
if [ -f "./gradlew" ]; then
    ./gradlew connectedAndroidTest
else
    gradle connectedAndroidTest
fi

echo ""
echo "======================================"
echo "✓ Tests completed!"
echo "======================================"
echo ""
echo "Test reports available at:"
echo "  EspressoTests/build/reports/androidTests/connected/index.html"
