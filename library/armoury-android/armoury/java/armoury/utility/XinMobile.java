package armoury.utility;

import android.animation.ValueAnimator;
import android.app.Activity;
import android.content.res.Configuration;
import android.os.Build;
import android.view.Window;

import androidx.annotation.NonNull;

import java.util.Locale;

public class XinMobile {
    // Utility class
    private XinMobile() {
    }

    public static Boolean getNightMode(@NonNull Activity activity) {
        final Boolean nightMode;

        int mode = activity.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK;
        if (mode == Configuration.UI_MODE_NIGHT_YES) {
            nightMode = true;
        } else if (mode == Configuration.UI_MODE_NIGHT_NO) {
            nightMode = false;
        } else {
            nightMode = null;
        }

        return nightMode;
    }

    /**
     * @param color        the color of the navigation bar to
     * @param dividerColor the color of divider line between the navigation bar and the app
     * @param animate      if > 0 then start a animation
     */
    public static boolean setNavigationBar(@NonNull Activity activity,
        int color, Integer dividerColor, int animate) {
        // check window
        final Window window = activity.getWindow();
        if (window == null) {
            return false;
        }

        // set navigation bar.
        if (animate > 0) {
            ValueAnimator colorAnimation = ValueAnimator.ofArgb(window.getNavigationBarColor(), color);
            colorAnimation.addUpdateListener(animation ->
                window.setNavigationBarColor((Integer) animation.getAnimatedValue()));
            colorAnimation.setDuration(animate);
            colorAnimation.start();
        } else {
            window.setNavigationBarColor(color);
        }

        if (dividerColor != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            window.setNavigationBarDividerColor(dividerColor);
        }

        return true;
    }

    public static String connectWords(@NonNull String delimiter, String... words) {
        final StringBuilder stringBuilder = new StringBuilder();
        for (String word : words) {
            if (word != null && !word.isEmpty()) {
                stringBuilder.append(word).append(delimiter);
            }
        }

        return stringBuilder.substring(0, stringBuilder.length() - delimiter.length());
    }

    public static String generateIp() {
        return String.format(Locale.US, "%d.%d.%d.%d",
            (int) (255 * Math.random()),
            (int) (255 * Math.random()),
            (int) (255 * Math.random()),
            (int) (255 * Math.random()));
    }
}
