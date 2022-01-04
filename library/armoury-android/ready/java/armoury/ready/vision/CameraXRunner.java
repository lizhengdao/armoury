package armoury.ready.vision;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.View;
import android.widget.EditText;

import androidx.activity.ComponentActivity;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;

import com.google.android.material.switchmaterial.SwitchMaterial;

import armoury.ready.Runner;
import armoury.vision.mlkit.CameraXActivity;
import xinlake.armoury.ready.R;

public class CameraXRunner extends Runner implements View.OnClickListener {
    private final ActivityResultLauncher<Intent> startActivityLauncher;

    public CameraXRunner(ComponentActivity activity) {
        super(activity);
        startActivityLauncher = activity.registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            result -> {
                final int resultCode = result.getResultCode();
                final Intent data = result.getData();
                if (resultCode == Activity.RESULT_OK && data != null) {
                    String code = CameraXActivity.getScanResult(data);
                    if (code == null) {
                        code = "NULL";
                    }

                    new AlertDialog.Builder(activity)
                        .setTitle("Code")
                        .setMessage(code)
                        .setPositiveButton("OK", (dialog, which) -> dialog.dismiss())
                        .show();
                }
            });
    }

    @Override
    public void onClick(View view) {
        final View layout = View.inflate(activity, R.layout.dialog_camerax, null);
        final EditText editPrefix = layout.findViewById(R.id.camerax_prefix);
        final SwitchMaterial playBeep = layout.findViewById(R.id.camerax_beep);
        final SwitchMaterial switchFacing = layout.findViewById(R.id.camerax_facing);

        DialogInterface.OnClickListener clickRun = (dialog, which) -> {
            Intent intent = CameraXActivity.getScanIntent(activity,
                0xFF000000, editPrefix.getText().toString(), playBeep.isChecked(),
                switchFacing.isChecked());
            startActivityLauncher.launch(intent);
        };

        new AlertDialog.Builder(activity)
            .setView(layout)
            .setTitle("CameraX")
            .setPositiveButton("Run", clickRun)
            .show();
    }
}
