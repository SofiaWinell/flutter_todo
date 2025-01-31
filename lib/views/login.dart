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

    final String? success = await Provider.of<AuthProvider>(context, listen: false)
        .login(email, password);

    if (!mounted) return;

    if (success == null) { // ✅ Jeśli success to null, wyświetlamy błąd
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed.')),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/todos'); // ✅ Logowanie udane
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
              const SizedBox(height: 10), // 🆕 Dodane odstępy
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register'); // 🆕 Przycisk do rejestracji
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



