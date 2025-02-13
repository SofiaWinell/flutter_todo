import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Future<void> submit() async {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();

      final bool success = await Provider.of<AuthProvider>(context, listen: false)
          .login(email, password);

      if (!mounted) return;  // Zapewniamy, że kontekst jest jeszcze dostępny.

      if (!success) {  // Jeśli login nie powiedzie się
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed.')),
        );
      } else {
        // Przejdź do ekranu 'todos' jeśli logowanie powiodło się
        Navigator.pushReplacementNamed(context, '/todos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Nie masz konta? Zarejestruj się"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





