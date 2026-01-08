# Build Artifacts

This directory contains preserved build artifacts (APKs) from successful builds.

## Directory Structure

- **xamarin/** - Contains the Xamarin Android application APK
  - `com.companyname.SimpleApp-Signed.apk` - Debug build of the Xamarin app
  
- **espresso/** - Contains the Espresso test application APKs
  - `app-debug.apk` - Debug build of the test app
  - `app-debug-androidTest.apk` - Debug build of the Android test instrumentation

## How APKs are Generated

APKs are automatically copied here when you run successful builds using:

```bash
./build-and-test.sh
# or
make all
```

Individual build commands:
```bash
# Build and preserve Xamarin app
./build-app.sh

# Build and preserve Espresso tests
./build-tests.sh
```

## Downloading APKs

### From Local Builds
After a successful build, you can find the APKs in this directory:
- Xamarin app: `artifacts/xamarin/com.companyname.SimpleApp-Signed.apk`
- Espresso test app: `artifacts/espresso/app-debug.apk`
- Espresso test instrumentation: `artifacts/espresso/app-debug-androidTest.apk`

### From GitHub Actions
When builds run in CI, the APKs are uploaded as GitHub Actions artifacts:
1. Go to the Actions tab in the GitHub repository
2. Click on the workflow run you're interested in
3. Scroll down to the "Artifacts" section
4. Download:
   - `app-debug` - Xamarin application APK
   - `test-apks` - Espresso test APKs

## Installing APKs

To install the Xamarin app on a device:
```bash
adb install -r artifacts/xamarin/com.companyname.SimpleApp-Signed.apk
```

To run the Espresso tests:
```bash
adb install -r artifacts/espresso/app-debug.apk
adb install -r artifacts/espresso/app-debug-androidTest.apk
adb shell am instrument -w com.companyname.simpleapp.test/androidx.test.runner.AndroidJUnitRunner
```

## Notes

- APKs in this directory are preserved in version control (excluded from .gitignore)
- Only successful builds are copied here
- Old APKs are overwritten with new builds
