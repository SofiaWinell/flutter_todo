import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _openTodos = [];

  List<Todo> get openTodos => _openTodos;

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

  Future<void> addTodo(String title) async {
    try {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        completed: false,
      );
      _openTodos.add(newTodo);
      notifyListeners();
    } catch (e) {
      print("Błąd w addTodo: $e");
    }
  }

  Future<void> deleteTodo(int id) async {
    _openTodos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }
}


