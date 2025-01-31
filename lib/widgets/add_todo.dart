import 'package:flutter/material.dart';

class AddTodo extends StatefulWidget {
  final Future<void> Function(String) addTodo; // ✅ Dostosowujemy do async

  const AddTodo({Key? key, required this.addTodo}) : super(key: key);

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> {
  final TextEditingController textController = TextEditingController();
  bool isLoading = false; // ✅ Dodajemy ładowanie

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> saveTodo() async {
    final text = textController.text.trim();
    if (text.isNotEmpty) {
      setState(() => isLoading = true); // ✅ Pokazujemy, że zapisujemy
      try {
        await widget.addTodo(text);
      } catch (e) {
        print('Error adding todo: $e');
      }
      if (!mounted) return;
      setState(() => isLoading = false); // ✅ Resetujemy stan ładowania
      Navigator.pop(context);
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
              ? const CircularProgressIndicator() // ✅ Pokazujemy ładowanie
              : ElevatedButton(
                  onPressed: saveTodo,
                  child: const Text('Save'),
                ),
        ],
      ),
    );
  }
}
