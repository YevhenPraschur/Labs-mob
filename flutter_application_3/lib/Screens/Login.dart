import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalUserRepository _userRepository = LocalUserRepository();
  ConnectivityResult? _connectivityResult; // Використовуємо nullable для ініціалізації
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _loadEmail();
    _initializeConnectivity(); // Ініціалізація з перевіркою початкового стану

    // Реактивне відстеження стану мережі
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });

      // Логіка для реакції на стан мережі
      if (result == ConnectivityResult.none) {
        _showDialog(
          'Помилка з\'єднання',
          'Відсутнє інтернет-з\'єднання. Перевірте підключення.',
          Colors.red,
        );
      } else {
        String connectionType = result == ConnectivityResult.mobile
            ? 'мобільний інтернет'
            : 'Wi-Fi';
        _showDialog(
          'З\'єднання успішне',
          'Встановлено з\'єднання з мережею ($connectionType).',
          Colors.green,
        );
      }
    });
  }

  /// Ініціалізація початкового стану мережі
  Future<void> _initializeConnectivity() async {
    try {
      _connectivityResult = await Connectivity().checkConnectivity();
      setState(() {}); // Оновлюємо стан інтерфейсу

      // Перевіряємо початковий стан
      if (_connectivityResult == ConnectivityResult.none) {
        _showDialog(
          'Помилка з\'єднання',
          'Немає з\'єднання з інтернетом. Будь ласка, перевірте ваше з\'єднання.',
          Colors.red,
        );
      } else {
        String connectionType = _connectivityResult == ConnectivityResult.mobile
            ? 'мобільний інтернет'
            : 'Wi-Fi';
        _showDialog(
          'З\'єднання успішне',
          'Встановлено з\'єднання з мережею ($connectionType).',
          Colors.green,
        );
      }
    } catch (e) {
      _showDialog(
        'Помилка',
        'Не вдалося визначити стан мережі. Спробуйте ще раз.',
        Colors.red,
      );
    }
  }

  void _loadEmail() async {
    String? savedEmail = await _userRepository.getUserEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
    }
  }

  Future<void> _login() async {
    // Актуальна перевірка перед логіном
    ConnectivityResult currentResult = await Connectivity().checkConnectivity();

    if (currentResult == ConnectivityResult.none) {
      _showDialog(
        'Помилка з\'єднання',
        'Немає з\'єднання з інтернетом. Будь ласка, перевірте ваше з\'єднання.',
        Colors.red,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      final bool success = await _userRepository.loginUser(email, password);

      if (success) {
        _showSnackBar('Ви успішно увійшли!', Colors.green);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackBar('Невірний емейл або пароль.', Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: color)),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _showDialog(String title, String message, Color color) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: TextStyle(color: color)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputField({
    required String label,
    bool isPassword = false,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        controller: controller,
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
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Stack(
        children: [
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
                              controller: _emailController,
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Введіть емейл' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildInputField(
                              label: 'Пароль',
                              isPassword: true,
                              controller: _passwordController,
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'Введіть пароль' : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Вхід', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/register');
                              },
                              child: const Text(
                                'Не маєш аккаунту? Зареєструйся',
                                style: TextStyle(color: Colors.white),
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
