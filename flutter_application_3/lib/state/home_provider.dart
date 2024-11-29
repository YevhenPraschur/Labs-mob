import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/repos/local_repos.dart';
import 'package:http/http.dart' as http; 

class HomeProvider extends ChangeNotifier {
  String email = 'Не вказано';
  String username = 'Не вказано';
  String carModel = 'Не вказано';
  
  // Update the type of cars to List<Map<String, dynamic>> 
  List<Map<String, dynamic>> cars = []; 

  final LocalUserRepository _userRepository;
  final bool _isLoggedIn;

  HomeProvider({required LocalUserRepository userRepository, required bool isLoggedIn})
      : _userRepository = userRepository,
        _isLoggedIn = isLoggedIn;

  bool get isLoggedIn => _isLoggedIn;

  // Fetch user details
  Future<void> loadUserDetails() async {
    try {
      final userDetails = await _userRepository.getUserDetails();
      email = userDetails['email'] ?? 'Не вказано';
      username = userDetails['username'] ?? 'Не вказано';
      carModel = userDetails['carModel'] ?? 'Не вказано';
      notifyListeners();
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  // Fetch cars from API
  Future<void> fetchCars() async {
    const url = 'https://www.freetestapi.com/api/v1/cars?limit=3';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Ensure the data is a list of maps, and cast it if necessary
        if (data is List) {
          cars = List<Map<String, dynamic>>.from(data); // Cast the response to the correct type
        } else {
          cars = [];  // If not a list, reset to an empty list
        }
      }
    } catch (_) {
      cars = [];  // If any error occurs, reset to an empty list
    }
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _userRepository.setUserLoggedIn(false);
    Navigator.pushReplacementNamed(context, '/login');
  }
}
