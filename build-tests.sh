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
echo ""
echo "Test APK: EspressoTests/build/outputs/apk/"
echo ""
echo "To run tests on a connected device/emulator:"
echo "  cd EspressoTests"
echo "  ./gradlew connectedAndroidTest"
echo ""
echo "Or use the test script:"
echo "  ./run-tests.sh"
