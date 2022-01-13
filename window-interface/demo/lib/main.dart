import 'package:flutter/material.dart';
import 'package:window_interface/window_interface.dart';
import 'package:window_interface/window_placement.dart';

void main() {
  runApp(const WindowInterfaceDemo());
}

class WindowInterfaceDemo extends StatefulWidget {
  const WindowInterfaceDemo({Key? key}) : super(key: key);

  @override
  State<WindowInterfaceDemo> createState() => _WindowInterfaceState();
}

class _WindowInterfaceState extends State<WindowInterfaceDemo> {
  // current values
  //
  bool? _isFullScreen;
  Size? _minSize;
  Size? _maxSize;
  WindowPlacement? _windowPlacement;

  // target values
  //
  bool _isTopMost2 = false;
  bool _isFullScreen2 = false;
  int _minWidth2 = 650;
  int _minHeight2 = 500;
  int _maxWidth2 = 1600;
  int _maxHeight2 = 900;

  final _windowPlacement2 = WindowPlacement(
    offsetX: 100,
    offsetY: 100,
    width: 800,
    height: 600,
  );

  Widget _buildPlacementGet() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(children: <InlineSpan>[
                const WidgetSpan(
                  child: Text(
                    'left: ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                WidgetSpan(
                  child: Text("${_windowPlacement?.offsetX}, "),
                ),
                const WidgetSpan(
                  child: Text(
                    'top: ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                WidgetSpan(
                  child: Text("${_windowPlacement?.offsetY}, "),
                ),
                const WidgetSpan(
                  child: Text(
                    'width: ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                WidgetSpan(
                  child: Text("${_windowPlacement?.width}, "),
                ),
                const WidgetSpan(
                  child: Text(
                    'height: ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                WidgetSpan(
                  child: Text("${_windowPlacement?.height}"),
                ),
              ]),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var placement = await WindowInterface.getWindowPlacement();
            setState(() => _windowPlacement = placement);
          },
          child: const Text("getWindowPlacement"),
        ),
      ],
    );
  }

  Widget _buildPlacementSet() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("left"),
                ),
                initialValue: "${_windowPlacement2.offsetX}",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final offsetX = int.tryParse(value);
                    if (offsetX != null) {
                      _windowPlacement2.offsetX = offsetX;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("top"),
                ),
                initialValue: "${_windowPlacement2.offsetY}",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final offsetY = int.tryParse(value);
                    if (offsetY != null) {
                      _windowPlacement2.offsetY = offsetY;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("width"),
                ),
                initialValue: "${_windowPlacement2.width}",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final width = int.tryParse(value);
                    if (width != null) {
                      _windowPlacement2.width = width;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 50,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("height"),
                ),
                initialValue: "${_windowPlacement2.height}",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final height = int.tryParse(value);
                    if (height != null) {
                      _windowPlacement2.height = height;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => await WindowInterface.setWindowPlacement(_windowPlacement2),
          child: const Text("setWindowPlacement"),
        ),
      ],
    );
  }

  Widget _buildFullScreen() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const WidgetSpan(
                child: Text(
                  'full screen: ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              WidgetSpan(
                child: Text("$_isFullScreen"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var isFullScreen = await WindowInterface.getFullScreen();
            setState(() => _isFullScreen = isFullScreen);
          },
          child: const Text("getFullScreen"),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'full screen',
              style: TextStyle(color: Colors.grey),
            ),
            Switch(
              value: _isFullScreen2,
              onChanged: (value) {
                setState(() => _isFullScreen2 = value);
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async => WindowInterface.setFullScreen(_isFullScreen2),
          child: const Text("setFullScreen"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => WindowInterface.toggleFullScreen(),
          child: const Text("toggleFullScreen"),
        ),
      ],
    );
  }

  Widget _buildMinSizeGet() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const WidgetSpan(
                child: Text(
                  'min width: ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              WidgetSpan(
                child: Text("${_minSize?.width.toInt()}, "),
              ),
              const WidgetSpan(
                child: Text(
                  'min height: ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              WidgetSpan(
                child: Text("${_minSize?.height.toInt()}"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var size = await WindowInterface.getWindowMinSize();
            setState(() => _minSize = size);
          },
          child: const Text("getWindowMinSize"),
        ),
      ],
    );
  }

  Widget _buildMinSizeSet() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("min width"),
                ),
                initialValue: "$_minWidth2",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final width = int.tryParse(value);
                    if (width != null) {
                      _minWidth2 = width;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 70,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("height"),
                ),
                initialValue: "$_minHeight2",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final height = int.tryParse(value);
                    if (height != null) {
                      _minHeight2 = height;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => await WindowInterface.setWindowMinSize(
            _minWidth2,
            _minHeight2,
          ),
          child: const Text("setWindowMinSize"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => WindowInterface.resetWindowMinSize(),
          child: const Text("resetWindowMinSize"),
        ),
      ],
    );
  }

  Widget _buildMaxSizeGet() {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: <InlineSpan>[
              const WidgetSpan(
                child: Text(
                  'max width: ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              WidgetSpan(
                child: Text("${_maxSize?.width.toInt()}, "),
              ),
              const WidgetSpan(
                child: Text(
                  'max height: ',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              WidgetSpan(
                child: Text("${_maxSize?.height.toInt()}"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            var size = await WindowInterface.getWindowMaxSize();
            setState(() => _maxSize = size);
          },
          child: const Text("getWindowMaxSize"),
        ),
      ],
    );
  }

  Widget _buildMaxSizeSet() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 70,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("max width"),
                ),
                initialValue: "$_maxWidth2",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final width = int.tryParse(value);
                    if (width != null) {
                      _maxWidth2 = width;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 70,
              child: TextFormField(
                decoration: const InputDecoration(
                  label: Text("max height"),
                ),
                initialValue: "$_maxHeight2",
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value != null) {
                    final height = int.tryParse(value);
                    if (height != null) {
                      _maxHeight2 = height;
                      return null;
                    }
                  }
                  return "Invalid";
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => await WindowInterface.setWindowMaxSize(
            _maxWidth2,
            _maxHeight2,
          ),
          child: const Text("setWindowMaxSize"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async => WindowInterface.resetWindowMaxSize(),
          child: const Text("resetWindowMaxSize"),
        ),
      ],
    );
  }

  Widget _buildSetStayOnTop() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'stay on top',
              style: TextStyle(color: Colors.grey),
            ),
            Switch(
              value: _isTopMost2,
              onChanged: (value) {
                setState(() => _isTopMost2 = value);
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async => WindowInterface.setStayOnTop(_isTopMost2),
          child: const Text("setStayOnTop"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WindowInterface Demo'),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPlacementGet(),
                        _buildPlacementSet(),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildFullScreen(),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMinSizeGet(),
                        _buildMinSizeSet(),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMaxSizeGet(),
                        _buildMaxSizeSet(),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: _buildSetStayOnTop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
