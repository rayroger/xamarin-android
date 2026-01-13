package com.companyname.simpleapp;

import android.content.Intent;

import androidx.test.core.app.ActivityScenario;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;

/**
 * Espresso instrumentation test for the Xamarin SimpleApp.
 * 
 * This test verifies that:
 * 1. The app can be launched successfully
 * 2. The button can be pressed
 * 3. The TextView displays the expected text after button click
 * 
 * Note: The target package is automatically retrieved from the instrumentation context,
 * which is synchronized with the targetPackage in AndroidManifest.xml.
 * No need to hardcode package names - it's all configured in one place!
 */
@RunWith(AndroidJUnit4.class)
public class MainActivityTest {
    
    // Get target package from instrumentation context - synchronized with AndroidManifest.xml
    // This way we don't need to hardcode the package name in multiple places
    private static String getTargetPackage() {
        String targetPkg = InstrumentationRegistry.getInstrumentation().getTargetContext().getPackageName();
        
        // Verify we got the correct target package (not the test package)
        // The target should be "com.companyname.simpleapp", not "com.companyname.simpleapp.test"
        if (targetPkg.endsWith(".test")) {
            // This shouldn't happen with proper instrumentation configuration and matching signatures
            throw new IllegalStateException(
                "Target package appears to be the test package (" + targetPkg + "). " +
                "This usually indicates a signing certificate mismatch between the app and test APKs. " +
                "Ensure both are signed with the same debug key."
            );
        }
        
        return targetPkg;
    }
    
    @Before
    public void setUp() {
        // Launch the Xamarin app's main activity
        // The activity uses a non-obfuscated name: com.companyname.simpleapp.MainActivity
        // We use getLaunchIntentForPackage which automatically resolves the launch activity
        String targetPackage = getTargetPackage();
        
        Intent intent = InstrumentationRegistry.getInstrumentation()
            .getTargetContext()
            .getPackageManager()
            .getLaunchIntentForPackage(targetPackage);
        
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            ActivityScenario.launch(intent);
        } else {
            // Provide detailed error message for troubleshooting
            throw new RuntimeException(
                "Unable to find launch intent for package: " + targetPackage + "\n" +
                "Possible causes:\n" +
                "1. App not installed on device\n" +
                "2. App has no launcher activity defined in AndroidManifest.xml\n" +
                "3. Signing certificate mismatch preventing instrumentation\n" +
                "Verify: adb shell pm list packages | grep companyname"
            );
        }
    }
    
    @Test
    public void testAppLaunches() {
        // This test verifies that the Xamarin app can be launched successfully
        // The setUp() method has already launched the app, so we just need to verify
        // that the main UI elements are present
        onView(withId(getResourceId("button")))
            .check(matches(isDisplayed()));
        onView(withId(getResourceId("textView")))
            .check(matches(isDisplayed()));
    }
    
    @Test
    public void testButtonClickUpdatesTextView() {
        // Initially, the TextView should be empty
        // Using resource ID from the Xamarin app
        onView(withId(getResourceId("textView")))
            .check(matches(withText("")));
        
        // Click the button
        onView(withId(getResourceId("button")))
            .perform(click());
        
        // Verify that the TextView now displays the expected text
        onView(withId(getResourceId("textView")))
            .check(matches(withText("Hello from Xamarin!")));
    }
    
    @Test
    public void testButtonExists() {
        // Verify that the button is displayed with correct text
        onView(withId(getResourceId("button")))
            .check(matches(withText("Click Me")));
    }
    
    @Test
    public void testTextViewExists() {
        // Verify that the TextView exists
        onView(withId(getResourceId("textView")))
            .check(matches(isDisplayed()));
    }
    
    /**
     * Helper method to get resource ID from the target Xamarin app's package
     */
    private int getResourceId(String name) {
        return InstrumentationRegistry
            .getInstrumentation()
            .getTargetContext()
            .getResources()
            .getIdentifier(name, "id", getTargetPackage());
    }
}
