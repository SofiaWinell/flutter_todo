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
  void _addTodo() async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddTodo(
        addTodo: (title) async {
          if (title.trim().isEmpty) return;
          try {
            await Provider.of<TodoProvider>(context, listen: false).addTodo(title);
            if (!mounted) return;
            setState(() {}); // ✅ Odświeżanie UI po dodaniu zadania
            Navigator.of(ctx).pop();
          } catch (e) {
            print("Błąd dodawania: $e");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.openTodos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: todos.isEmpty
          ? const Center(child: Text("Brak zadań."))
          : TodoList(
              todos: todos,
              onToggle: (todo) async {
                await Provider.of<TodoProvider>(context, listen: false).toggleTodo(todo);
                setState(() {});
              },
              onDelete: (todo) async {
                await Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
                setState(() {});
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
