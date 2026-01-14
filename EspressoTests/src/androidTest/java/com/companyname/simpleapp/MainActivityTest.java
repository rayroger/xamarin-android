package com.companyname.simpleapp;

import android.content.Context;
import android.content.Intent;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

@RunWith(AndroidJUnit4.class)
public class MainActivityTest {
    
    // --- THIS IS THE CRITICAL CHANGE ---
    // We hardcode the correct package name of the Xamarin app to avoid ambiguity.
    private static final String TARGET_PACKAGE = "com.companyname.simpleapp";
    
    @Before
    public void setUp() {
        Context context = InstrumentationRegistry.getInstrumentation().getContext();
        
        // Use the hardcoded TARGET_PACKAGE to ensure we launch the correct app.
        Intent intent = context.getPackageManager().getLaunchIntentForPackage(TARGET_PACKAGE);
        
        if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
            context.startActivity(intent);
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        } else {
            throw new RuntimeException(
                "Unable to find launch intent for package: " + TARGET_PACKAGE
                // ... rest of the error message
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
        // This method now uses the hardcoded TARGET_PACKAGE constant.
        return InstrumentationRegistry
            .getInstrumentation()
            .getTargetContext()
            .getResources()
            .getIdentifier(name, "id", TARGET_PACKAGE);
    }
}
