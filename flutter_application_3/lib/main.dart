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
  final LocalUserRepository userRepository = LocalUserRepository();
  final bool isLoggedIn = await userRepository.isUserLoggedIn();

  // Запускаємо додаток після перевірки
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: isLoggedIn ? '/home' : '/login', // Якщо користувач залогінений, переходимо на Home, якщо ні - на Login
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
