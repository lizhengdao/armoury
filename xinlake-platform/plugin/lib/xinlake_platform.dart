import 'dart:async';

import 'package:flutter/services.dart';

enum AndroidAppDir { internalCache, internalFiles, externalCache, externalFiles }

class XinlakePlatform {
  static const MethodChannel _channel = MethodChannel('xinlake_platform');

  /// Return a map contains the version info:
  /// * key "version" is the version string
  /// * key "modified-utc" is the modified date of the app file
  static Future<Map<String, dynamic>?> getAppVersion() async {
    try {
      return await _channel.invokeMapMethod<String, dynamic>("getAppVersion");
    } catch (error) {
      return null;
    }
  }

  /// Get the absolute path of the app directory
  static Future<String?> getAppDir({
    AndroidAppDir? appDir,
  }) async {
    try {
      return await _channel.invokeMethod("getAppDir", {
        "appDirIndex": appDir?.index,
      });
    } catch (error) {
      return null;
    }
  }

  /// Returns a list contains files picked, an empty list if the action was canceled,
  /// null if error occurs
  /// * [multiSelection]: Multiple selection
  /// ***
  /// Android. READ_EXTERNAL_STORAGE permission is required.
  /// * [mimeType]: Acceptable MIME types such as "image/jpeg", "audio/*", "application/xyz"
  /// * [cacheDir]:
  /// * [cacheOverwrite]: This parameter will be ignored if cacheDir is AndroidCacheDir.none
  /// ***
  /// Windows.
  /// * [openPath]: Path to open
  /// * [defaultPath]: Default open folder for the dialog, if openPath is set
  /// then defaultPath will be ignored.
  /// * [filterName]: Friendly name of the filter such as "JPEG Image"
  /// * [filterPattern]: Filter pattern such as "*.jpg; *.jpeg"
  static Future<List<String>?> pickFiles({
    bool multiSelection = false,
    // android
    String mimeType = "*/*",
    AndroidAppDir? cacheDir,
    bool cacheOverwrite = false,
    // windows
    String? openPath,
    String? defaultPath,
    required String filterName,
    required String filterPattern,
  }) async {
    try {
      return await _channel.invokeListMethod('pickFiles', {
        "multiSelection": multiSelection,
        "mimeType": mimeType,
        "cacheDirIndex": cacheDir?.index,
        "cacheOverwrite": cacheOverwrite,
        "openPath": openPath ?? "",
        "defaultPath": defaultPath ?? "",
        "filterName": filterName,
        "filterPattern": filterPattern,
      });
    } catch (error) {
      return null;
    }
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
