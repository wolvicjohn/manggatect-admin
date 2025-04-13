import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color focusedColor;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.focusedColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color:
              focusNode.hasFocus ? focusedColor : focusedColor.withOpacity(.8),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(
          Icons.lock,
          color:
              focusNode.hasFocus ? focusedColor : focusedColor.withOpacity(.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusedColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusedColor.withOpacity(.8), width: 1),
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter your password' : null,
    );
  }
}
