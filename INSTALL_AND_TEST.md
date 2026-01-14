# Installation and Test Execution Guide

This guide provides step-by-step instructions for installing the Xamarin app and running Espresso tests.

## Prerequisites

- Android device or emulator with API level 24 or higher
- USB debugging enabled (for physical devices)
- ADB (Android Debug Bridge) installed and in PATH

## Quick Start - Install and Test

### Option 1: Automated (Recommended)

Run everything with a single command:

```bash
./build-and-test.sh
```

This will:
1. Build the Xamarin app
2. Start an emulator if needed
3. Install the app
4. Build and run all Espresso tests
5. Display results

### Option 2: Manual Step-by-Step

Follow these steps to manually install and test:

## Step 1: Check Connected Devices

First, verify that your Android device or emulator is connected:

```bash
adb devices
```

Expected output:
```
List of devices attached
emulator-5554   device
```

If no devices are shown, either:
- Connect a physical device via USB with USB debugging enabled
- Start an Android emulator using Android Studio or command line

## Step 2: Install the Xamarin Application

### Using Pre-built APK (from GitHub Actions)

If you downloaded APKs from GitHub Actions artifacts:

```bash
# Navigate to the downloaded artifacts directory
cd path/to/downloaded/artifacts

# Install the Xamarin app (will upgrade if already installed)
adb install -r SimpleApp-Debug.apk
```

### Using Locally Built APK

If you built the app locally:

```bash
# Build the app first (if not already built)
./build-app.sh

# Install the app
adb install -r SimpleApp/bin/Debug/net10.0-android/SimpleApp-Debug.apk
```

**Note**: The `-r` flag allows reinstalling/upgrading without uninstalling first. This works because the app now has auto-incrementing version codes.

Expected output:
```
Performing Streamed Install
Success
```

## Step 3: Verify App Installation

Check that the app is installed:

```bash
adb shell pm list packages | grep simpleapp
```

Expected output:
```
package:com.companyname.simpleapp
```

## Step 4: Launch the App (Optional)

You can manually launch the app to verify it works:

```bash
adb shell am start -n com.companyname.simpleapp/.MainActivity
```

The app should launch on your device/emulator showing:
- A button labeled "Click Me"
- An empty TextView

Click the button to verify it displays "Hello from Xamarin!"

## Step 5: Install Espresso Test APKs

The Espresso tests require two APKs to be installed:

1. **Test application APK** (`EspressoTests-debug.apk`)
2. **Test instrumentation APK** (`EspressoTests-debug-androidTest.apk`)

### Using Pre-built APKs (from GitHub Actions)

```bash
# Install test application
adb install -r EspressoTests-debug.apk

# Install test instrumentation
adb install -r EspressoTests-debug-androidTest.apk
```

### Using Locally Built APKs

```bash
# Build the tests first (if not already built)
./build-tests.sh

# Install test application
adb install -r EspressoTests/build/outputs/apk/debug/app-debug.apk

# Install test instrumentation
adb install -r EspressoTests/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk
```

## Step 6: Run the Espresso Tests

### Method 1: Using ADB Command (Manual)

Run the instrumentation tests directly:

```bash
adb shell am instrument -w com.companyname.simpleapp.espresso.test/androidx.test.runner.AndroidJUnitRunner
```

### Method 2: Using Test Script (Recommended)

```bash
./run-tests.sh
```

### Method 3: Using Gradle

```bash
cd EspressoTests
./gradlew connectedAndroidTest
```

## Expected Test Output

When tests run successfully, you should see:

```
com.companyname.simpleapp.MainActivityTest:
.
Time: X.XXX

OK (4 tests)
```

Or with more details:

```
com.companyname.simpleapp.MainActivityTest:
testAppLaunches: ✓
testButtonClickUpdatesTextView: ✓
testButtonExists: ✓
testTextViewExists: ✓

Tests run: 4, Failures: 0
```

## Test Details

The test suite includes 4 tests:

1. **testAppLaunches**: Verifies the app launches successfully and main UI elements are visible
2. **testButtonClickUpdatesTextView**: Verifies clicking the button updates the TextView with "Hello from Xamarin!"
3. **testButtonExists**: Verifies the button is displayed with text "Click Me"
4. **testTextViewExists**: Verifies the TextView element is displayed

## Viewing Test Reports

After running tests with Gradle, detailed HTML reports are generated:

