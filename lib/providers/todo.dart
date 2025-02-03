import 'package:flutter/material.dart';
import '../models/todo.dart';


class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    addSampleTodos(); // Dodajemy testowe zadania na starcie
  }

 

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: false,
    );
    _todos.add(newTodo); // Poprawione! Teraz używamy add(), zamiast nadpisywania listy
    notifyListeners();
  }

  Future<void> toggleTodo(int id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(completed: !_todos[index].completed);
      notifyListeners();
    }
  }

  Future<void> deleteTodo(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void clearTodos() {
    _todos.clear();
    notifyListeners();
  }

  void addSampleTodos() {
    _todos = [
      const Todo(id: 1, title: 'Zrobić zakupy', completed: false),
      const Todo(id: 2, title: 'Umyć samochód', completed: true),
      const Todo(id: 3, title: 'Napisać raport', completed: false),
    ];
    notifyListeners();
  }
}
