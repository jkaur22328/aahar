import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin,
  shopping,
  cooking,
  delivery,
}

class Users {
  final String name;
  final UserRole role;
  final String email;
  final Timestamp createdAt;
  Users({
    required this.name,
    required this.role,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'createdAt': createdAt,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'] ?? '',
      role: map['role'],
      email: map['email'] ?? '',
      createdAt: map['createdAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source));
}
