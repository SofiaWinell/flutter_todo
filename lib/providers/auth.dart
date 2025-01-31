import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/api.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  String? _token;

  AuthProvider(this._apiService);

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;

  /// Sprawdza, czy użytkownik jest zalogowany po uruchomieniu aplikacji
  Future<void> initAuthProvider() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  /// Logowanie użytkownika
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://reqres.in/api/login'),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _token = data['token'];
        _isAuthenticated = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Błąd logowania: $e");
      return false;
    }
  }

  /// Rejestracja użytkownika
  Future<bool> register(String email, String password) async {
    bool success = await _apiService.register(email, password);
    if (success) {
      _isAuthenticated = false;
    }
    notifyListeners();
    return success;
  }

  /// Wylogowanie użytkownika
  Future<void> logOut() async {
    _isAuthenticated = false;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
