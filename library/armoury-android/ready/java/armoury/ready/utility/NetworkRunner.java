package armoury.ready.utility;

import android.app.AlertDialog;
import android.view.View;

import androidx.activity.ComponentActivity;

import java.util.List;

import armoury.ready.Runner;
import armoury.utility.WifiInterface;
import armoury.utility.XinNet;

public class NetworkRunner extends Runner implements View.OnClickListener {
    public NetworkRunner(ComponentActivity activity) {
        super(activity);
    }

    @Override
    public void onClick(View view) {
        StringBuilder stringBuilder = new StringBuilder();

        // get dns
        List<String> dnsList = XinNet.getDefaultDNS(activity);
        if (dnsList.size() > 0) {
            stringBuilder.append("DNS:\r\n");
            for (String dns : dnsList) {
                stringBuilder.append(dns).append("\r\n");
            }
        } else {
            stringBuilder.append("DNS not found.\r\n");
        }

        stringBuilder.append("\r\n");

        // get wifi address
        List<WifiInterface> wifiInterfaces = WifiInterface.getIpAddress();
        if (wifiInterfaces.size() > 0) {
            stringBuilder.append("WiFi Address:\r\n");
            for (WifiInterface wifiInterface : wifiInterfaces) {
                stringBuilder.append(wifiInterface.name).append("\r\n");

                for (String ip4 : wifiInterface.ip4List) {
                    stringBuilder.append(ip4).append("\r\n");
                }

                for (String ip6 : wifiInterface.ip6List) {
                    stringBuilder.append(ip6).append("\r\n");
                }
            }
        } else {
            stringBuilder.append("WiFi is not connected.").append("\r\n");
        }

        new AlertDialog.Builder(activity)
            .setTitle("Network")
            .setMessage(stringBuilder)
            .setPositiveButton("OK", (dialog, which) -> dialog.dismiss())
            .show();
    }
}
