#!/bin/bash

# Build script for Espresso Tests
# This script builds the Espresso test project

set -e

echo "======================================"
echo "Espresso Tests Build Script"
echo "======================================"
echo ""

cd EspressoTests

# Check if gradle wrapper exists
if [ ! -f "./gradlew" ]; then
    echo "Creating Gradle wrapper..."
    gradle wrapper --gradle-version=9.2.1 || {
        echo "Warning: Could not create Gradle wrapper"
        echo "Continuing with system Gradle..."
    }
fi

echo "Building Espresso tests..."
if [ -f "./gradlew" ]; then
    ./gradlew assembleDebug assembleDebugAndroidTest
else
    gradle assembleDebug assembleDebugAndroidTest
fi

echo ""
echo "======================================"
echo "✓ Espresso tests built successfully!"
echo "======================================"

# Preserve the APKs in artifacts directory
ARTIFACTS_DIR="../artifacts/espresso"
mkdir -p "$ARTIFACTS_DIR"

# Copy test APKs if they exist
if [ -f "build/outputs/apk/debug/app-debug.apk" ]; then
    cp "build/outputs/apk/debug/app-debug.apk" "$ARTIFACTS_DIR/app-debug.apk"
    echo "✓ Test app APK preserved: $ARTIFACTS_DIR/app-debug.apk"
fi

if [ -f "build/outputs/apk/androidTest/debug/app-debug-androidTest.apk" ]; then
    cp "build/outputs/apk/androidTest/debug/app-debug-androidTest.apk" "$ARTIFACTS_DIR/app-debug-androidTest.apk"
    echo "✓ Test instrumentation APK preserved: $ARTIFACTS_DIR/app-debug-androidTest.apk"
fi

echo ""
echo "Test APK: EspressoTests/build/outputs/apk/"
echo ""
echo "To run tests on a connected device/emulator:"
echo "  cd EspressoTests"
echo "  ./gradlew connectedAndroidTest"
echo ""
echo "Or use the test script:"
echo "  ./run-tests.sh"
