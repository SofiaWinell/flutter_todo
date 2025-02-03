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
  // Funkcja odpowiedzialna za dodanie zadania
  void _addTodo() {
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddTodo(
        addTodo: (title) async {
          if (!mounted) return;
          await Provider.of<TodoProvider>(context, listen: false).addTodo(title);
          if (mounted) {
            setState(() {}); // Poprawione! Odświeżenie widoku po dodaniu zadania
            Navigator.of(context).pop(); // Zamykamy modal
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
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}

