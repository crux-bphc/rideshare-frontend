import 'package:flutter/services.dart';

extension StringExtensions on String {
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

class CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    final newText = newValue.text.capitalizeWords();
    
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection.copyWith(
        baseOffset: newText.length < newValue.selection.baseOffset ? newText.length : newValue.selection.baseOffset,
        extentOffset: newText.length < newValue.selection.extentOffset ? newText.length : newValue.selection.extentOffset,
      ),
    );
  }
}
