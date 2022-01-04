package armoury.ready;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.widget.TextView;

import androidx.activity.ComponentActivity;

import armoury.Armoury;
import armoury.ready.utility.NetworkRunner;
import armoury.ready.utility.UriPathRunner;
import armoury.ready.vision.BarcodeDecodeRunner;
import armoury.ready.vision.CameraXRunner;
import armoury.ready.vision.ZxingEncodeRunner;
import armoury.utility.Logger;
import xinlake.armoury.ready.R;

public class ActivityMain extends ComponentActivity {
    private static final String Tag = ActivityMain.class.getSimpleName();

    @Override
    @SuppressLint("SetTextI18n")
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Armoury.init(getApplicationContext(), null);
        Logger.write(Tag, "hello");

        setContentView(R.layout.activity_main);
        ((TextView) findViewById(R.id.main_text_version)).setText("version "
            + xinlake.armoury.BuildConfig.versionName);

        // utilities
        findViewById(R.id.main_uri_path).setOnClickListener(new UriPathRunner(this));
        findViewById(R.id.main_network_address).setOnClickListener(new NetworkRunner(this));

        // vision
        findViewById(R.id.main_camerax).setOnClickListener(new CameraXRunner(this));
        findViewById(R.id.main_zxing_decode).setOnClickListener(new BarcodeDecodeRunner(this));
        findViewById(R.id.main_zxing_encode).setOnClickListener(new ZxingEncodeRunner(this));
    }
}
