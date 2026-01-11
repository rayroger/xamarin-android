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
 * Note: These tests target the installed Xamarin app (com.companyname.simpleapp)
 * The instrumentation runs with the same signing as the Xamarin app for testing.
 */
@RunWith(AndroidJUnit4.class)
public class MainActivityTest {
    
    private static final String TARGET_PACKAGE = "com.companyname.simpleapp";
    
    @Before
    public void setUp() {
        // Launch the Xamarin app's main activity
        // The activity uses a non-obfuscated name: com.companyname.simpleapp.MainActivity
        // We use getLaunchIntentForPackage which automatically resolves the launch activity
        Intent intent = InstrumentationRegistry.getInstrumentation()
            .getTargetContext()
            .getPackageManager()
            .getLaunchIntentForPackage(TARGET_PACKAGE);
        
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            ActivityScenario.launch(intent);
        } else {
            throw new RuntimeException("Unable to find launch intent for " + TARGET_PACKAGE);
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
            .getIdentifier(name, "id", TARGET_PACKAGE);
    }
}
