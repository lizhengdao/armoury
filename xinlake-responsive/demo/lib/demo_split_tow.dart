import 'dart:io';

import 'package:flutter/material.dart';
import 'package:xinlake_responsive/split_two.dart';

class SplitTwoDemo extends StatefulWidget {
  const SplitTwoDemo({Key? key}) : super(key: key);

  @override
  State<SplitTwoDemo> createState() => _SplitTwoState();
}

class _SplitTwoState extends State<SplitTwoDemo> {
  late bool _isMobile;
  late bool _isPortrait;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Switch(
          value: _isPortrait,
          onChanged: (value) => setState(() => _isPortrait = value),
        ),
        Expanded(
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white, // have to set color on web
              fontSize: 100,
            ),
            child: SplitTwo(
              childA: const Center(child: Text("A")),
              childB: const Center(child: Text("B")),
              isPortrait: _isPortrait,
              dividerSize: _isMobile ? 20 : 5,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    try {
      _isMobile = Platform.isAndroid || Platform.isIOS;
    } catch (error) {
      // dart.io don't support web
      _isMobile = false;
    }

    _isPortrait = _isMobile;
  }
}
