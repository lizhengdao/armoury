import 'package:flutter/material.dart';
import 'package:xinlake_platform/xinlake_platform.dart';

class AppInfoDemo extends StatefulWidget {
  const AppInfoDemo({Key? key}) : super(key: key);

  @override
  State<AppInfoDemo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfoDemo> {
  // parameters
  AndroidAppDir _androidDir = AndroidAppDir.internalCache;

  // results
  String? _appVersion;
  DateTime? _appModified;
  String? _appDir;

  bool _enableAndroidDir = false;

  void _getAppVersion() async {
    var verInfo = await XinlakePlatform.getAppVersion();
    int? modified = verInfo?["modified-utc"];
    setState(() {
      _appVersion = verInfo?["version"];
      if (modified != null) {
        _appModified = DateTime.utc(1970, 1, 1, 0, 0, 0, modified, 0).toLocal();
      } else {
        _appModified = null;
      }
    });
  }

  void _getAppDir() async {
    var appDir = await XinlakePlatform.getAppDir(
      appDir: _enableAndroidDir ? _androidDir : null,
    );

    setState(() => _appDir = appDir);
  }

  Widget _buildAppVersion() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              child: const Text("getAppVersion"),
              onPressed: _getAppVersion,
            ),
            const SizedBox(height: 10),
            Text(
              _appVersion ?? "NULL",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            Text(
              _appModified?.toString() ?? "NULL",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDir() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppDirParameter(),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("getAppDir"),
              onPressed: _getAppDir,
            ),
            const SizedBox(height: 10),
            Text(
              _appDir ?? "NULL",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDirParameter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Android app dir"),
            Switch(
              value: _enableAndroidDir,
              onChanged: (value) => setState(() => _enableAndroidDir = value),
            ),
          ],
        ),
        const SizedBox(height: 5),
        DropdownButton<AndroidAppDir>(
          underline: Container(
            height: 1,
            color: Theme.of(context).colorScheme.background,
          ),
          value: _androidDir,
          onChanged: _enableAndroidDir
              ? (newValue) {
                  setState(() => _androidDir = newValue!);
                }
              : null,
          items: AndroidAppDir.values.map<DropdownMenuItem<AndroidAppDir>>((item) {
            return DropdownMenuItem<AndroidAppDir>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: constraints.biggest.aspectRatio > 1.2
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // app version
                    Expanded(child: _buildAppVersion()),
                    // app dir
                    Expanded(child: _buildAppDir()),
                  ],
                )
              : Column(
                  children: [
                    // app version
                    _buildAppVersion(),
                    // app dir
                    _buildAppDir(),
                  ],
                ),
        );
      },
    );
  }
}
