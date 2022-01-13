[![pub package](https://img.shields.io/pub/v/window_interface.svg?color=blue&style=flat-square)](https://pub.dev/packages/window_interface)

This plugin allows you to control the native window of your flutter app on desktop windows, such as min size, max size, full screen, set topmost. Inspired by [desktop_window](https://github.com/mix1009/desktop_window).

![](../.lfs/demo-0.2.png)

## Using

```dart
import 'package:window_interface/window_interface.dart';

await WindowInterface.setWindowMinSize(640, 480);
```
