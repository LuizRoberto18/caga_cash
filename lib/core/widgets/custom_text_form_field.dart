import 'package:flutter/material.dart';

import '../app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final bool isObscure;
  final TextEditingController controller;

  const CustomTextField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.body,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: isObscure,
    );
  }
}
