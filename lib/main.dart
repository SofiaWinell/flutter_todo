import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/todo.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/todos.dart';
import 'package:flutter_todo/views/register.dart';
import 'API/api.dart';

void main() {
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider<TodoProvider>(create: (context) => TodoProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Wywołanie initAuthProvider w initState, co zapobiega błędom związanym z BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Sprawdzamy, czy widget nadal jest zamontowany
      if (mounted) {
        Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isAuthenticated) {
            return const Todos();
          } else {
            return const Login();
          }
        },
      ),
      routes: {
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/todos': (context) => const Todos(),
      },
    );
  }
}

