import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final IconData prefixIcon;
  final String hintText;
  final String labelText;
  final IconData? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;  // Add this line

  const MyTextFormField({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.prefixIcon,
    required this.hintText,
    required this.labelText,
    this.suffixIcon,
    this.onChanged,
    this.validator,  // Add this line
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: onChanged,
      validator: validator,  // Add this line
    );
  }
}