class Todo {
  final int id;
  final String title;
  late final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }

  String get status => completed ? 'closed' : 'open';
  String get value => title;
}

