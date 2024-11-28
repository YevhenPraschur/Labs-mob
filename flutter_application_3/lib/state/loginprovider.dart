import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';

class LoginProvider extends ChangeNotifier {
  final LocalUserRepository _userRepository = LocalUserRepository();
  final Connectivity _connectivity = Connectivity();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final bool success = await _userRepository.loginUser(email, password);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  Future<void> autoLogin(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final bool success = await login(email, password);

      if (success) {
        // Additional logic after successful auto-login if needed
      }
    }
  }

  // Check connectivity and display dialog
  Future<void> checkConnectivity(BuildContext context) async {
    final ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _showConnectivityDialog(context, 'Немає підключення до інтернету');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      _showConnectivityDialog(context, 'Підключено до мобільної мережі');
    } else if (connectivityResult == ConnectivityResult.wifi) {
      _showConnectivityDialog(context, 'Підключено до Wi-Fi');
    } else {
      _showConnectivityDialog(context, 'Статус інтернету невідомий');
    }
  }

  // Show dialog for network status
  void _showConnectivityDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Статус інтернет-з\'єднання'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
