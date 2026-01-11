# Simple Xamarin Android Application with Espresso Tests

This repository contains a simple Xamarin Android application with Espresso-based UI tests that run automatically at the end of the build.

## Project Structure

### SimpleApp (Xamarin.Android Application)
A basic Android application built with Xamarin that includes:
- A **TextView** that initially displays empty text
- A **Button** labeled "Click Me"
- Button click functionality that updates the TextView with "Hello from Xamarin!"

### EspressoTests (Android Test Project)
A Gradle-based Android instrumentation test project containing Espresso tests that:
- Target the actual Xamarin app using Android instrumentation
- Verify the button can be clicked
- Read and validate the TextView content after button click
- Test all UI components exist and function correctly
- **Run automatically at the end of the build process**
- Use the same signing key as the Xamarin app for testing in the same process

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
adb install -r bin/Debug/net10.0-android/com.companyname.simpleapp-Signed.apk

# Launch the app
adb shell am start -n com.companyname.simpleapp/.MainActivity
```

### Run Tests Only

**Prerequisites:**
- Java 17
- Gradle 9.2.1
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
gradle wrapper --gradle-version=9.2.1
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
- Uploads test results and APKs as artifacts

### Downloading Build Artifacts

**From CI/CD (GitHub Actions):**
1. Go to the [Actions tab](../../actions) in the GitHub repository
2. Click on a successful workflow run
3. Scroll down to the "Artifacts" section
4. Download:
   - `app-debug` - Xamarin application APK
   - `test-apks` - Espresso test APKs (includes both test app and instrumentation)
   - `test-results` - Test execution reports

**From Local Builds:**

After running a successful build locally (using `./build-and-test.sh`, `make all`, or individual build scripts), the APKs are automatically preserved in the `artifacts/` directory:

- **Xamarin app**: `artifacts/xamarin/com.companyname.simpleapp-Signed.apk`
- **Espresso test app**: `artifacts/espresso/app-debug.apk`
- **Espresso test instrumentation**: `artifacts/espresso/app-debug-androidTest.apk`

See [artifacts/README.md](artifacts/README.md) for detailed information about build artifacts.

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
- **Debug APK**: `SimpleApp/bin/Debug/net10.0-android/com.companyname.simpleapp-Signed.apk`
- **Release APK**: `SimpleApp/bin/Release/net10.0-android/com.companyname.simpleapp-Signed.apk`

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
adb uninstall com.companyname.simpleapp
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
- **Gradle** 9.2.1 for build automation

## Build Optimizations

The project includes several optimizations to speed up builds:

### Gradle Configuration Cache
The Espresso test builds use Gradle's configuration cache, which can significantly speed up subsequent builds by caching the result of the configuration phase. This is enabled in `EspressoTests/gradle.properties`:

```properties
org.gradle.configuration-cache=true
org.gradle.caching=true
```

**Benefits:**
- Faster build times on repeated builds (up to 50% faster)
- Reduced configuration time
- Better build performance in CI/CD

For more information, see the [Gradle Configuration Cache documentation](https://docs.gradle.org/current/userguide/configuration_cache_enabling.html).

### Build Artifact Preservation
Successful builds automatically preserve APKs in the `artifacts/` directory, making them easy to download and deploy without rebuilding. This includes:
- Xamarin application APK
- Espresso test APKs (both test app and instrumentation)

## Application IDs

- Xamarin App: `com.companyname.simpleapp`
- Test App: `com.companyname.simpleapp.test`

## Instrumentation Testing

The Espresso tests use Android's instrumentation framework to test the Xamarin app:

- **Target Package**: `com.companyname.simpleapp` (the Xamarin app)
- **Test Package**: `com.companyname.simpleapp.test`
- **Signing**: Both apps use the same debug signing key for compatibility
- **Process**: Tests run in the same process as the Xamarin app
- **Configuration**: See [EspressoTests/INSTRUMENTATION_SETUP.md](EspressoTests/INSTRUMENTATION_SETUP.md) for details

This configuration ensures that:
✅ Tests can interact directly with the Xamarin app's UI
✅ Resources are accessed dynamically from the target app
✅ Both apps share the same signing certificate for instrumentation
✅ No duplicate Java implementation needed - tests target the real Xamarin app

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

The EspressoTests project uses Android instrumentation testing to directly test the Xamarin app. The tests:

- Run in the same process as the Xamarin app
- Use the same debug signing key for compatibility  
- Access UI elements dynamically using resource IDs
- Target the actual Xamarin MainActivity, not a Java mirror
- Provide true end-to-end testing of the Xamarin implementation

For detailed information about the instrumentation setup, see [EspressoTests/INSTRUMENTATION_SETUP.md](EspressoTests/INSTRUMENTATION_SETUP.md).
