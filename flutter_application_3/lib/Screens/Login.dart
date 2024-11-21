import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  final _userRepository = LocalUserRepository();

  // Перевірка на правильність введених даних
  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool isLoggedIn = await _userRepository.loginUser(_email!, _password!);
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Невірний емейл або пароль.'))
        );
      }
    }
  }

  // Створення полів для вводу даних
  Widget _buildInputField({
    required String label,
    bool isPassword = false,
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
        title: const Text('Вхід'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Фон сторінки
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fon1.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Центрований контент
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
                            // Поле для емейлу
                            _buildInputField(
                              label: 'Емейл',
                              onSave: (value) => _email = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Введіть емейл';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Поле для паролю
                            _buildInputField(
                              label: 'Пароль',
                              isPassword: true,
                              onSave: (value) => _password = value,
                              validator: (value) => value == null || value.isEmpty ? 'Введіть пароль' : null,
                            ),
                            const SizedBox(height: 20),

                            // Кнопка для логіну
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text('Увійти', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 20),

                            // Кнопка для переходу на сторінку реєстрації
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/register');
                              },
                              child: const Text(
                                'Немає акаунту? Зареєструйтесь',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
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
