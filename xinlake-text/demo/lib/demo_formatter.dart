import 'package:flutter/material.dart';
import 'package:xinlake_text/formatter.dart';

class FormatterDemo extends StatefulWidget {
  const FormatterDemo({Key? key}) : super(key: key);

  @override
  State<FormatterDemo> createState() => _FormatterState();
}

class _FormatterState extends State<FormatterDemo> {
  static const InputDecoration _decoration = InputDecoration(
    contentPadding: EdgeInsets.only(top: 8, bottom: 4),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: TextFormField(
                maxLines: null,
                scrollController: ScrollController(),
                decoration: _decoration.copyWith(
                  label: const Text("Disallow line break when input"),
                ),
                inputFormatters: [RemoveBreakFormatter()],
              ),
            ),
          ],
        )
      ],
    );
  }
}
