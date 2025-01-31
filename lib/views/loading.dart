import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  Future<void> initAuthProvider(BuildContext context) async {
    if (!context.mounted) return;
    await Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {
    initAuthProvider(context);

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do App')),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
