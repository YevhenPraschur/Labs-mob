import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';
import 'package:flutter_application_3/screens/Home.dart';
import 'package:flutter_application_3/screens/Login.dart';
import 'package:flutter_application_3/screens/Reg.dart';
import 'package:flutter_application_3/screens/Profile.dart';

void main() async {
  // Обов'язково викликаємо ensureInitialized перед ініціалізацією MaterialApp
  WidgetsFlutterBinding.ensureInitialized();

  // Перевірка, чи є збережений користувач
  final LocalUserRepository _userRepository = LocalUserRepository();
  bool isLoggedIn = await _userRepository.isUserLoggedIn();

  // Запускаємо додаток після перевірки
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: isLoggedIn ? '/home' : '/login', // Якщо користувач залогінений, переходимо на Home, якщо ні - на Login
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
