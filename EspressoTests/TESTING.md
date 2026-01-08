# Espresso Tests Documentation

## Overview
This directory contains Espresso-based UI tests for the Simple Xamarin Android application.

## Test Structure

### MainActivityTest.java
Location: `src/androidTest/java/com/companyname/simpleapp/MainActivityTest.java`

This test class contains three comprehensive test cases:

#### 1. testButtonClickUpdatesTextView()
**Purpose**: Verifies the complete button click workflow

**Steps**:
1. Launches MainActivity
2. Verifies TextView with ID `textView` initially displays empty string
3. Performs click action on Button with ID `button`
4. Verifies TextView now displays "Hello from Xamarin!"

**Espresso API calls**:
```java
onView(withId(R.id.textView)).check(matches(withText("")));
onView(withId(R.id.button)).perform(click());
onView(withId(R.id.textView)).check(matches(withText("Hello from Xamarin!")));
```

#### 2. testButtonExists()
**Purpose**: Verifies the button component exists and has correct text

**Steps**:
1. Launches MainActivity
2. Verifies Button with ID `button` displays text "Click Me"

**Espresso API calls**:
```java
onView(withId(R.id.button)).check(matches(withText("Click Me")));
```

#### 3. testTextViewExists()
**Purpose**: Verifies the TextView component is displayed

**Steps**:
1. Launches MainActivity
2. Verifies TextView with ID `textView` is displayed on screen

**Espresso API calls**:
```java
onView(withId(R.id.textView)).check(matches(ViewMatchers.isDisplayed()));
```

## Test Dependencies

The tests use the following Espresso and AndroidX Test libraries:

- `androidx.test.ext:junit:1.2.1` - JUnit integration for Android tests
- `androidx.test.espresso:espresso-core:3.6.1` - Core Espresso framework
- `androidx.test:runner:1.6.2` - Android test runner
- `androidx.test:rules:1.6.1` - Test rules (ActivityScenarioRule)

## Application Under Test

The tests run against a Java implementation of the Xamarin app located in:
`src/main/java/com/companyname/simpleapp/MainActivity.java`

This Java implementation mirrors the Xamarin app's behavior:
- Same layout (activity_main.xml)
- Same UI components (TextView, Button)
- Same functionality (button click updates TextView)

## Running the Tests

### Prerequisites
1. Android SDK with API level 24+
2. Android device or emulator connected and running
3. Gradle 8.5 or compatible version
4. Internet connection for downloading dependencies

### Commands

**Build the test APK**:
```bash
./gradlew assembleDebug assembleAndroidTest
```

**Run all tests**:
```bash
./gradlew connectedAndroidTest
```

**Run specific test**:
```bash
./gradlew connectedAndroidTest -Pandroid.testInstrumentationRunnerArguments.class=com.companyname.simpleapp.MainActivityTest#testButtonClickUpdatesTextView
```

### Test Reports
After running tests, reports are generated at:
`build/reports/androidTests/connected/index.html`

## Test Scenarios Covered

✅ **UI Component Existence**
- Button with correct text
- TextView visibility

✅ **User Interaction**
- Button click action
- Event handler execution

✅ **State Verification**
- Initial state (empty TextView)
- Updated state (populated TextView)

✅ **Text Validation**
- Reading TextView content
- Verifying exact text match

## Espresso Framework Features Used

- **ViewMatchers**: `withId()`, `withText()`, `isDisplayed()`
- **ViewActions**: `click()`
- **ViewAssertions**: `matches()`
- **ActivityScenarioRule**: Launches activity before each test
- **AndroidJUnit4 Runner**: Provides Android test environment

## Integration with Xamarin App

While the Xamarin app is built with C# and .NET, the Espresso tests use a Java implementation because:
1. Espresso is a native Android testing framework written in Java
2. It requires Java/Kotlin to write tests
3. The Java implementation ensures identical UI and behavior for testing purposes

Both apps share:
- Same package structure
- Identical XML layouts
- Same UI component IDs
- Equivalent functionality

This approach allows comprehensive Espresso testing of Xamarin app behavior.
