import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _userEmail, _newEmail, _newUsername, _newPassword;
  final LocalUserRepository _userRepository = LocalUserRepository();

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    _userEmail = await _userRepository.getUserEmail() ?? "Невідомий користувач";
    setState(() {});
  }

  // Перевірка правильності емейлу
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Перевірка на відсутність цифр в імені
  bool _isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z]+$');
    return usernameRegex.hasMatch(username);
  }

  // Оновлений метод для збереження змін
  void _saveProfileChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_newEmail != null && _newEmail != _userEmail && _isValidEmail(_newEmail!)) {
        await _userRepository.updateUserEmail(_newEmail!);
      }
      if (_newUsername != null && _isValidUsername(_newUsername!)) {
        await _userRepository.updateUserName(_newUsername!);
      }
      if (_newPassword != null) {
        await _userRepository.updateUserPassword(_newPassword!);
      }
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Створення загальної функції для полів вводу
  Widget _buildInputField({
    required String label,
    bool isPassword = false,
    String? initialValue,
    required void Function(String?) onSave,
    required String? Function(String?) validator,
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        obscureText: isPassword,
        initialValue: initialValue,
        onSaved: onSave,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагування профілю'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fon1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Емейл: $_userEmail', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      const SizedBox(height: 20),
                      // Поле для нового емейлу
                      _buildInputField(
                        label: 'Новий емейл',
                        initialValue: _userEmail,
                        onSave: (value) => _newEmail = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Введіть емейл';
                          if (!_isValidEmail(value)) return 'Невірний формат емейлу';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для нового імені
                      _buildInputField(
                        label: 'Нове ім\'я',
                        onSave: (value) => _newUsername = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Введіть ім\'я';
                          if (!_isValidUsername(value)) return 'Ім\'я не може містити цифр';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Поле для нового паролю
                      _buildInputField(
                        label: 'Новий пароль',
                        isPassword: true,
                        onSave: (value) => _newPassword = value,
                        validator: (value) => value == null || value.isEmpty ? 'Введіть пароль' : null,
                      ),
                      const SizedBox(height: 20),
                      // Кнопка збереження змін
                      ElevatedButton(
                        onPressed: _saveProfileChanges,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text('Зберегти зміни'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
