import 'package:flutter/material.dart';
import 'package:testapp/features/auth/auth_provider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late final AuthProvider authProvider;
  @override
  void initState() {
    authProvider = AuthProvider();
    super.initState();
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("login page "),
          backgroundColor: const Color.fromARGB(255, 151, 196, 233)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "email"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signInWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim());
              },
              child: const Text('Log in'),
            )
          ],
        ),
      ),
    );
  }
}
