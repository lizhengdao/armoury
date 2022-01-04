package armoury.ready.vision;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.activity.ComponentActivity;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;

import com.google.android.material.switchmaterial.SwitchMaterial;

import java.util.List;

import armoury.vision.mlkit.processer.BarcodeScannerProcessor;
import armoury.vision.mlkit.processer.VisionProcessor;
import armoury.vision.zxing.ZXingDecoder;
import xinlake.armoury.ready.R;

public class BarcodeDecodeRunner implements View.OnClickListener {
    private final ActivityResultLauncher<String> requestPermissionLauncher;
    private final ActivityResultLauncher<String> openDocumentLauncher;

    @SuppressLint("SetTextI18n")
    public BarcodeDecodeRunner(ComponentActivity activity) {
        openDocumentLauncher = activity.registerForActivityResult(
            new ActivityResultContracts.GetContent(),
            uri -> {
                final View layout = View.inflate(activity, R.layout.dialog_qrcode_decode, null);
                final ImageView qrImage = layout.findViewById(R.id.qrcode_decode_image);
                final SwitchMaterial useMlkit = layout.findViewById(R.id.qrcode_decode_mlkit);
                final TextView qrText = layout.findViewById(R.id.qrcode_decode_text);

                if (uri != null) {
                    qrImage.setImageURI(uri);
                } else {
                    qrImage.setImageDrawable(null);
                    qrText.setText("Invalid selection");
                }

                AlertDialog alertDialog = new AlertDialog.Builder(activity)
                    .setView(layout)
                    .setTitle("Decode image")
                    .setPositiveButton("Detect", null)
                    .show();

                alertDialog.getButton(DialogInterface.BUTTON_POSITIVE).setOnClickListener(button -> {
                    if (uri != null) {
                        if (useMlkit.isChecked()) {
                            // mlkit
                            VisionProcessor<List<String>> visionProcessor = new BarcodeScannerProcessor(activity, "", true);
                            visionProcessor.detect(uri, barcodeList ->
                                qrText.setText(barcodeList.isEmpty() ? "Not Found" : barcodeList.get(0)));
                        } else {
                            // zxing
                            new Thread(() -> {
                                String code = ZXingDecoder.decodeImage(activity, uri);
                                activity.runOnUiThread(() ->
                                    qrText.setText(code == null ? "Not Found" : code));
                            }).start();
                        }
                    }
                });
            });

        requestPermissionLauncher = activity.registerForActivityResult(
            new ActivityResultContracts.RequestPermission(),
            granted -> {
                if (granted) {
                    openDocumentLauncher.launch("image/*");
                } else {
                    Toast.makeText(activity,
                        "Permission Denied",
                        Toast.LENGTH_LONG).show();
                }
            });
    }

    @Override
    public void onClick(View v) {
        requestPermissionLauncher.launch(Manifest.permission.READ_EXTERNAL_STORAGE);
    }
}
