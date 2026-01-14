# Espresso Test Configuration

## Overview

The Espresso tests in this project are configured to test the **Xamarin Android app** (`com.companyname.simpleapp`) using Android instrumentation testing.

## Architecture

### Package Structure

- **Xamarin App Package**: `com.companyname.simpleapp`
- **Test Package**: `com.companyname.simpleapp.espresso`
- **Instrumentation Package**: `com.companyname.simpleapp.espresso.test` (auto-generated)

### Instrumentation Configuration

The tests use Android's instrumentation framework to run in the same process as the Xamarin app. This is configured in:

1. **`src/androidTest/AndroidManifest.xml`**:
   ```xml
   <instrumentation
       android:name="androidx.test.runner.AndroidJUnitRunner"
       android:targetPackage="com.companyname.simpleapp"
       android:label="Espresso Tests for Xamarin SimpleApp" />
   ```

2. **`build.gradle`**:
   ```gradle
   applicationId "com.companyname.simpleapp.espresso"
   ```
   
   Note: The instrumentation test package will be automatically named `com.companyname.simpleapp.espresso.test` by appending `.test` to the applicationId.

## Signing and Process Sharing

### Debug Signing

Both the Xamarin app and the test APK use the Android debug signing key by default. This ensures:

- ✅ **Same signing certificate** - Required for instrumentation
- ✅ **Same process** - Tests run in the app's process
- ✅ **Full access** - Tests can interact with app internals

The debug keystore is automatically used for both:
- Xamarin app (via .NET Android workload)
- Test app (via Gradle's `signingConfigs.debug`)

### Release Builds

For release builds, you would need to:
1. Use the same signing key for both apps
2. Configure the signing in `build.gradle` for the test app
3. Configure the signing in Xamarin's project settings

## How It Works

1. **Build Phase**:
   - Xamarin app is built: `com.companyname.simpleapp-Signed.apk`
   - Test APK is built: `app-debug-androidTest.apk`
   - Both are signed with debug key

2. **Installation**:
   - Both APKs are installed on the device
   - Android validates that signatures match

3. **Test Execution**:
   - Instrumentation launches the Xamarin app
   - Tests run in the same process as the app
   - Espresso can interact with UI elements

## Resource Access

The tests access Xamarin app resources dynamically:

```java
private int getResourceId(String name) {
    return InstrumentationRegistry
        .getInstrumentation()
        .getTargetContext()
        .getResources()
        .getIdentifier(name, "id", "com.companyname.simpleapp");
}
```

This allows tests to find UI elements by ID without needing compile-time R class references.

## Running Tests

### Prerequisites

Both apps must be installed on the device:

```bash
# Install Xamarin app
adb install -r SimpleApp/bin/Debug/net10.0-android/com.companyname.simpleapp-Signed.apk

# Run tests (which also installs test APK)
cd EspressoTests
./gradlew connectedAndroidTest
```

### Verification

Check that both apps are installed:

```bash
adb shell pm list packages | grep companyname
```

Expected output:
```
package:com.companyname.simpleapp
package:com.companyname.simpleapp.espresso
package:com.companyname.simpleapp.espresso.test
```

Note: The `.espresso.test` package is the instrumentation runner package, automatically created by Android.

## Troubleshooting

### "Package signatures do not match"

**Cause**: Different signing keys used for app and tests

**Solution**: Ensure both use debug signing, or configure same release key

### "Target package does not exist"

**Cause**: Xamarin app not installed on device

**Solution**: Install Xamarin app before running tests

### Resource ID not found

**Cause**: Resource names don't match between app and tests

**Solution**: Verify resource IDs match in Xamarin app's layout files

## References

- [Android Instrumentation Testing](https://developer.android.com/training/testing/instrumentation-tests)
- [Espresso Testing](https://developer.android.com/training/testing/espresso)
- [Xamarin Android](https://learn.microsoft.com/en-us/xamarin/android/)
