import 'package:flutter/material.dart';
import 'package:xinlake_platform_demo/demos/demo_app_info.dart';
import 'package:xinlake_platform_demo/demos/demo_pick_files.dart';

const _demoTitle = "Xinlake-Platform Plugin Demo";
const _demoHead = "Xinlake-Platform";
final _demoList = <String, Widget Function()>{
  "AppInfo": () => const AppInfoDemo(),
  "PickFiles": () => const PickFilesDemo(),
};

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _demoTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        errorColor: Colors.deepOrange,
      ),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({Key? key}) : super(key: key);

  @override
  State<DemoHome> createState() => _DemoState();
}

class _DemoState extends State<DemoHome> {
  String _demoItem = _demoList.keys.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_demoItem),
      ),
      body: Builder(
        builder: (context) {
          var widgetFunc = _demoList[_demoItem] ?? () => const Center(child: Text(_demoTitle));
          return widgetFunc();
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              alignment: Alignment.center,
              child: Text(
                _demoHead,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const Divider(height: 1),
            ..._demoList.entries.map((item) {
              return TextButton(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(item.key, textScaleFactor: 1.2),
                ),
                onPressed: () {
                  setState(() => _demoItem = item.key);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
