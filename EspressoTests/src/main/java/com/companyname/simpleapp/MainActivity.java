package com.companyname.simpleapp;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends Activity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Get references to the UI elements
        final TextView textView = findViewById(R.id.textView);
        Button button = findViewById(R.id.button);
        
        // Set up the button click handler
        if (button != null && textView != null) {
            button.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    textView.setText("Hello from Xamarin!");
                }
            });
        }
    }
}
