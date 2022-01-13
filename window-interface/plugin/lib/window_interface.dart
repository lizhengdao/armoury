import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'window_placement.dart';

/// Only supports windows platform.
class WindowInterface {
  static const MethodChannel _channel = MethodChannel('window_interface');

  static Future<WindowPlacement?> getWindowPlacement() async {
    final map = await _channel.invokeMapMethod<String, int>("getWindowPlacement");
    if (map != null) {
      return WindowPlacement(
        offsetX: map["offsetX"]!,
        offsetY: map["offsetY"]!,
        width: map["width"]!,
        height: map["height"]!,
      );
    }
    return null;
  }

  static Future<bool> setWindowPlacement(WindowPlacement placement) async {
    try {
      await _channel.invokeMethod("setWindowPlacement", {
        "offsetX": placement.offsetX,
        "offsetY": placement.offsetY,
        "width": placement.width,
        "height": placement.height,
      });
      return true;
    } catch (exception) {
      // such as invalid arguments
      return false;
    }
  }

  static Future<bool> getFullScreen() async {
    bool result = await _channel.invokeMethod("getFullScreen");
    return result;
  }

  static Future<void> setFullScreen(bool isFullScreen) async {
    await _channel.invokeMethod("setFullScreen", {'isFullScreen': isFullScreen});
  }

  static Future<void> toggleFullScreen() async {
    await _channel.invokeMethod('toggleFullScreen');
  }

  static Future<Size?> getWindowMinSize() async {
    final map = await _channel.invokeMapMethod<String, int>('getWindowMinSize');
    if (map != null) {
      int width = map["width"]!;
      int height = map["height"]!;
      return Size(width.toDouble(), height.toDouble());
    }
    return null;
  }

  static Future<bool> setWindowMinSize(int width, int height) async {
    try {
      await _channel.invokeMethod('setWindowMinSize', {
        'width': width,
        'height': height,
      });
      return true;
    } catch (exception) {
      return false;
    }
  }

  static Future<void> resetWindowMinSize() async {
    await _channel.invokeMethod('resetWindowMinSize');
  }

  static Future<Size?> getWindowMaxSize() async {
    final map = await _channel.invokeMapMethod<String, int>('getWindowMaxSize');
    if (map != null) {
      int width = map["width"]!;
      int height = map["height"]!;
      return Size(width.toDouble(), height.toDouble());
    }
    return null;
  }

  static Future<bool> setWindowMaxSize(int width, int height) async {
    try {
      await _channel.invokeMethod('setWindowMaxSize', {
        'width': width,
        'height': height,
      });
      return true;
    } catch (exception) {
      return false;
    }
  }

  static Future<void> resetWindowMaxSize() async {
    await _channel.invokeMethod('resetWindowMaxSize');
  }

  static Future<void> setStayOnTop(bool isStayOnTop) async {
    await _channel.invokeMethod('setStayOnTop', {'isStayOnTop': isStayOnTop});
  }
}
