import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo.dart';
import '../widgets/add_todo.dart';
import '../widgets/todo_list.dart';

class Todos extends StatefulWidget {
  const Todos({Key? key}) : super(key: key);

  @override
  TodosState createState() => TodosState();
}

class TodosState extends State<Todos> {
  bool isLoading = false;  // Zmienna isLoading do kontrolowania stanu ładowania

  // Funkcja odpowiedzialna za dodanie zadania
  void _addTodo() {
    if (!mounted) return;  // Sprawdzamy, czy widget jest zamontowany przed wywołaniem

    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddTodo(
        addTodo: (title) async {
          if (!mounted) return; // Sprawdzamy, czy widget jest zamontowany przed wywołaniem

          // Dodajemy dodatkowe sprawdzenie, czy tytuł nie jest pusty
          if (title.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Title cannot be empty")),
            );
            return;
          }

          setState(() {
            isLoading = true;  // Pokazujemy stan ładowania
          });

          try {
            // Wywołujemy funkcję addTodo i logujemy w konsoli
            await Provider.of<TodoProvider>(context, listen: false).addTodo(title);
            if (mounted) {
              print("Zadanie dodane: $title");  // Debugging
            }
          } catch (e) {
            if (mounted) {
              print("Błąd dodawania zadania: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error adding task")),
              );
            }
          }

          if (mounted) {
            setState(() {
              isLoading = false;  // Resetujemy stan ładowania
            });
            Navigator.of(context).pop();  // Zamykamy modal po dodaniu zadania
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = todoProvider.todos;
          return todos.isEmpty
              ? const Center(child: Text("Brak zadań."))
              : TodoList(
                  todos: todos,
                  onToggle: (todo) async {
                    await todoProvider.toggleTodo(todo.id);
                  },
                  onDelete: (todo) async {
                    await todoProvider.deleteTodo(todo.id);
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,  // Wywołanie metody _addTodo
        child: const Icon(Icons.add),
      ),
    );
  }
}

