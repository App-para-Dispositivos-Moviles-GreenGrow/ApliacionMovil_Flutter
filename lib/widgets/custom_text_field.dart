import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? togglePasswordVisibility;

  CustomTextField({
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.togglePasswordVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
      obscureText: isPassword && !isPasswordVisible,
      style: TextStyle(color: Colors.black),
    );
  }
}
