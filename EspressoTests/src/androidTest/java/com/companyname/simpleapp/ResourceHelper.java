package com.companyname.simpleapp;

import android.content.Context;
import androidx.test.platform.app.InstrumentationRegistry;

/**
 * A helper utility for "black box" testing against an external APK (like a Xamarin app).
 * It provides a method to dynamically find the integer value of a resource ID
 * by its string name at runtime, since we cannot use the R.class from the app directly.
 */
public class ResourceHelper {

    // This MUST match the ApplicationId of the Xamarin app you are testing.
    private static final String TARGET_PACKAGE = "com.companyname.simpleapp";

    /**
     * Finds the integer ID for a resource by its string name.
     *
     * @param idName The string name of the resource ID (e.g., "button", "textView").
     * @return The integer value of the resource ID.
     * @throws RuntimeException if the ID cannot be found.
     */
    public static int getId(String idName) {
        // Get the context of the application under test.
        Context targetContext = InstrumentationRegistry.getInstrumentation().getTargetContext();

        // Use the Resources.getIdentifier() method to look up the ID.
        // It searches for a resource of type "id" with the given name in the target package.
        int id = targetContext.getResources().getIdentifier(idName, "id", TARGET_PACKAGE);

        // If getIdentifier returns 0, it means the resource was not found.
        if (id == 0) {
            throw new RuntimeException("Could not find resource ID for name: '" + idName + "' in package: '" + TARGET_PACKAGE + "'. " +
                    "Check if the ID is correct in your Xamarin layout XML and if the TARGET_PACKAGE is correct.");
        }

        return id;
    }
}
