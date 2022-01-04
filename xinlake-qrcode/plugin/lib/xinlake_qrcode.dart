import 'dart:async';

import 'package:flutter/services.dart';

class XinlakeQrcode {
  static const MethodChannel _channel = MethodChannel('xinlake_qrcode');

  /// android
  static Future<String?> fromCamera({
    int? accentColor,
    String? prefix,
    bool? playBeep,
    bool? frontFace,
  }) async {
    try {
      final String? code = await _channel.invokeMethod('fromCamera', {
        "accentColor": accentColor,
        "prefix": prefix,
        "playBeep": playBeep,
        "frontFace": frontFace,
      });
      return code;
    } catch (exception) {
      return null;
    }
  }

  /// windows
  static Future<String?> fromScreen() async {
    try {
      final String? code = await _channel.invokeMethod('fromScreen');
      return code;
    } catch (exception) {
      return null;
    }
  }

  static Future<List<String>?> fromImage(List<String>? imageList) async {
    try {
      final List<String>? codeList = await _channel.invokeListMethod('fromImage', {
        "imageList": imageList,
      });
      return codeList;
    } catch (exception) {
      return null;
    }
  }
}
