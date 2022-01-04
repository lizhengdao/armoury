import 'package:flutter/material.dart';
import 'package:xinlake_text/generator.dart';

class GeneratorDemo extends StatefulWidget {
  const GeneratorDemo({Key? key}) : super(key: key);

  @override
  State<GeneratorDemo> createState() => _GeneratorDemo();
}

class _GeneratorDemo extends State<GeneratorDemo> {
  String? _password;
  String? _ip;

  Widget _buildRandomPassword() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          child: const Text("randomPassword"),
          onPressed: () {
            setState(() => _password = Generator.randomPassword());
          },
        ),
        Text(
          _password ?? "NULL",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRandomIp() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          child: const Text("randomIp"),
          onPressed: () {
            setState(() => _ip = Generator.randomIp());
          },
        ),
        Text(
          _ip ?? "NULL",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: constraints.biggest.aspectRatio > 1.2
            ? Row(
                children: [
                  Expanded(child: _buildRandomPassword()),
                  const SizedBox(width: 10),
                  Expanded(child: _buildRandomIp()),
                ],
              )
            : Column(
                children: [
                  _buildRandomPassword(),
                  const SizedBox(height: 10),
                  _buildRandomIp(),
                ],
              ),
      );
    });
  }
}
