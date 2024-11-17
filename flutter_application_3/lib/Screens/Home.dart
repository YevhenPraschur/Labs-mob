import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalUserRepository _userRepository = LocalUserRepository();
  String _email = '';
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final userDetails = await _userRepository.getUserDetails();
    setState(() {
      _email = userDetails['email'] ?? 'Не вказано';
      _username = userDetails['username'] ?? 'Не вказано';
    });
  }

  void _goToProfile() {
    Navigator.pushNamed(context, '/profile');
  }

  // Функція для виходу з акаунту
  void _logout() async {
    await _userRepository.deleteUser();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Домашня сторінка')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Емейл: $_email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Ім\'я: $_username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
 
              ElevatedButton(
                onPressed: _goToProfile,
                child: Text('Перехід до редагування профілю'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
  
              ElevatedButton(
                onPressed: _logout,
                child: Text('Вийти з акаунту'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
