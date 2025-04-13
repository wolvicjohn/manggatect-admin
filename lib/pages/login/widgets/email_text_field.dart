import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color focusedColor;

  const EmailTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.focusedColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color:
              focusNode.hasFocus ? focusedColor : focusedColor.withOpacity(.8),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        prefixIcon: Icon(
          Icons.email,
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
          value == null || value.isEmpty ? 'Please enter your email' : null,
    );
  }
}
