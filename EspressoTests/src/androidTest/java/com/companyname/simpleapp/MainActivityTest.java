package com.companyname.simpleapp;

import androidx.test.ext.junit.rules.ActivityScenarioRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.espresso.Espresso;
import androidx.test.espresso.action.ViewActions;
import androidx.test.espresso.assertion.ViewAssertions;
import androidx.test.espresso.matcher.ViewMatchers;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

/**
 * Espresso test for the Simple Xamarin App.
 * 
 * This test verifies that:
 * 1. The button can be pressed
 * 2. The TextView displays the expected text after button click
 */
@RunWith(AndroidJUnit4.class)
public class MainActivityTest {
    
    @Rule
    public ActivityScenarioRule<MainActivity> activityRule = 
        new ActivityScenarioRule<>(MainActivity.class);
    
    @Test
    public void testButtonClickUpdatesTextView() {
        // Initially, the TextView should be empty
        onView(withId(R.id.textView))
            .check(matches(withText("")));
        
        // Click the button
        onView(withId(R.id.button))
            .perform(click());
        
        // Verify that the TextView now displays the expected text
        onView(withId(R.id.textView))
            .check(matches(withText("Hello from Xamarin!")));
    }
    
    @Test
    public void testButtonExists() {
        // Verify that the button is displayed with correct text
        onView(withId(R.id.button))
            .check(matches(withText("Click Me")));
    }
    
    @Test
    public void testTextViewExists() {
        // Verify that the TextView exists
        onView(withId(R.id.textView))
            .check(matches(ViewMatchers.isDisplayed()));
    }
}
