package armoury.utility;

import androidx.annotation.NonNull;

import java.io.FileOutputStream;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import armoury.Armoury;


/**
 * @author Xinlake Liu
 * @version 2021.11
 */
public class Logger {
    private static final DateTimeFormatter dateTimeFormatter =
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Utility class
    private Logger() {
    }

    public static void write(@NonNull String head, String message) {
        try (FileOutputStream fileOutputStream =
                 new FileOutputStream(Armoury.getInstance().logFile, true)) {
            writeHead(fileOutputStream, head);

            if (message != null) {
                byte[] messageLine = (message + "\r\n").getBytes();
                fileOutputStream.write(messageLine);
            }

            fileOutputStream.flush();
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

    public static void write(@NonNull String head, Throwable throwable) {
        try (FileOutputStream fileOutputStream =
                 new FileOutputStream(Armoury.getInstance().logFile, true)) {
            writeHead(fileOutputStream, head);

            if (throwable != null) {
                String message = throwable.getLocalizedMessage();
                if (message != null) {
                    fileOutputStream.write((message + "\r\n").getBytes());
                }
            }

            fileOutputStream.flush();
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }

    private static void writeHead(FileOutputStream fileOutputStream, String head) throws IOException {
        final String time = LocalDateTime.now().format(dateTimeFormatter);
        final byte[] headLine = (time + ". " + head + "\r\n").getBytes();
        fileOutputStream.write(headLine);
    }
}
