import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class RegisterViewModel extends ChangeNotifier {
  final LocalUserRepository _userRepository = LocalUserRepository();

  String? email, username, password, carModel;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  void setIsSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z]+$'); 
    return usernameRegex.hasMatch(username);
  }

  Future<void> register() async {
    // Логування для перевірки значень перед реєстрацією
    print("Email: $email");
    print("Username: $username");
    print("Password: $password");
    print("CarModel: $carModel");

    // Перевірка на null
    if (email == null || username == null || password == null || carModel == null || 
        email!.isEmpty || username!.isEmpty || password!.isEmpty || carModel!.isEmpty) {
      throw Exception('Всі поля повинні бути заповнені');
    }

    // Перевірки на валідність
    if (!isValidEmail(email!)) {
      throw Exception('Невірний формат емейлу');
    }

    if (!isValidUsername(username!)) {
      throw Exception('Ім\'я не може містити цифр');
    }

    setIsSubmitting(true);

    try {
      await _userRepository.registerUser(email!, username!, password!, carModel!);
      await _userRepository.setUserLoggedIn(true);
      final bool isLoggedIn = await _userRepository.loginUser(email!, password!);
      if (isLoggedIn) {
        // Перехід на головну сторінку або оновлення UI
      } else {
        throw Exception('Помилка входу. Спробуйте знову.');
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      setIsSubmitting(false);
    }
  }
}
