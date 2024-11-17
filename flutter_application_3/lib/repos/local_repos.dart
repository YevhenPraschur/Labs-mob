import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _usernameKey = 'username';

  // Реєстрація користувача
  Future<void> registerUser(String email, String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_usernameKey, username);  // Зберігаємо ім'я користувача
    await prefs.setString(_passwordKey, password);
  }

  // Логін користувача
  Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString(_emailKey);
    String? storedPassword = prefs.getString(_passwordKey);

    // Перевіряємо, чи емейл і пароль співпадають з тими, що збережені
    if (storedEmail == email && storedPassword == password) {
      return true;
    }
    return false;
  }

  // Отримання емейла користувача
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey); // Повертаємо емейл користувача
  }

  // Отримання імені користувача
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey); // Повертаємо ім'я користувача
  }

  // Отримання всіх даних користувача (емейл та ім'я)
  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_emailKey);
    String? username = prefs.getString(_usernameKey);

    return {
      'email': email ?? '',
      'username': username ?? '',
    };
  }

  // Зміна паролю користувача
  Future<void> updateUserPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, newPassword);
  }

  // Зміна емейла користувача
  Future<void> updateUserEmail(String newEmail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, newEmail);
  }

  // Зміна імені користувача
  Future<void> updateUserName(String newUsername) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, newUsername);
  }

  // Видалення користувача (наприклад, для виходу)
  Future<void> deleteUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }
}
