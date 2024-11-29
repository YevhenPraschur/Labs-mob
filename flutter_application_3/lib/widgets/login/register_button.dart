import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: const Text(
        'Не маєш аккаунту? Зареєструйся',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
