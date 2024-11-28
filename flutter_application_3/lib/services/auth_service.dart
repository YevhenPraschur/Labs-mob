import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Метод для автологіну
  static Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedEmail = prefs.getString('email');
    final String? savedPassword = prefs.getString('password');

    if (savedEmail != null && savedPassword != null) {
      return true;  // Вхід успішний
    } else {
      return false; // Немає збережених даних
    }
  }

  // Метод для збереження даних користувача
  static Future<void> saveUserCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }
}
