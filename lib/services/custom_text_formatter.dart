import 'package:flutter/services.dart';

class CustomTextFormatter extends TextInputFormatter {
  final String mask;
  final List<String> separators;
  final int maxLength;

  CustomTextFormatter({this.mask, this.separators, this.maxLength})
      : assert(
          mask != null,
          separators != null,
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (maxLength != null && newValue.text.length > maxLength)
          return oldValue;
        if (newValue.text.length < mask.length) {
          String matchedSeparator;
          for (final separator in separators) {
            if (mask[newValue.text.length - 1] == separator) {
              matchedSeparator = separator;
              break;
            }
          }
          if (matchedSeparator != null) {
            return TextEditingValue(
              text:
                  '${oldValue.text}$matchedSeparator${newValue.text.substring(newValue.text.length - 1)}',
              selection: TextSelection.collapsed(
                offset: newValue.selection.end + 1,
              ),
            );
          }
        }
      }
    }
    return newValue;
  }
}
