package com.companyname.simpleapp;

import android.content.Context; // <-- 1. IMPORT 'Context'
import android.content.Intent;

// import androidx.test.core.app.ActivityScenario; // <-- 2. REMOVE 'ActivityScenario'
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
 * This test uses a "black box" approach by launching the app via a direct Intent,
 * which is more robust for testing non-native (e.g., Xamarin) applications.
 */
@RunWith(AndroidJUnit4.class)
public class MainActivityTest {
    
    private static String getTargetPackage() {
        return InstrumentationRegistry.getInstrumentation().getTargetContext().getPackageName();
    }
    
    @Before
    public void setUp() {
        String targetPackage = getTargetPackage();
        
        // Use the test runner's context to create and send the launch intent.
        Context context = InstrumentationRegistry.getInstrumentation().getContext();
        Intent intent = context.getPackageManager().getLaunchIntentForPackage(targetPackage);
        
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);

            // --- 3. THIS IS THE ONLY SIGNIFICANT CHANGE ---
            // Replace the ActivityScenario.launch(intent) call...
            // ActivityScenario.launch(intent);

            // ...with a direct context.startActivity(intent) call.
            context.startActivity(intent);

            // Add a brief, explicit wait to allow the black-box app to launch.
            // This is necessary because we are no longer using ActivityScenario's automatic synchronization.
            try {
                Thread.sleep(2000); // Wait for 2 seconds.
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

        } else {
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
        onView(withId(getResourceId("button")))
            .check(matches(isDisplayed()));
        onView(withId(getResourceId("textView")))
            .check(matches(isDisplayed()));
    }
    
    @Test
    public void testButtonClickUpdatesTextView() {
        onView(withId(getResourceId("textView")))
            .check(matches(withText("")));
        
        onView(withId(getResourceId("button")))
            .perform(click());
        
        onView(withId(getResourceId("textView")))
            .check(matches(withText("Hello from Xamarin!")));
    }
    
    @Test
    public void testButtonExists() {
        onView(withId(getResourceId("button")))
            .check(matches(withText("Click Me")));
    }
    
    @Test
    public void testTextViewExists() {
        onView(withId(getResourceId("textView")))
            .check(matches(isDisplayed()));
    }
    
    private int getResourceId(String name) {
        return InstrumentationRegistry
            .getInstrumentation()
            .getTargetContext()
            .getResources()
            .getIdentifier(name, "id", getTargetPackage());
    }
}
