import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _usernameKey = 'username';
  static const String _carModelKey = 'carModel';  // New key for car model

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Method to register a user
  Future<void> registerUser(String email, String username, String password, String carModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email); // Save email
      await prefs.setString(_usernameKey, username); // Save username
      await prefs.setString(_carModelKey, carModel); // Save car model

      await _secureStorage.write(key: _passwordKey, value: password); // Save password securely
    } catch (e) {
      print('Error registering user: $e');
    }
  }

  // Method to get the user's email
  Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_emailKey);
    } catch (e) {
      print('Error retrieving email: $e');
      return null;
    }
  }

  // Method to log in a user
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

  // Method to get user's username
  Future<String?> getUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_usernameKey);
    } catch (e) {
      print('Error retrieving username: $e');
      return null;
    }
  }

  // Method to get user details
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
Future<void> saveUserDetails(String email, String username, String password, String carModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, email);
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_carModelKey, carModel);  // Зберігаємо модель автомобіля

      await _secureStorage.write(key: _passwordKey, value: password); 
    } catch (e) {
      print('Error saving user details: $e');
    }
  }
  // Method to update user's password
  Future<void> updateUserPassword(String newPassword) async {
    try {
      await _secureStorage.write(key: _passwordKey, value: newPassword); // Update password
    } catch (e) {
      print('Error updating password: $e');
    }
  }

  // Method to update user's email
  Future<void> updateUserEmail(String newEmail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_emailKey, newEmail); // Update email
    } catch (e) {
      print('Error updating email: $e');
    }
  }

  // Method to update user's name
  Future<void> updateUserName(String newUsername) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usernameKey, newUsername); // Update username
    } catch (e) {
      print('Error updating username: $e');
    }
  }

  // Method to update user's car model
  Future<void> updateUserCarModel(String newCarModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_carModelKey, newCarModel); // Update car model
    } catch (e) {
      print('Error updating car model: $e');
    }
  }

  // Method to delete user data
  Future<void> deleteUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_emailKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_carModelKey);  // Remove car model

      await _secureStorage.delete(key: _passwordKey);
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
