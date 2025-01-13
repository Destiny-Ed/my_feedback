import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? initialText;
  final bool isFilled;
  final bool readOnly;
  final int minLines;
  final int maxLines;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const CustomTextField(
      {super.key,
      required this.hintText,
      this.initialText,
      this.controller,
      this.isFilled = false,
      this.readOnly = false,
      this.onChanged,
      this.minLines = 1,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialText,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        filled: isFilled,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
