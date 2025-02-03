import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  final Future<void> Function(String) addTodo;

  const AddTodo({Key? key, required this.addTodo}) : super(key: key);

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> {
  final TextEditingController textController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> saveTodo() async {
    final text = textController.text.trim();

    if (text.isEmpty) {
      // Sprawdzamy, czy widget jest zamontowany przed pokazaniem SnackBara
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Title cannot be empty")),
        );
      }
      return;
    }

    setState(() => isLoading = true);

    try {
      await widget.addTodo(text);
      if (mounted) {
        print("Zadanie dodane: $text"); // Debugging
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
      setState(() => isLoading = false);
      Navigator.pop(context); // Zamykanie bottom sheet po dodaniu zadania
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: textController,
            decoration: const InputDecoration(labelText: 'New Task'),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => saveTodo(),
          ),
          const SizedBox(height: 20),
          isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: saveTodo,
                  child: const Text('Save'),
                ),
        ],
      ),
    );
  }
}
