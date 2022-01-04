import 'package:flutter/services.dart';

class RemoveBreakFormatter extends TextInputFormatter {
  static final _lineWrap = RegExp(r"\r\n|\r|\n");

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.contains(_lineWrap)) {
      var text = newValue.text.replaceAll(_lineWrap, '');
      return newValue.copyWith(
        text: text,
        composing: TextRange.empty,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    return newValue;
  }
}
