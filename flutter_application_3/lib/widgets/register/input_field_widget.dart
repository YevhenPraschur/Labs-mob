import 'package:flutter/material.dart';

Widget buildInputField({
  required String label,
  required void Function(String?) onSave,
  required String? Function(String?) validator,
  bool isPassword = false,
}) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
      obscureText: isPassword,
      onSaved: onSave,
      validator: validator,
    ),
  );
}
