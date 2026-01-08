namespace SimpleApp;

[Activity(Label = "@string/app_name", MainLauncher = true)]
public class MainActivity : Activity
{
    protected override void OnCreate(Bundle? savedInstanceState)
    {
        base.OnCreate(savedInstanceState);

        // Set our view from the "main" layout resource
        SetContentView(Resource.Layout.activity_main);

        // Get references to the UI elements
        var textView = FindViewById<TextView>(Resource.Id.textView);
        var button = FindViewById<Button>(Resource.Id.button);

        // Set up the button click handler
        if (button != null && textView != null)
        {
            button.Click += (sender, e) =>
            {
                textView.Text = "Hello from Xamarin!";
            };
        }
    }
}