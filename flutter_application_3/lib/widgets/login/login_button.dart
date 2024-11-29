import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/loginprovider.dart';

class LoginButton extends StatelessWidget {
  final LoginProvider provider;
  final Future<void> Function() onPressed;

  const LoginButton({super.key, required this.provider, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: provider.isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator()
          : const Text('Вхід', style: TextStyle(color: Colors.white)),
    );
  }
}
