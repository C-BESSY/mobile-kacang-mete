import 'package:flutter/material.dart';

class InputType {
  final String label;
  final TextInputType inputType;
  final TextEditingController textController;
  final String? Function(String, String?) validator;

  InputType(this.label, this.inputType, this.textController)
      : validator = validatedInput;

  InputType.withValidator(
      this.label, this.inputType, this.textController, this.validator);

  static String? validatedInput(label, value) {
    if (value == null || value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }
}
