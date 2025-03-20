import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String _error = "";
  String get error => _error;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up Method
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String role, String name) async {
    try {
      _loading = true;
      notifyListeners();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'role': role,
        });
      }
      return userCredential.user;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Login Method
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
