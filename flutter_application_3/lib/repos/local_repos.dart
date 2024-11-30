import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _usernameKey = 'username';
  static const String _carModelKey = 'carModel';  // Новий ключ для автомобіля

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Оновлений метод реєстрації користувача, який тепер також зберігає модель автомобіля
  Future<void> registerUser(String email, String username, String password, String carModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_carModelKey, carModel);  // Зберігаємо модель автомобіля

      await _secureStorage.write(key: _passwordKey, value: password); 
    } catch (e) {
      print('Error during registration: $e');
    }
  }

  // Метод для логіну користувача
  Future<bool> loginUser(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedEmail = prefs.getString(_emailKey);
      final String? storedPassword = await _secureStorage.read(key: _passwordKey);

      if (storedEmail == email && storedPassword == password) {
        return true;
      }
    } catch (e) {
      print('Error during login: $e');
    }
    return false;
  }

  // Метод для отримання email користувача
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error retrieving email: $e');
      return null;
    }
  }

  // Метод для отримання імені користувача
  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_usernameKey);
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }

  // Метод для отримання деталей користувача (тепер включає автомобіль)
  Future<Map<String, String>> getUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString(_emailKey);
      final String? username = prefs.getString(_usernameKey);
      final String? carModel = prefs.getString(_carModelKey);  // Отримуємо модель автомобіля

      return {
        'email': email ?? '',
        'username': username ?? '',
        'carModel': carModel ?? '',  // Повертаємо модель автомобіля
      };
    } catch (e) {
      print('Error retrieving user details: $e');
      return {'email': '', 'username': '', 'carModel': ''};
    }
  }

  // Метод для оновлення пароля користувача
  Future<void> updateUserPassword(String newPassword) async {
    try {
      await _secureStorage.write(key: _passwordKey, value: newPassword); // Оновлюємо пароль
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  // Метод для оновлення email користувача
  Future<void> updateUserEmail(String newEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, newEmail); // Оновлюємо email
    } catch (e) {
      print('Error updating email: $e');
    }
  }

  // Метод для оновлення імені користувача
  Future<void> updateUserName(String newUsername) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, newUsername); // Оновлюємо ім'я користувача
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  // Метод для оновлення моделі автомобіля
  Future<void> updateUserCarModel(String newCarModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_carModelKey, newCarModel); // Оновлюємо модель автомобіля
    } catch (e) {
      print('Error updating car model: $e');
    }
  }

  // Метод для видалення користувача та його даних
  Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_carModelKey);  // Видаляємо модель автомобіля

      await _secureStorage.delete(key: _passwordKey);
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}