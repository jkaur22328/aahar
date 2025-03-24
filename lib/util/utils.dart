import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

class UserRole {
  static const String admin = "admin";
  static const String shopping = "shopping";
  static const String cooking = "cooking";
  static const String delivery = "delivery";
}

class Status {
  static const String pending = "pending";
  static const String ongoing = "ongoing";
  static const String completed = "completed";
}

class OrderStage {
  static const String admin = "admin";
  static const String shopping = "shopping";
  static const String cooking = "cooking";
  static const String delivery = "delivery";
  static const String completed = "completed";
  static const String cancelled = "cancelled";
}
