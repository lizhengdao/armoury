package armoury.ready.vision;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;

import androidx.activity.ComponentActivity;

import armoury.ready.Runner;
import armoury.utility.XinMobile;
import armoury.vision.zxing.ZXingEncoder;
import armoury.vision.zxing.ZXingFormat;
import xinlake.armoury.ready.R;

public class ZxingEncodeRunner extends Runner implements View.OnClickListener {
    public ZxingEncodeRunner(ComponentActivity activity) {
        super(activity);
    }

    @Override
    public void onClick(View view) {
        final View layout = View.inflate(activity, R.layout.dialog_qrcode_encode, null);
        final EditText editText = layout.findViewById(R.id.qrcode_encode_text);
        final ImageView qrImage = layout.findViewById(R.id.qrcode_encode_image);

        AlertDialog alertDialog = new AlertDialog.Builder(activity)
            .setView(layout)
            .setTitle("Generate QR Image")
            .setNeutralButton("Generate", null)
            .setPositiveButton("Run", null)
            .show();

        alertDialog.getButton(DialogInterface.BUTTON_NEUTRAL).setOnClickListener(button -> {
            String ip = XinMobile.generateIp();
            editText.setText(ip);
        });

        alertDialog.getButton(DialogInterface.BUTTON_POSITIVE).setOnClickListener(button -> {
            String content = editText.getText().toString();
            Bitmap bitmap = ZXingEncoder.encodeText(content, ZXingFormat.QR_CODE, 600);
            qrImage.setImageBitmap(bitmap);
        });
    }
}
