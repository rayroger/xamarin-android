# Simple Xamarin Android Application with Espresso Tests

This repository contains a simple Xamarin Android application with Espresso-based UI tests that run automatically at the end of the build.

## Project Structure

### SimpleApp (Xamarin.Android Application)
A basic Android application built with Xamarin that includes:
- A **TextView** that initially displays empty text
- A **Button** labeled "Click Me"
- Button click functionality that updates the TextView with "Hello from Xamarin!"

### EspressoTests (Android Test Project)
A Gradle-based Android test project containing Espresso tests that:
- Verify the button can be clicked
- Read and validate the TextView content after button click
- Test all UI components exist and function correctly
- **Run automatically at the end of the build process**

## Quick Start

### Complete Build and Test (Automated)

**Run everything with a single command:**
```bash
# Builds app, starts emulator if needed, and runs all tests
./build-and-test.sh
```

Or using Make:
```bash
make all
```

This will:
1. ✓ Install .NET Android workload (if needed)
2. ✓ Build the Xamarin application
3. ✓ Start an Android emulator (if no device connected)
4. ✓ Install the app on the device/emulator
5. ✓ Build the Espresso tests
6. ✓ Run all tests automatically
7. ✓ Display test results

### Build and Run the Xamarin App Only

**Prerequisites:**
- .NET SDK 10.0 or later
- Android SDK (installed automatically with Android workload)
- Android device or emulator

**Option 1: Using Make**
```bash
make build    # Build the app
make run      # Build and run on device/emulator
./build-app.sh

**Option 2: Using build scripts**
```bash
# Build the app
./build-app.sh

# Run on device/emulator
./run-app.sh
```

**Option 3: Manual build and deployment**
```bash
# Build
cd SimpleApp
dotnet build -c Debug

# Install on device (requires adb)
adb install -r bin/Debug/net10.0-android/com.companyname.SimpleApp-Signed.apk

# Launch the app
adb shell am start -n com.companyname.SimpleApp/crc649a55d3de34768ab3.MainActivity
```

### Run Tests Only

**Prerequisites:**
- Java 17
- Gradle 8.5
- Android SDK with API level 24 or higher
- Android device or emulator (must be running)

**Option 1: Using Make**
```bash
make test
```

**Option 2: Using test scripts**
```bash
# Build tests
./build-tests.sh

# Run tests on connected device/emulator
./run-tests.sh
```

**Option 3: Manual test execution**
```bash
cd EspressoTests
gradle wrapper --gradle-version=8.5
./gradlew connectedAndroidTest
```

## Available Make Targets

The project includes a Makefile for easy build and test automation:

```bash
make help           # Show all available targets
make build          # Build the Xamarin app
make test           # Build and run Espresso tests
make run            # Build and run the app on device/emulator
make all            # Complete build and test pipeline (recommended)
make clean          # Clean build artifacts
make install-deps   # Install required dependencies
```

## Automated Testing

### Tests Run Automatically at Build End

When you use the complete build pipeline, tests run automatically:

```bash
./build-and-test.sh
# or
make all
```

The script will:
- Build your app
- Detect or start an Android emulator
- Install the app
- Build and run all Espresso tests
- Display results

### Continuous Integration

The project includes a GitHub Actions workflow (`.github/workflows/build-and-test.yml`) that:
- Runs on every push and pull request
- Builds the Xamarin app
- Starts an Android emulator
- Runs all Espresso tests
- Uploads test results and APK as artifacts

## Building the Xamarin Application

### Prerequisites
Install the Android workload for .NET:
```bash
dotnet workload install android
```

### Build Commands

**Debug build:**
```bash
cd SimpleApp
dotnet build -c Debug
```

**Release build:**
```bash
cd SimpleApp
dotnet build -c Release
```

### Output Files
- **Debug APK**: `SimpleApp/bin/Debug/net10.0-android/com.companyname.SimpleApp-Signed.apk`
- **Release APK**: `SimpleApp/bin/Release/net10.0-android/com.companyname.SimpleApp-Signed.apk`

## Running on Device/Emulator

### Using Android Device
1. Enable USB debugging on your Android device
2. Connect device via USB
3. Run `./run-app.sh`

### Using Android Emulator
1. Start an Android emulator (using Android Studio or command line)
2. Run `./run-app.sh`

### Verify Installation
```bash
# Check connected devices
adb devices

# View app logs
adb logcat | grep SimpleApp

# Uninstall app
adb uninstall com.companyname.SimpleApp
```

## Running Espresso Tests

### Setup
Ensure you have:
- A running Android device or emulator
- The test app built (run `./build-tests.sh`)

### Running Tests
```bash
./run-tests.sh
```

### Test Reports
After running tests, reports are generated at:
```
EspressoTests/build/reports/androidTests/connected/index.html
```

## Test Details

The Espresso test suite includes three test cases:

1. **testButtonClickUpdatesTextView**: 
   - Verifies TextView is initially empty
   - Clicks the button
   - Validates TextView displays "Hello from Xamarin!"

2. **testButtonExists**: 
   - Verifies the button exists and displays "Click Me"

3. **testTextViewExists**: 
   - Verifies the TextView element is displayed

## Application Features

The application demonstrates basic Android UI interaction:
- Simple LinearLayout with vertical orientation
- TextView with ID `textView`
- Button with ID `button`
- Button click event handler that updates TextView text

## Technologies Used

- **Xamarin.Android** (.NET 10.0 for Android)
- **Android SDK** API 36 (target), API 24 (minimum)
- **Espresso** 3.6.1 for UI testing
- **AndroidX Test** libraries for instrumentation
- **Gradle** 8.5 for build automation

## Application IDs

- Xamarin App: `com.companyname.SimpleApp`
- Test App: `com.companyname.simpleapp.test`

## Troubleshooting

### Android workload not found
```bash
dotnet workload install android --skip-manifest-update
```

### No devices found
- Ensure device is connected and USB debugging is enabled
- Or start an Android emulator
- Run `adb devices` to verify

### Gradle build fails
- Check internet connection (first build needs to download dependencies)
- Ensure Android SDK is properly configured
- Set `ANDROID_HOME` or `ANDROID_SDK_ROOT` environment variable

### Tests fail to run
- Ensure device/emulator is running Android API 24 or higher
- Check that the test app is installed: `adb shell pm list packages | grep simpleapp`
- View test logs: `adb logcat | grep TestRunner`

## Notes

The EspressoTests project includes a Java implementation that mirrors the Xamarin app's functionality. This allows Espresso tests to run against a native Android application with the same UI and behavior as the Xamarin app.

Both applications share:
- Identical UI layout (activity_main.xml)
- Same button click behavior
- Same text update functionality