```bash
# Open the test report in your browser
open EspressoTests/build/reports/androidTests/connected/index.html

# Or on Linux
xdg-open EspressoTests/build/reports/androidTests/connected/index.html

# Or navigate manually to:
# EspressoTests/build/reports/androidTests/connected/index.html
```

## Troubleshooting

### "No devices found"

**Problem**: `adb devices` shows no devices

**Solution**:
- Connect a device via USB with USB debugging enabled
- Or start an Android emulator
- Check USB connection and drivers

### "Installation failed: INSTALL_FAILED_UPDATE_INCOMPATIBLE"

**Problem**: Trying to install but signatures don't match

**Solution**: Uninstall the app first:
```bash
adb uninstall com.companyname.simpleapp
adb uninstall com.companyname.simpleapp.espresso
adb uninstall com.companyname.simpleapp.espresso.test
```

Then reinstall both apps.

### "Unable to find launch intent"

**Problem**: Test can't find the app to launch

**Solution**: Ensure the Xamarin app is installed:
```bash
adb shell pm list packages | grep simpleapp
```

If not installed, install it following Step 2.

### "Test instrumentation runner not found"

**Problem**: Test APKs are not installed

**Solution**: Install both test APKs (Step 5):
- `EspressoTests-debug.apk`
- `EspressoTests-debug-androidTest.apk`

### Tests fail with "View not found"

**Problem**: App UI might not be fully loaded

**Solution**: This shouldn't happen with proper waits, but if it does:
1. Ensure device/emulator is responsive (not slow)
2. Check app launches successfully manually
3. Review test logs for specific errors

## Uninstalling

To completely remove all components:

```bash
# Uninstall Xamarin app
adb uninstall com.companyname.simpleapp

# Uninstall test APKs
adb uninstall com.companyname.simpleapp.espresso
adb uninstall com.companyname.simpleapp.espresso.test
```

## APK File Names Reference

After building locally, you'll find these APKs:

### Xamarin Application
- **Location**: `SimpleApp/bin/Debug/net10.0-android/SimpleApp-Debug.apk`
- **Also**: `artifacts/xamarin/SimpleApp-Debug.apk` (preserved copy)
- **Package**: com.companyname.simpleapp

### Espresso Test Application
- **Location**: `EspressoTests/build/outputs/apk/debug/app-debug.apk`
- **Also named**: `EspressoTests-debug.apk` (in GitHub artifacts)
- **Package**: com.companyname.simpleapp.espresso

### Espresso Test Instrumentation
- **Location**: `EspressoTests/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk`
- **Also named**: `EspressoTests-debug-androidTest.apk` (in GitHub artifacts)
- **Package**: com.companyname.simpleapp.espresso.test

## Synchronized Package Configuration

The Espresso tests now automatically retrieve the target package name from the instrumentation context, which is configured in `EspressoTests/src/androidTest/AndroidManifest.xml`:

```xml
<instrumentation
    android:name="androidx.test.runner.AndroidJUnitRunner"
    android:targetPackage="com.companyname.simpleapp"
    android:label="Espresso Tests for Xamarin SimpleApp" />
```

This means:
- ✅ No hardcoded package names in test code
- ✅ Single source of truth for configuration
- ✅ If you change the package name, just update the manifest
- ✅ Tests automatically use the correct package

## Version Codes and Upgrades

Both the Xamarin app and Espresso test APKs now use auto-incrementing version codes based on build timestamp (format: yyMMddHH).

This means:
- ✅ You can install newer builds over older ones without uninstalling
- ✅ `adb install -r` works to upgrade
- ✅ Each build from GitHub Actions is upgradeable
- ✅ No more "INSTALL_FAILED_VERSION_DOWNGRADE" errors

Example version codes:
- Build on 2026-01-11 at 16:00 UTC → versionCode: 26011116
- Build on 2026-01-11 at 17:00 UTC → versionCode: 26011117
- Build on 2026-01-12 at 10:00 UTC → versionCode: 26011210

## Advanced: Running Specific Tests

To run a specific test class:

```bash
adb shell am instrument -w -e class com.companyname.simpleapp.MainActivityTest \
  com.companyname.simpleapp.espresso.test/androidx.test.runner.AndroidJUnitRunner
```

To run a specific test method:

```bash
adb shell am instrument -w -e class com.companyname.simpleapp.MainActivityTest#testAppLaunches \
  com.companyname.simpleapp.espresso.test/androidx.test.runner.AndroidJUnitRunner
```

## Continuous Integration

Tests run automatically on every push and pull request via GitHub Actions. View results and download APKs from the Actions tab in the GitHub repository.
