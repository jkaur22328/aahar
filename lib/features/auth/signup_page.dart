import 'package:flutter/material.dart';
import 'package:testapp/features/auth/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
          title: const Text("signup page "),
          backgroundColor: const Color.fromARGB(255, 151, 196, 233)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "name"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authProvider.signInWithEmailAndPassword(
                    _emailController.text.trim(),
                    _passwordController.text.trim());
              },
              child: Text('signup '),
            )
          ],
        ),
      ),
    );
  }
}
