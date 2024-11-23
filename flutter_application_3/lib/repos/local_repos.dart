import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _usernameKey = 'username';
  static const String _carModelKey = 'carModel';  
  static const String _isLoggedInKey = 'isLoggedIn';
  
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  
  Future<void> registerUser(String email, String username, String password, String carModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email); 
      await prefs.setString(_usernameKey, username); 
      await prefs.setString(_carModelKey, carModel); 

      await _secureStorage.write(key: _passwordKey, value: password); 
      await prefs.setBool(_isLoggedInKey, false); 
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool? isLoggedIn = prefs.getBool(_isLoggedInKey); 

      return isLoggedIn ?? false;
    } catch (e) {
      print('Error checking user login status: $e');
      return false;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error retrieving email: $e');
      return null;
    }
  }

 Future<bool> loginUser(String email, String password) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final String? storedEmail = prefs.getString(_emailKey);
    final String? storedPassword = await _secureStorage.read(key: _passwordKey);

    if (storedEmail == email && storedPassword == password) {
      await setUserLoggedIn(true); 
      return true;
    }
  } catch (e) {
    print('Error during login: $e');
  }
  return false;
}

  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_usernameKey);
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }

  Future<Map<String, String>> getUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString(_emailKey);
      final String? username = prefs.getString(_usernameKey);
      final String? carModel = prefs.getString(_carModelKey);

      return {
        'email': email ?? '',
        'username': username ?? '',
        'carModel': carModel ?? '',
      };
    } catch (e) {
      print('Error retrieving user details: $e');
      return {'email': '', 'username': '', 'carModel': ''};
    }
  }

  Future<void> updateUserPassword(String newPassword) async {
    try {
      await _secureStorage.write(key: _passwordKey, value: newPassword); // Update password
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  Future<void> updateUserEmail(String newEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, newEmail); 
    } catch (e) {
      print('Error updating email: $e');
    }
  }

Future<void> updateUserName(String newUsername) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, newUsername); 
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  // Метод для оновлення моделі авто користувача
  Future<void> updateUserCarModel(String newCarModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_carModelKey, newCarModel); // Update car model
    } catch (e) {
      print('Error updating car model: $e');
    }
  }

  // Метод для видалення даних користувача
  Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_carModelKey);  // Remove car model
      await prefs.remove(_isLoggedInKey); // Remove login status

      await _secureStorage.delete(key: _passwordKey);
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Метод для виходу: очищає дані користувача
 Future<void> logout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');  // Видалення статусу логіну
    await prefs.remove('email');  // Видалення email
    // Тут можна додати код для очищення інших даних користувача
  } catch (e) {
    print('Error logging out: $e');
  }
}


  // Метод для встановлення статусу залогіненості
  // Метод для встановлення статусу залогіненості
Future<void> setUserLoggedIn(bool isLoggedIn) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn); // Встановлюємо статус залогіненості
  } catch (e) {
    print('Error setting login status: $e');
  }}}