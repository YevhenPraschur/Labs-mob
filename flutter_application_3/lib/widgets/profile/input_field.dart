import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final void Function(String?) onSave;
  final String? Function(String?) validator;
  final bool isPassword;

  const InputField({
    super.key,
    required this.label,
    required this.onSave,
    required this.validator,
    this.initialValue,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        obscureText: isPassword,
        initialValue: initialValue,
        onSaved: onSave,
        validator: validator,
      ),
    );
  }
}
