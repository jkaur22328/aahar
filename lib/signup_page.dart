import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("signup page "),
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
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "email"),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('signup '),
            )
          ],
        ),
      ),
    );
  }
}
