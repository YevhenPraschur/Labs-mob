import 'package:flutter/material.dart';
import 'package:flutter_application_3/state/loginprovider.dart';
import 'package:flutter_application_3/services/auth_service.dart';
import 'package:flutter_application_3/widgets/login/snack_bar.dart';

class AutoLoginButton extends StatelessWidget {
  final LoginProvider provider;

  const AutoLoginButton({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () async {
              final bool isLoggedIn = await AuthService.autoLogin();
              if (isLoggedIn) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                showSnackBar(context, 'Немає даних для автологіну');
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: provider.isLoading
          ? const CircularProgressIndicator()
          : const Text('Перевірити наявність даних для автологіну'),
    );
  }
}
