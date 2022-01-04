import 'package:flutter/material.dart';
import 'package:xinlake_text/readable.dart';

class ReadableDemo extends StatefulWidget {
  const ReadableDemo({Key? key}) : super(key: key);

  @override
  State<ReadableDemo> createState() => _ReadableState();
}

class _ReadableState extends State<ReadableDemo> {
  static const InputDecoration _decoration = InputDecoration(
    contentPadding: EdgeInsets.only(top: 8, bottom: 4),
  );

  String _size = "Invalid value";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: _decoration.copyWith(
                    label: const Text("Readable size"),
                    suffixStyle: const TextStyle(fontStyle: FontStyle.italic),
                    suffixText: _size,
                  ),
                  onChanged: (value) {
                    int? size = int.tryParse(value);
                    if (size != null) {
                      setState(() {
                        _size = Readable.formatSize(size, decimals: 3);
                      });
                    } else {
                      setState(() {
                        _size = "Invalid Value";
                      });
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
