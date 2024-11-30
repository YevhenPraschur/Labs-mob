import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/Home.dart';
import 'package:flutter_application_3/screens/Login.dart';
import 'package:flutter_application_3/screens/Reg.dart';
import 'package:flutter_application_3/screens/Profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}