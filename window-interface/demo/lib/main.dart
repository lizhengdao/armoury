import 'package:flutter/material.dart';
import 'package:window_interface/window_interface.dart';

void main() {
  runApp(const WindowInterfaceDemo());
}

class WindowInterfaceDemo extends StatefulWidget {
  const WindowInterfaceDemo({Key? key}) : super(key: key);

  @override
  State<WindowInterfaceDemo> createState() => _WindowInterfaceState();
}

class _WindowInterfaceState extends State<WindowInterfaceDemo> {
  bool? _isFullScreen;
  Size? _windowSize;
  Size? _windowMinSize;
  Size? _windowMaxSize;

  int _setWindowWidth = 800;
  int _setWindowHeight = 600;
  int _setWindowMinWidth = 650;
  int _setWindowMinHeight = 500;
  int _setWindowMaxWidth = 1600;
  int _setWindowMaxHeight = 900;
  bool _setFullScreen = false;
  bool _setTopMost = false;

  TableRow _rowGetWindowSize() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async {
            var size = await WindowInterface.getWindowSize();
            setState(() => _windowSize = size);
          },
          child: const Text("getWindowSize"),
        ),
        Text("${_windowSize?.width.toInt()}, ${_windowSize?.height.toInt()}"),
      ],
    );
  }

  TableRow _rowSetWindowSize(double maxEditHeight) {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async => await WindowInterface.setWindowSize(
            _setWindowWidth,
            _setWindowHeight,
          ),
          child: const Text("setWindowSize"),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "width: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowWidth"),
                onChanged: (value) {
                  int? width = int.tryParse(value);
                  if (width != null) _setWindowWidth = width;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "height: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowHeight"),
                onChanged: (value) {
                  int? height = int.tryParse(value);
                  if (height != null) _setWindowHeight = height;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  TableRow _rowGetFullScreen() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async {
            var isFullScreen = await WindowInterface.getFullScreen();
            setState(() => _isFullScreen = isFullScreen);
          },
          child: const Text("getFullScreen"),
        ),
        Text("$_isFullScreen"),
      ],
    );
  }

  TableRow _rowSetFullScreen() {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: TextButton(
            onPressed: () async => WindowInterface.setFullScreen(_setFullScreen),
            child: const Text("setFullScreen"),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(
            value: _setFullScreen,
            onChanged: (value) {
              setState(() => _setFullScreen = value);
            },
          ),
        ),
      ],
    );
  }

  TableRow _rowToggleFullScreen() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async => WindowInterface.toggleFullScreen(),
          child: const Text("toggleFullScreen"),
        ),
        const Text("void"),
      ],
    );
  }

  TableRow _rowGetMinWindowSize() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async {
            var size = await WindowInterface.getWindowMinSize();
            setState(() => _windowMinSize = size);
          },
          child: const Text("getWindowMinSize"),
        ),
        Text("${_windowMinSize?.width.toInt()}, ${_windowMinSize?.height.toInt()}"),
      ],
    );
  }

  TableRow _rowSetMinWindowSize(double maxEditHeight) {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async => await WindowInterface.setWindowMinSize(
            _setWindowMinWidth,
            _setWindowMinHeight,
          ),
          child: const Text("setWindowMinSize"),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "width: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowMinWidth"),
                onChanged: (value) {
                  int? width = int.tryParse(value);
                  if (width != null) _setWindowMinWidth = width;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "height: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowMinHeight"),
                onChanged: (value) {
                  int? height = int.tryParse(value);
                  if (height != null) _setWindowMinHeight = height;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  TableRow _rowResetMinWindowSize() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async => WindowInterface.resetWindowMinSize(),
          child: const Text("resetWindowMinSize"),
        ),
        const Text("void"),
      ],
    );
  }

  TableRow _rowGetMaxWindowSize() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async {
            var size = await WindowInterface.getWindowMaxSize();
            setState(() => _windowMaxSize = size);
          },
          child: const Text("getWindowMaxSize"),
        ),
        Text("${_windowMaxSize?.width.toInt()}, ${_windowMaxSize?.height.toInt()}"),
      ],
    );
  }

  TableRow _rowSetMaxWindowSize(double maxEditHeight) {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async =>
              WindowInterface.setWindowMaxSize(_setWindowMaxWidth, _setWindowMaxHeight),
          child: const Text("setWindowMaxSize"),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "width: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowMaxWidth"),
                onChanged: (value) {
                  int? width = int.tryParse(value);
                  if (width != null) _setWindowMaxWidth = width;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  prefixText: "height: ",
                  constraints: BoxConstraints(maxHeight: maxEditHeight),
                ),
                controller: TextEditingController(text: "$_setWindowMaxHeight"),
                onChanged: (value) {
                  int? height = int.tryParse(value);
                  if (height != null) _setWindowMaxHeight = height;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  TableRow _rowResetMaxWindowSize() {
    return TableRow(
      children: [
        TextButton(
          onPressed: () async => WindowInterface.resetWindowMaxSize(),
          child: const Text("resetWindowMaxSize"),
        ),
        const Text("void"),
      ],
    );
  }

  TableRow _rowSetStayOnTop() {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: TextButton(
            onPressed: () async => WindowInterface.setStayOnTop(_setTopMost),
            child: const Text("setStayOnTop"),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Switch(
            value: _setTopMost,
            onChanged: (value) {
              setState(() => _setTopMost = value);
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxEditHeight = (Theme.of(context).textTheme.bodyText1?.fontSize ?? 14) * 2 + 10;

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WindowInterface Example'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              children: [
                _rowGetWindowSize(),
                _rowGetMinWindowSize(),
                _rowGetMaxWindowSize(),
                _rowSetWindowSize(maxEditHeight),
                _rowSetMinWindowSize(maxEditHeight),
                _rowResetMinWindowSize(),
                _rowSetMaxWindowSize(maxEditHeight),
                _rowResetMaxWindowSize(),
                _rowToggleFullScreen(),
                _rowGetFullScreen(),
                _rowSetFullScreen(),
                _rowSetStayOnTop(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
