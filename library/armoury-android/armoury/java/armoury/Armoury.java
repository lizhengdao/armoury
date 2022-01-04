package armoury;

import android.content.Context;

import androidx.annotation.NonNull;

import java.io.File;

/**
 * Armoury library global config
 * @author Xinlake Liu
 * @version 2021.04
 */
public class Armoury {
    public final File logFile;

    // single instance -----------------------------------------------------------------------------
    private static Armoury armoury;

    public static Armoury getInstance() {
        return armoury;
    }

    public static void init(@NonNull Context appContext, File logFile) {
        if (logFile == null) {
            // appContext.getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS);
            String logName = appContext.getApplicationInfo().packageName + ".log";
            logFile = new File(appContext.getFilesDir(), logName);
        }

        armoury = new Armoury(logFile);
    }

    /**
     * single instance.
     */
    private Armoury(@NonNull File logFile) {
        this.logFile = logFile;
    }
}
