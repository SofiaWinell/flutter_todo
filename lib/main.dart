import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/views/login.dart';
import 'package:flutter_todo/views/todos.dart';
import 'package:flutter_todo/providers/auth.dart';
import 'package:flutter_todo/providers/todo.dart';
import 'API/api.dart';

void main() {
  final apiService = ApiService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Upewnij się, że AuthProvider jest zainicjowany
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false).initAuthProvider(),
        builder: (context, snapshot) {
          // Jeśli dane są załadowane, przejdź do widoku odpowiedniego ekranu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Wystąpił błąd ładowania.'));
          }

          return Consumer<AuthProvider>(
            builder: (context, auth, child) {
              // Jeśli użytkownik jest zalogowany, przejdź do ekranu todo
              if (auth.isAuthenticated) {
                return const Todos();
              } else {
                // W przeciwnym razie przejdź do ekranu logowania
                return const Login();
              }
            },
          );
        },
      ),
      routes: {
        '/login': (context) => const Login(),
        '/todos': (context) => const Todos(),
      },
    );
  }
}
