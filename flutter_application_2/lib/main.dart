import 'package:flutter/material.dart';
import 'screens/Login.dart';
import 'screens/Reg.dart';
import 'Screens/Profile.dart';
import 'Screens/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}