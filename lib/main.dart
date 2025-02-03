import 'package:flutter/material.dart';
import 'package:flutter_todo/views/register.dart';
import 'package:provider/provider.dart';

import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/todo.dart';

import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/todos.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isAuthenticated) {
            return const Todos();
          } else {
            return const Login(); // warunek na rejestrację
          }
        },
      ),
      routes: {
        '/register': (context) => const Register(), // trasę do rejestracji
        '/login': (context) => const Login(),
        '/todos': (context) => const Todos(),
      },
    );
  }
}



