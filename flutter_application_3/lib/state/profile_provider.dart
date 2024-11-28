import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class UserProfileProvider extends ChangeNotifier {
  final LocalUserRepository _userRepository = LocalUserRepository();
  String? _userEmail;
  String? _newEmail;
  String? _newUsername;
  String? _newPassword;

  String? get userEmail => _userEmail;

  // Сетери для нових значень
  void setNewEmail(String? email) {
    _newEmail = email;
    notifyListeners();
  }

  void setNewUsername(String? username) {
    _newUsername = username;
    notifyListeners();
  }

  void setNewPassword(String? password) {
    _newPassword = password;
    notifyListeners();
  }

  // Перевірка валідності форми
  bool isFormValid() {
    print('Checking form validity...');
    // Перевірка на наявність значень у полях та чи вони валідні
    final isValid = _newEmail != null && isValidEmail(_newEmail!) == null &&
                    _newUsername != null && isValidUsername(_newUsername!) == null &&
                    _newPassword != null && _newPassword!.isNotEmpty;
    
    print('Form valid: $isValid');
    return isValid;
  }

  // Метод для оновлення профілю
  Future<void> updateProfile() async {
    bool isUpdated = false;

    print('Updating profile...');
    
    // Оновлюємо email, якщо новий емейл не такий самий і він валідний
    if (_newEmail != null && _newEmail != _userEmail && isValidEmail(_newEmail!) == null) {
      await _userRepository.updateUserEmail(_newEmail!);
      isUpdated = true;
    }

    // Оновлюємо username, якщо ім'я валідне
    if (_newUsername != null && isValidUsername(_newUsername!) == null) {
      await _userRepository.updateUserName(_newUsername!);
      isUpdated = true;
    }

    // Оновлюємо пароль, якщо він не порожній
    if (_newPassword != null && _newPassword!.isNotEmpty) {
      await _userRepository.updateUserPassword(_newPassword!);
      isUpdated = true;
    }

    // Після оновлення профілю перезавантажуємо дані
    if (isUpdated) {
      await loadUserEmail();
      notifyListeners();  // Оновлюємо UI
    } else {
      print('No updates were made.');
    }
  }

  // Завантаження email
  Future<void> loadUserEmail() async {
    _userEmail = await _userRepository.getUserEmail() ?? 'Невідомий користувач';
    print('Loaded email: $_userEmail');
    notifyListeners();
  }

  // Валідація email
  String? isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      print('Invalid email format');
      return 'Невірний формат емейлу';
    }
    return null; // Якщо все ок, повертаємо null
  }

  // Валідація username
  String? isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z]+$');
    if (!usernameRegex.hasMatch(username)) {
      print('Invalid username format');
      return 'Ім\'я не може містити цифр';
    }
    return null; // Якщо все ок, повертаємо null
  }
}
