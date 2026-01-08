# Simple Xamarin Android Application with Espresso Tests

This repository contains a simple Xamarin Android application with Espresso-based UI tests.

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

## Building the Xamarin Application

### Prerequisites
- .NET SDK 10.0 or later with Android workload
- Android SDK

### Build Commands
```bash
cd SimpleApp
dotnet build
```

## Running Espresso Tests

### Prerequisites
- Java 17
- Gradle 8.5
- Android SDK with API level 24 or higher
- Android device or emulator

### Setup
1. Install the Android workload for .NET:
```bash
dotnet workload install android
```

2. Navigate to the EspressoTests directory:
```bash
cd EspressoTests
```

3. Initialize Gradle wrapper (if needed):
```bash
gradle wrapper --gradle-version=8.5
```

4. Build the test project:
```bash
./gradlew build
```

### Running Tests
To run the Espresso tests on a connected device or emulator:
```bash
./gradlew connectedAndroidTest
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

## Notes

The EspressoTests project includes a Java implementation that mirrors the Xamarin app's functionality. This allows Espresso tests to run against a native Android application with the same UI and behavior as the Xamarin app.

Both applications share:
- Identical UI layout (activity_main.xml)
- Same button click behavior
- Same text update functionality
