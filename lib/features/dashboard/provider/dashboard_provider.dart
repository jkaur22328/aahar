import 'package:aahar/data/model/order.dart';
import 'package:aahar/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  String _error = "";
  String get error => _error;

  List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  int get totalOrders => _orders.length;
  int get pendingOrders =>
      _orders.where((order) => order.status == Status.pending).length;
  int get ongoingOrders =>
      _orders.where((order) => order.status == Status.ongoing).length;
  int get completedOrders =>
      _orders.where((order) => order.status == Status.completed).length;

  getAllOrders() async {
    try {
      _loading = true;
      notifyListeners();

      final res = await FirebaseFirestore.instance.collection('orders').get();
      _orders = res.docs
          .map((order) => OrderModel.fromMap(order.data(), order.id))
          .toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
