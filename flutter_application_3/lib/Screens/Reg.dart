import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _username, _password, _carModel;
  final _userRepository = LocalUserRepository();

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z]+$'); 
    return usernameRegex.hasMatch(username);
  }

void _register() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    await _userRepository.registerUser(
      _email!,
      _username!,
      _password!,
      _carModel!,
    );
    await _userRepository.setUserLoggedIn(true);  
    final bool isLoggedIn = await _userRepository.loginUser(_email!, _password!);
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Помилка входу. Спробуйте знову.')),
      );
    }
  }
}

  Widget _buildInputField({
    required String label,
    required void Function(String?) onSave, required String? Function(String?) validator, bool isPassword = false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            _buildInputField(
                              label: 'Емейл',
                              onSave: (value) => _email = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Введіть емейл';
                                if (!_isValidEmail(value)) return 'Невірний формат емейлу';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              label: 'Ім\'я',
                              onSave: (value) => _username = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Введіть ім\'я';
                                if (!_isValidUsername(value)) return 'Ім\'я не може містити цифр';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            _buildInputField(
                              label: 'Пароль',
                              isPassword: true,
                              onSave: (value) => _password = value,
                              validator: (value) => value == null || value.isEmpty ? 'Введіть пароль' : null,
                            ),
                            const SizedBox(height: 16),

                            _buildInputField(
                              label: 'На якому авто ви їздите?',
                              onSave: (value) => _carModel = value,
                              validator: (value) => value == null || value.isEmpty ? 'Введіть марку авто' : null,
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text('Зареєструватися', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
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
