import 'package:flutter/material.dart';
import '../models/todo.dart';


class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  // Funkcja do pobierania zadań (jeśli potrzebujesz)
  Future<void> fetchTodos() async {
    // Tutaj możesz dodać logikę pobierania danych, ale ja nie chcę tego robić
    notifyListeners(); 
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      completed: false,
    );
    _todos = [..._todos, newTodo]; 
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


  // Dodatkowe funkcje pomocnicze (opcjonalne)

  // Funkcja do zapisywania zadań (np. do lokalnego pliku)
  Future<void> saveTodos() async {
    // Implementacja zapisu
  }

  // Funkcja do ładowania zadań (np. z lokalnego pliku)
  Future<void> loadTodos() async {
    // Implementacja odczytu
    notifyListeners(); // Po załadowaniu danych, powiadom słuchaczy
  }


  // Funkcja do czyszczenia listy (opcjonalna)
  void clearTodos() {
    _todos.clear();
    notifyListeners();
  }


  // Funkcja do testowania - dodaje kilka przykładowych zadań
  void addSampleTodos() {
    _todos.addAll([
      Todo(id: 1, title: 'Zrobić zakupy', completed: false),
      Todo(id: 2, title: 'Umyć samochód', completed: true),
      Todo(id: 3, title: 'Napisać raport', completed: false),
    ]);
    notifyListeners();
  }
}