package xinlake.platform;

import android.Manifest;
import android.app.Activity;
import android.content.ClipData;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.core.util.Consumer;
import androidx.core.util.Pair;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

import armoury.utility.XinFile;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * XinlakePlatformPlugin
 *
 * @author Xinlake Liu
 * @version 2021.11
 */
public class XinlakePlatformPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final int ACTION_PICK_FILE = 7039;

    private MethodChannel channel;
    private ActivityPluginBinding binding;

    private int actionRequestCode = 1000;
    private int permissionRequestCode = 1000;
    private final HashMap<Integer, Pair<Integer, Consumer<LinkedList<Uri>>>> activityRequests = new HashMap<>();
    private final HashMap<Integer, Pair<String, Consumer<Boolean>>> permissionRequests = new HashMap<>();

    private void getAppVersion(Result result) {
        final Activity activity = binding.getActivity();

        final PackageInfo packageInfo;
        try {
            String packageName = activity.getPackageName();
            packageInfo = activity.getPackageManager().getPackageInfo(packageName, 0);
        } catch (Exception exception) {
            result.error("getPackageInfo", null, null);
            return;
        }

        result.success(new HashMap<String, Object>() {{
            put("version", packageInfo.versionName);
            put("modified-utc", packageInfo.lastUpdateTime);
        }});
    }

    private void getAppDir(MethodCall call, Result result) {
        final int appDirIndex;

        try {
            Integer argAppDirIndex = call.argument("appDirIndex");
            if (argAppDirIndex != null) {
                appDirIndex = argAppDirIndex;
            } else {
                appDirIndex = -1;
            }
        } catch (Exception exception) {
            result.error("Invalid parameters", null, null);
            return;
        }

        // 0: internalCacheDir, 1: internalFilesDir
        // 2: externalCacheDir, 3: externalFilesDir
        final String dirPath;
        switch (appDirIndex) {
            case 0:
                dirPath = binding.getActivity().getCacheDir().getAbsolutePath();
                break;
            case 1:
                dirPath = binding.getActivity().getFilesDir().getAbsolutePath();
                break;
            case 2:
                dirPath = binding.getActivity().getExternalCacheDir().getAbsolutePath();
                break;
            case 3:
                dirPath = binding.getActivity().getExternalFilesDir(null).getAbsolutePath();
                break;
            default:
                dirPath = binding.getActivity().getDataDir().getAbsolutePath();
                break;
        }

        result.success(dirPath);
    }

    private void pickFiles(MethodCall call, Result result) {
        final String mimeType;
        final int cacheDirIndex;
        final Boolean cacheOverwrite;
        final Boolean multiSelection;

        // check parameters
        try {
            multiSelection = call.argument("multiSelection");
            mimeType = call.argument("mimeType");
            cacheOverwrite = call.argument("cacheOverwrite");
            Integer argCacheDirIndex = call.argument("cacheDirIndex");

            if (mimeType == null) {
                throw new Exception();
            }

            if (argCacheDirIndex != null) {
                cacheDirIndex = argCacheDirIndex;
            } else {
                cacheDirIndex = -1;
            }
        } catch (Exception exception) {
            result.error("Invalid parameters", null, null);
            return;
        }

        // create intent
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.addCategory(Intent.CATEGORY_OPENABLE);
        intent.putExtra(Intent.EXTRA_LOCAL_ONLY, true);
        intent.setType(mimeType);
        if (multiSelection != null) {
            intent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, multiSelection);
        }

        final Activity activity = binding.getActivity();
        if (intent.resolveActivity(activity.getPackageManager()) == null) {
            result.error("Unable to handle this intent", null, null);
            return;
        }

        // start the intent
        activityRequests.put(++actionRequestCode, new Pair<>(ACTION_PICK_FILE, uriList -> {
            // user canceled
            if (uriList == null) {
                result.success(null);
                return;
            }

            // 0: internalCacheDir, 1: internalFilesDir
            // 2: externalCacheDir, 3: externalFilesDir
            final XinFile.AppDir cacheDir;
            switch (cacheDirIndex) {
                case 0:
                    cacheDir = XinFile.AppDir.InternalCache;
                    break;
                case 1:
                    cacheDir = XinFile.AppDir.InternalFiles;
                    break;
                case 2:
                    cacheDir = XinFile.AppDir.ExternalCache;
                    break;
                case 3:
                    cacheDir = XinFile.AppDir.ExternalFiles;
                    break;
                default:
                    cacheDir = null;
                    break;
            }

            // get path and send results
            if (cacheDir != null) {
                new Thread(() -> {
                    final ArrayList<String> pathList = new ArrayList<>();
                    final boolean overwrite = (cacheOverwrite != null && cacheOverwrite);
                    for (Uri uri : uriList) {
                        final String filePath = XinFile.cacheFromUri(activity, uri, cacheDir, overwrite);
                        if (filePath != null) {
                            pathList.add(filePath);
                        }
                    }
                    // send results when files has been copied
                    activity.runOnUiThread(() -> result.success(pathList));
                }).start();
            } else {
                final ArrayList<String> pathList = new ArrayList<>();
                for (Uri uri : uriList) {
                    final String filePath = XinFile.getPath(activity, uri);
                    if (filePath != null) {
                        pathList.add(filePath);
                    }
                }
                result.success(pathList);
            }
        }));

        try {
            activity.startActivityForResult(intent, actionRequestCode);
        } catch (Exception exception) {
            result.error("Unable to handle this intent", null, null);
        }
    }

    private void checkAndRequestPermission(Consumer<Boolean> consumer) {
        final String permission = Manifest.permission.READ_EXTERNAL_STORAGE;
        final String[] permissions = new String[]{permission};

        final Activity activity = binding.getActivity();
        permissionRequests.put(++permissionRequestCode, new Pair<>(permission, consumer));
        if (activity.checkSelfPermission(permission) != PackageManager.PERMISSION_GRANTED) {
            activity.requestPermissions(permissions, permissionRequestCode);
        } else {
            handlePermissionResult.onRequestPermissionsResult(permissionRequestCode, permissions,
                new int[]{PackageManager.PERMISSION_GRANTED});
        }
    }

    private final PluginRegistry.ActivityResultListener handleActivityResult =
        (requestCode, resultCode, data) -> {
            Pair<Integer, Consumer<LinkedList<Uri>>> action = activityRequests.remove(requestCode);
            if (action != null) {
                assert action.first != null;
                assert action.second != null;
                if (action.first == ACTION_PICK_FILE) {
                    // read results
                    if (resultCode == Activity.RESULT_OK && data != null) {
                        final Uri uriData = data.getData();
                        final ClipData clipData = data.getClipData();

                        final LinkedList<Uri> uriList = new LinkedList<>();
                        if (uriData != null) {
                            uriList.add(uriData);
                        } else if (clipData != null) {
                            int count = clipData.getItemCount();
                            for (int i = 0; i < count; ++i) {
                                uriList.add(clipData.getItemAt(i).getUri());
                            }
                        }

                        action.second.accept(uriList);
                    } else {
                        // user canceled
                        action.second.accept(null);
                    }
                }

                return true;
            }

            return false;
        };

    private final PluginRegistry.RequestPermissionsResultListener handlePermissionResult =
        (requestCode, permissions, grantResults) -> {
            Pair<String, Consumer<Boolean>> request = permissionRequests.remove(requestCode);
            if (request != null) {
                assert request.second != null;

                String permission = request.first;
                boolean granted = (binding.getActivity().checkSelfPermission(permission)
                    == PackageManager.PERMISSION_GRANTED);

                request.second.accept(granted);
                return true;
            }

            return false;
        };

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getAppVersion":
                getAppVersion(result);
                break;
            case "getAppDir":
                getAppDir(call, result);
                break;
            case "pickFiles":
                checkAndRequestPermission(granted -> {
                    if (granted) {
                        pickFiles(call, result);
                    } else {
                        result.error("Permission Denied", null, null);
                    }
                });
                break;
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xinlake_platform");
        channel.setMethodCallHandler(this);
    }
    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    // ActivityAware -------------------------------------------------------------------------------
    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        binding.addRequestPermissionsResultListener(handlePermissionResult);
        binding.addActivityResultListener(handleActivityResult);
        this.binding = binding;
    }
    @Override
    public void onDetachedFromActivity() {
        binding.removeRequestPermissionsResultListener(handlePermissionResult);
        binding.removeActivityResultListener(handleActivityResult);
        binding = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        binding.addRequestPermissionsResultListener(handlePermissionResult);
        binding.addActivityResultListener(handleActivityResult);
        this.binding = binding;
    }
    @Override
    public void onDetachedFromActivityForConfigChanges() {
        binding.removeRequestPermissionsResultListener(handlePermissionResult);
        binding.removeActivityResultListener(handleActivityResult);
        binding = null;
    }
}
