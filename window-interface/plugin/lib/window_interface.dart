import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Only supports windows platform.
class WindowInterface {
  static const MethodChannel _channel = MethodChannel('window_interface');

  static Future<Size?> getWindowSize() async {
    final Map? map = await _channel.invokeMapMethod("getWindowSize");
    if (map != null) {
      int width = map["width"];
      int height = map["height"];
      return Size(width.toDouble(), height.toDouble());
    }
    return null;
  }

  static Future<void> setWindowSize(int width, int height) async {
    await _channel.invokeMethod("setWindowSize", {
      "width": width,
      "height": height,
    });
  }

  static Future<bool?> getFullScreen() async {
    final result = await _channel.invokeMethod("getFullScreen");
    return result;
  }

  static Future<void> setFullScreen(bool isFullScreen) async {
    await _channel.invokeMethod("setFullScreen", {'isFullScreen': isFullScreen});
  }

  static Future<void> toggleFullScreen() async {
    await _channel.invokeMethod('toggleFullScreen');
  }

  static Future<Size?> getWindowMinSize() async {
    final Map? map = await _channel.invokeMapMethod('getWindowMinSize');
    if (map != null) {
      int width = map["width"];
      int height = map["height"];
      return Size(width.toDouble(), height.toDouble());
    }
    return null;
  }

  static Future<void> setWindowMinSize(int width, int height) async {
    await _channel.invokeMethod('setWindowMinSize', {
      'width': width,
      'height': height,
    });
  }

  static Future<void> resetWindowMinSize() async {
    await _channel.invokeMethod('resetWindowMinSize');
  }

  static Future<Size?> getWindowMaxSize() async {
    final Map? map = await _channel.invokeMapMethod('getWindowMaxSize');
    if (map != null) {
      int width = map["width"];
      int height = map["height"];
      return Size(width.toDouble(), height.toDouble());
    }
    return null;
  }

  static Future<void> setWindowMaxSize(int width, int height) async {
    await _channel.invokeMethod('setWindowMaxSize', {
      'width': width,
      'height': height,
    });
  }

  static Future<void> resetWindowMaxSize() async {
    await _channel.invokeMethod('resetWindowMaxSize');
  }

  static Future<void> setStayOnTop(bool isStayOnTop) async {
    await _channel.invokeMethod('setStayOnTop', {'isStayOnTop': isStayOnTop});
  }

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
