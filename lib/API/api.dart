import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';

class ApiService {
  final String _authBaseUrl = 'https://reqres.in/api';
  final String _todosBaseUrl = 'https://jsonplaceholder.typicode.com';


 Future<bool> checkAuthStatus() async {
  return false;
}
 Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_authBaseUrl/login'),
        body: {'email': email, 'password': password},
      );
      print('Login response: ${response.body}'); // Debugging
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
      print('Register response: ${response.body}'); // Debugging
      return response.statusCode == 200;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<Todo?> addTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse('$_todosBaseUrl/todos'),
        body: jsonEncode({'title': title, 'completed': false}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('Todo added: ${response.body}');
        return Todo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      print('Error adding todo: $e');
      return null;
    }
  }

  Future<Todo?> toggleTodoStatus(int id, bool completed) async {
    try {
      final response = await http.patch(
        Uri.parse('$_todosBaseUrl/todos/$id'),
        body: jsonEncode({'completed': completed}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Todo updated: ${response.body}');
        return Todo.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update todo status');
      }
    } catch (e) {
      print('Error updating todo: $e');
      return null;
    }
  }

  Future<bool> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_todosBaseUrl/todos/$id'));

      if (response.statusCode == 200) {
        print('Todo deleted.');
        return true;
      } else {
        throw Exception('Failed to delete todo');
      }
    } catch (e) {
      print('Error deleting todo: $e');
      return false;
    }
  }
}

