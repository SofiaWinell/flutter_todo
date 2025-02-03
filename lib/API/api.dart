import 'package:http/http.dart' as http;

class ApiService {
  final String _authBaseUrl = 'https://reqres.in/api';

  Future<bool> checkAuthStatus() async {
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/login'),
        body: {'email': email, 'password': password},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/register'),
        body: {'email': email, 'password': password},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
}


