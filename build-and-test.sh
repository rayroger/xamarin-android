#!/bin/bash

# Comprehensive build and test script
# Builds the Xamarin app, starts emulator if needed, and runs Espresso tests

set -e

echo "=============================================="
echo "SimpleApp - Complete Build and Test Pipeline"
echo "=============================================="
echo ""

# Configuration
EMULATOR_NAME="test_emulator_api_30"
EMULATOR_WAIT_TIME=60
BUILD_CONFIG=${1:-Debug}

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Android workload
echo -e "${YELLOW}[1/6]${NC} Checking .NET Android workload..."
if ! dotnet workload list | grep -q "android"; then
    echo "Installing Android workload..."
    dotnet workload install android --skip-manifest-update
else
    echo -e "${GREEN}✓${NC} Android workload is installed"
fi
echo ""

# Step 2: Build Xamarin App
echo -e "${YELLOW}[2/6]${NC} Building Xamarin application..."
cd SimpleApp
dotnet clean -v quiet
dotnet build -c $BUILD_CONFIG -v minimal

APK_PATH="bin/$BUILD_CONFIG/net10.0-android/com.companyname.SimpleApp-Signed.apk"
if [ ! -f "$APK_PATH" ]; then
    echo -e "${RED}✗ Build failed - APK not found${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Xamarin app built successfully"
cd ..
echo ""

# Step 3: Check/Start Emulator
echo -e "${YELLOW}[3/6]${NC} Checking for Android emulator..."

# Check if device/emulator is already running
DEVICE_COUNT=$(adb devices 2>/dev/null | grep -v "List of devices" | grep -E "device|emulator" | wc -l)

if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo "No emulator running. Attempting to start one..."
    
    # Check if emulator command exists
    EMULATOR_CMD=""
    if command -v emulator &> /dev/null; then
        EMULATOR_CMD="emulator"
    elif [ -f "/usr/local/lib/android/sdk/emulator/emulator" ]; then
        EMULATOR_CMD="/usr/local/lib/android/sdk/emulator/emulator"
    elif [ -f "$ANDROID_SDK_ROOT/emulator/emulator" ]; then
        EMULATOR_CMD="$ANDROID_SDK_ROOT/emulator/emulator"
    fi
    
    if [ -z "$EMULATOR_CMD" ]; then
        echo -e "${YELLOW}⚠${NC} Emulator command not found"
        echo "Please start an Android emulator manually or connect a device"
        echo "Then re-run this script"
        exit 1
    fi
    
    # List available AVDs
    AVD_LIST=$($EMULATOR_CMD -list-avds 2>/dev/null || echo "")
    
    if [ -z "$AVD_LIST" ]; then
        echo -e "${YELLOW}⚠${NC} No Android Virtual Devices (AVDs) found"
        echo ""
        echo "Please create an AVD using Android Studio or avdmanager:"
        echo "  avdmanager create avd -n $EMULATOR_NAME -k \"system-images;android-30;google_apis;x86_64\""
        echo ""
        echo "Or connect a physical Android device with USB debugging enabled"
        exit 1
    fi
    
    # Use first available AVD
    AVD_NAME=$(echo "$AVD_LIST" | head -n 1)
    echo "Starting emulator: $AVD_NAME"
    
    # Start emulator in background
    $EMULATOR_CMD -avd "$AVD_NAME" -no-window -no-audio -no-snapshot &
    EMULATOR_PID=$!
    
    echo "Waiting for emulator to boot (max ${EMULATOR_WAIT_TIME}s)..."
    
    # Wait for emulator to be ready
    COUNTER=0
    while [ $COUNTER -lt $EMULATOR_WAIT_TIME ]; do
        BOOT_COMPLETED=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
        if [ "$BOOT_COMPLETED" == "1" ]; then
            echo -e "${GREEN}✓${NC} Emulator is ready"
            break
        fi
        sleep 2
        COUNTER=$((COUNTER + 2))
        echo -n "."
    done
    echo ""
    
    if [ $COUNTER -ge $EMULATOR_WAIT_TIME ]; then
        echo -e "${RED}✗ Emulator failed to start within ${EMULATOR_WAIT_TIME}s${NC}"
        echo "You can:"
        echo "  1. Increase wait time by modifying EMULATOR_WAIT_TIME variable"
        echo "  2. Start emulator manually and re-run this script"
        kill $EMULATOR_PID 2>/dev/null || true
        exit 1
    fi
else
    echo -e "${GREEN}✓${NC} Device/emulator already running"
fi
echo ""

# Step 4: Install Xamarin App
echo -e "${YELLOW}[4/6]${NC} Installing Xamarin app on device/emulator..."
adb install -r "SimpleApp/$APK_PATH"
echo -e "${GREEN}✓${NC} App installed successfully"
echo ""

# Step 5: Build Espresso Tests
echo -e "${YELLOW}[5/6]${NC} Building Espresso tests..."
cd EspressoTests

# Create gradle wrapper if it doesn't exist
if [ ! -f "./gradlew" ]; then
    echo "Creating Gradle wrapper..."
    gradle wrapper --gradle-version=8.5 2>/dev/null || {
        echo -e "${YELLOW}⚠${NC} Could not create Gradle wrapper, using system Gradle"
    }
fi

# Build test APKs
if [ -f "./gradlew" ]; then
    ./gradlew assembleDebug assembleDebugAndroidTest --quiet || ./gradlew assembleDebug assembleDebugAndroidTest
else
    gradle assembleDebug assembleDebugAndroidTest --quiet || gradle assembleDebug assembleDebugAndroidTest
fi

echo -e "${GREEN}✓${NC} Espresso tests built successfully"
cd ..
echo ""

# Step 6: Run Espresso Tests
echo -e "${YELLOW}[6/6]${NC} Running Espresso tests..."
cd EspressoTests

if [ -f "./gradlew" ]; then
    ./gradlew connectedAndroidTest || {
        echo -e "${RED}✗ Some tests failed${NC}"
        echo "Check test reports at: EspressoTests/build/reports/androidTests/connected/index.html"
        exit 1
    }
else
    gradle connectedAndroidTest || {
        echo -e "${RED}✗ Some tests failed${NC}"
        echo "Check test reports at: EspressoTests/build/reports/androidTests/connected/index.html"
        exit 1
    }
fi

cd ..
echo ""

# Success!
echo "=============================================="
echo -e "${GREEN}✓ ALL TESTS PASSED!${NC}"
echo "=============================================="
echo ""
echo "Summary:"
echo "  ✓ Xamarin app built"
echo "  ✓ Emulator/device ready"
echo "  ✓ App installed"
echo "  ✓ Espresso tests built"
echo "  ✓ All tests passed"
echo ""
echo "Test reports: EspressoTests/build/reports/androidTests/connected/index.html"
echo "APK location: SimpleApp/$APK_PATH"
