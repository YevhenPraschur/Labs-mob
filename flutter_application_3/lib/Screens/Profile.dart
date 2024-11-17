import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail;
  String? _newEmail;
  String? _newUsername;
  String? _newPassword;

  final LocalUserRepository _userRepository = LocalUserRepository();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    String? email = await _userRepository.getUserEmail();
    setState(() {
      _userEmail = email ?? "Невідомий користувач";
    });
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
  void _saveProfileChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_newEmail != null && _newEmail != _userEmail) {
        await _userRepository.updateUserEmail(_newEmail!);
      }
      if (_newUsername != null) {
        await _userRepository.updateUserName(_newUsername!);
      }
      if (_newPassword != null) {
        await _userRepository.updateUserPassword(_newPassword!);
      }
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Редагування профілю')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Емейл: $_userEmail',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(labelText: 'Новый емейл'),
                initialValue: _userEmail,
                onChanged: (value) => _newEmail = value,
                validator: _validateEmail,
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(labelText: 'Нове ім\'я'),
                onChanged: (value) => _newUsername = value,
              ),
              SizedBox(height: 20),

              TextFormField(
                decoration: InputDecoration(labelText: 'Новий пароль'),
                obscureText: true,
                onChanged: (value) => _newPassword = value,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveProfileChanges,
                child: Text('Зберегти зміни'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
