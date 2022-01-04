package armoury.ready;

import androidx.activity.ComponentActivity;

public abstract class Runner {
    protected final ComponentActivity activity;

    protected Runner(ComponentActivity activity) {
        this.activity = activity;
    }
}
