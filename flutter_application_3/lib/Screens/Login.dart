import 'package:flutter/material.dart';
import '../repos/local_repos.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  final LocalUserRepository _userRepository = LocalUserRepository();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool success = await _userRepository.loginUser(_email!, _password!);
      if (success) {
        Navigator.pushReplacementNamed(context, '/home'); // Переходимо на домашню сторінку
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Невірний емейл або пароль')),
        );
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть емейл';
    }
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Невірний формат емейлу';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Емейл'),
                onChanged: (value) => _email = value,
                validator: _validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _login,
                child: Text('Вхід'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Не маєш аккаунту? Зареєструйся'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
