import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xinlake_platform/xinlake_platform.dart';

class PickFilesDemo extends StatefulWidget {
  const PickFilesDemo({Key? key}) : super(key: key);

  @override
  State<PickFilesDemo> createState() => _PickFilesState();
}

class _PickFilesState extends State<PickFilesDemo> {
  // parameters
  bool _multiSelection = false;
  String _mimeType = "*/*";
  AndroidAppDir _cacheDir = AndroidAppDir.internalCache;
  bool _cacheOverwrite = false;
  String _openPath = "";
  String _defaultPath = "";
  String _filterName = "All files";
  String _filterPattern = "*.*";

  // result
  List<String>? _pathList;

  bool _enableCache = false;

  late Widget Function() _buildPlatformParameters;

  void _pickFiles() async {
    var pathList = await XinlakePlatform.pickFiles(
      multiSelection: _multiSelection,
      mimeType: _mimeType,
      cacheDir: _enableCache ? _cacheDir : null,
      cacheOverwrite: _cacheOverwrite,
      openPath: _openPath,
      defaultPath: _defaultPath,
      filterName: _filterName,
      filterPattern: _filterPattern,
    );

    setState(() => _pathList = pathList);
  }

  Widget _buildResults() {
    final style = Theme.of(context).textTheme.caption;
    // empty view
    if (_pathList == null) {
      return Center(
        child: Text(
          "NULL",
          textScaleFactor: 2,
          style: style,
        ),
      );
    } else if (_pathList!.isEmpty) {
      return Center(
        child: Text(
          "EMPTY",
          textScaleFactor: 2,
          style: style,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_pathList!.length} ${_pathList!.length > 1 ? "files" : "file"} selected",
          style: style,
        ),
        ..._pathList!.map<Widget>((path) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              path,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ],
    );
  }

  // android
  Widget _buildAndroidParamters() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Mime type"),
          initialValue: _mimeType,
          onChanged: (value) => _mimeType = value,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Cache to"),
            Switch(
              value: _enableCache,
              onChanged: (value) => setState(() => _enableCache = value),
            ),
          ],
        ),
        DropdownButton<AndroidAppDir>(
          underline: Container(
            height: 1,
            color: Theme.of(context).colorScheme.background,
          ),
          value: _cacheDir,
          isDense: true,
          onChanged: _enableCache
              ? (newValue) {
                  setState(() => _cacheDir = newValue!);
                }
              : null,
          items: AndroidAppDir.values.map<DropdownMenuItem<AndroidAppDir>>((item) {
            return DropdownMenuItem<AndroidAppDir>(
              value: item,
              child: Text(item.toString()),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Overwrite cache"),
            Switch(
              value: _cacheOverwrite,
              onChanged: (value) => setState(() => _cacheOverwrite = value),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWindowsParamters() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Open path"),
                initialValue: _openPath,
                onChanged: (value) => _openPath = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Default path"),
                initialValue: _defaultPath,
                onChanged: (value) => _defaultPath = value,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Filter name"),
                initialValue: _filterName,
                onChanged: (value) => _filterName = value,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: "Filter pattern"),
                initialValue: _filterPattern,
                onChanged: (value) => _filterPattern = value,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // all platform
  Widget _buildParameter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Multi selection"),
            Switch(
              value: _multiSelection,
              onChanged: (value) => setState(() => _multiSelection = value),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildParameter(),
          _buildPlatformParameters(),
          const SizedBox(height: 10),
          ElevatedButton(
            child: const Text("pickFiles"),
            onPressed: _pickFiles,
          ),
          const SizedBox(height: 10),
          _buildResults(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _buildPlatformParameters = _buildAndroidParamters;
    } else if (Platform.isWindows) {
      _buildPlatformParameters = _buildWindowsParamters;
    } else {
      _buildPlatformParameters = () => const SizedBox(height: 10);
    }
  }
}
