import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();  // Ключ для форми
  String? _email;
  String? _username;
  String? _password;

  final LocalUserRepository _userRepository = LocalUserRepository();

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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введіть пароль';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Підтвердіть пароль';
    }
    if (value != _password) {
      return 'Паролі не збігаються';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _userRepository.registerUser(_email!, _username!, _password!);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Реєстрація')),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Ім\'я'),
                onChanged: (value) => _username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть ім\'я';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: _validatePassword,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Підтвердження паролю'),
                obscureText: true,
                validator: _validateConfirmPassword, 
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
