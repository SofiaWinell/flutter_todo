import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoList extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) onToggle;
  final Function(Todo) onDelete;

  const TodoList({
    Key? key,
    required this.todos,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Jeśli chcesz obsługiwać przewijanie (np. ładowanie kolejnych zadań)
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // Możesz dodać logikę ładowania kolejnych elementów, jeśli potrzebujesz.
    }
  }

  @override
  Widget build(BuildContext context) {
    // Proste sprawdzenie, czy lista 'todos' nie jest pusta
    if (widget.todos.isEmpty) {
      return const Center(child: Text('Brak zadań do wyświetlenia.'));
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = widget.todos[index];
        final statusIcon = todo.completed
            ? Icons.check_box
            : Icons.check_box_outline_blank;

        return ListTile(
          key: Key(todo.id.toString()), // Klucz dla każdego elementu (ważne przy dynamicznej liście)
          leading: Icon(statusIcon),
          title: Text(todo.title),
          enabled: !todo.completed, // Wyłącza kliknięcie na ukończonym zadaniu
          onTap: () => widget.onToggle(todo),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => widget.onDelete(todo),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(color: Colors.black38),
    );
  }
}
