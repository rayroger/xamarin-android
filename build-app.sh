#!/bin/bash

# Build script for SimpleApp Xamarin Android application
# This script builds the app and generates APKs for deployment

set -e

echo "======================================"
echo "SimpleApp Build Script"
echo "======================================"
echo ""

# Check if Android workload is installed
echo "Checking .NET Android workload..."
if ! dotnet workload list | grep -q "android"; then
    echo "Android workload not found. Installing..."
    dotnet workload install android --skip-manifest-update
else
    echo "✓ Android workload is installed"
fi
echo ""

# Build configurations
BUILD_CONFIG=${1:-Debug}

echo "Building SimpleApp in $BUILD_CONFIG mode..."
cd SimpleApp

# Clean previous builds
echo "Cleaning previous builds..."
dotnet clean -v quiet

# Build the app
echo "Building application..."
dotnet build -c $BUILD_CONFIG

# Check if APK was generated
APK_PATH="bin/$BUILD_CONFIG/net10.0-android/com.companyname.simpleapp-Signed.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo "======================================"
    echo "✓ Build successful!"
    echo "======================================"
    echo "APK Location: SimpleApp/$APK_PATH"
    
    # Preserve the APK in artifacts directory
    ARTIFACTS_DIR="../artifacts/xamarin"
    mkdir -p "$ARTIFACTS_DIR"
    cp "$APK_PATH" "$ARTIFACTS_DIR/com.companyname.simpleapp-Signed.apk"
    echo "✓ APK preserved: $ARTIFACTS_DIR/com.companyname.simpleapp-Signed.apk"
    
    echo ""
    echo "To install on a device or emulator:"
    echo "  adb install -r SimpleApp/$APK_PATH"
    echo ""
    echo "Or use the run script:"
    echo "  ./run-app.sh"
else
    echo ""
    echo "======================================"
    echo "✗ Build failed - APK not found"
    echo "======================================"
    exit 1
fi
