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
  final UserRole type;
  final String emailId;
  final Timestamp createdDate;
  Users({
    required this.name,
    required this.type,
    required this.emailId,
    required this.createdDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'emailId': emailId,
      'createdDate': createdDate,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      name: map['name'] ?? '',
      type: map['type'],
      emailId: map['emailId'] ?? '',
      createdDate: map['createdDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Users.fromJson(String source) => Users.fromMap(json.decode(source));
}
