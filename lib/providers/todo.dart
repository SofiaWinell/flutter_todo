import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _openTodos = [];

  List<Todo> get openTodos => _openTodos;

  // Metoda do pobierania zadań z API
  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        _openTodos = jsonData.map((json) => Todo.fromJson(json)).toList();
        notifyListeners();
      } else {
        throw Exception("Błąd pobierania zadań!");
      }
    } catch (e) {
      print("Błąd w fetchTodos: $e");
    }
  }

  // Metoda do dodawania nowego zadania
  Future<void> addTodo(String title) async {
    try {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        completed: false,
      );
      _openTodos = [..._openTodos, newTodo]; // Kopiujemy listę, żeby Flutter to zauważył
      notifyListeners();
    } catch (e) {
      print("Błąd w addTodo: $e");
    }
  }

  // Metoda do usuwania zadania
  Future<void> deleteTodo(int id) async {
    _openTodos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  // Dodana metoda toggleTodo do zmiany stanu zadania
  Future<void> toggleTodo(Todo todo) async {
    try {
      final todoIndex = _openTodos.indexWhere((t) => t.id == todo.id);
      if (todoIndex >= 0) {
        _openTodos[todoIndex].completed = !_openTodos[todoIndex].completed; // Zmieniamy status zadania
        notifyListeners();  // Powiadamiamy, że dane się zmieniły
      }
    } catch (e) {
      print("Błąd w toggleTodo: $e");
    }
  }
}



