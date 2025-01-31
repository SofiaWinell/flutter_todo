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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: widget.todos.length,
      itemBuilder: (BuildContext context, int index) {
        final todo = widget.todos[index];
        final statusIcon = todo.completed
            ? Icons.check_box
            : Icons.check_box_outline_blank;

        return ListTile(
          key: Key(todo.id.toString()),
          leading: Icon(statusIcon),
          title: Text(todo.title),
          enabled: !todo.completed,
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
