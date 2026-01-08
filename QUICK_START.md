# Quick Reference Guide

## Build and Deploy to Device/Emulator

### Complete Automated Pipeline (Recommended)

Run everything with one command:
```bash
./build-and-test.sh
```

Or using Make:
```bash
make all
```

This single command will:
1. ✓ Install .NET Android workload (if needed)
2. ✓ Build the Xamarin application → APK
3. ✓ Start an Android emulator (if no device connected)
4. ✓ Install the app on device/emulator
5. ✓ Build Espresso tests
6. ✓ **Run all tests automatically**
7. ✓ Display test results

### Just Build the App

```bash
./build-app.sh          # Builds Debug APK
./build-app.sh Release  # Builds Release APK
```

Or:
```bash
make build
```

### Just Run on Device/Emulator

```bash
./run-app.sh           # Installs and launches app
```

Or:
```bash
make run
```

### Just Run Tests

```bash
./build-tests.sh       # Builds test APKs
./run-tests.sh         # Runs tests on device/emulator
```

Or:
```bash
make test
```

## Device/Emulator Requirements

### Using a Physical Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect via USB
4. Run any script above

### Using an Emulator
The scripts will automatically:
- Detect if an emulator is running
- Start one if needed (using first available AVD)
- Wait for it to boot
- Then proceed with installation/testing

To create an AVD manually:
```bash
avdmanager create avd -n test_emulator_api_30 \
  -k "system-images;android-30;google_apis;x86_64"
```

## Troubleshooting

### "No devices found"
- Connect a device or start an emulator
- Check with: `adb devices`

### "Android workload not found"
```bash
dotnet workload install android --skip-manifest-update
```

### "Emulator won't start"
- Increase `EMULATOR_WAIT_TIME` in `build-and-test.sh`
- Or start emulator manually first

### Clean and Rebuild
```bash
make clean
make all
```

## CI/CD

GitHub Actions workflow runs automatically on:
- Every push
- Every pull request

View results in the Actions tab on GitHub.

## File Locations

- **Debug APK**: `SimpleApp/bin/Debug/net10.0-android/com.companyname.SimpleApp-Signed.apk`
- **Release APK**: `SimpleApp/bin/Release/net10.0-android/com.companyname.SimpleApp-Signed.apk`
- **Test Reports**: `EspressoTests/build/reports/androidTests/connected/index.html`

## Quick Commands

```bash
# Complete pipeline
make all

# Individual steps
make build
make run
make test
make clean

# Help
make help
./build-and-test.sh --help  # (shows usage)
```
