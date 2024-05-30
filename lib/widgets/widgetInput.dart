import 'package:flutter/material.dart';

class WidgetInput extends StatelessWidget {
  final String labelText;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const WidgetInput({
    super.key,
    required this.labelText,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}