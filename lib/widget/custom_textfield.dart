import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.hint,
      this.keyboardType,
      required this.controller,
      this.validator});

  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return "Value cannot be empty";
        } else if (validator != null) {
          return validator!(value);
        }

        return null;
      },
    );
  }
}
