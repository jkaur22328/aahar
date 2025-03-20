import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

// String orderStatusToString(OrderStatus status) {
//   return status.toString().split('.').last; // Converts enum to string
// }

// OrderStatus orderStatusFromString(String status) {
//   return OrderStatus.values.firstWhere(
//     (e) => e.toString().split('.').last == status,
//     orElse: () => OrderStatus.pending, // Default value
//   );
// }

// enum OrderStatus {
//   pending,
//   processing,
//   shoppingInProgress,
//   shoppingCompleted,
//   cookingInProcess,
//   outForDelivery,
//   delivered,
//   cancelled,
// }

class OrderModel {
  final String orderName;
  final int numberOfServings;
  final List<MenuItem> menuItems;
  final List<ShoppingItem> shoppingItems;
  final String deliveryLocation;
  final String deliveryTime;
  final String? notes;
  final String status;
  final Timestamp addedDate;
  final Timestamp updateDate;

  OrderModel({
    required this.orderName,
    required this.numberOfServings,
    required this.menuItems,
    required this.shoppingItems,
    required this.deliveryLocation,
    required this.deliveryTime,
    this.notes,
    this.status = "pending",
    required this.addedDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderName': orderName,
      'numberOfServings': numberOfServings,
      'menuItems': menuItems.map((x) => x.toMap()).toList(),
      'shoppingItems': shoppingItems.map((x) => x.toMap()).toList(),
      'deliveryLocation': deliveryLocation,
      'deliveryTime': deliveryTime,
      'notes': notes,
      'status': status,
      'addedDate': addedDate,
      'updateDate': updateDate,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderName: map['orderName'] ?? '',
      numberOfServings: map['numberOfServings']?.toInt() ?? 0,
      menuItems: List<MenuItem>.from(
          map['menuItems']?.map((x) => MenuItem.fromMap(x))),
      shoppingItems: List<ShoppingItem>.from(
          map['shoppingItems']?.map((x) => ShoppingItem.fromMap(x))),
      deliveryLocation: map['deliveryLocation'] ?? '',
      deliveryTime: map['deliveryTime'] ?? '',
      notes: map['notes'] ?? '',
      status: map['status'] ?? '',
      addedDate: map['addedDate'],
      updateDate: map['updateDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}

class MenuItem {
  final String name;
  final int quantity;
  MenuItem({
    required this.name,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      name: map['name'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
    );
  }
}

class ShoppingItem {
  final String itemName;
  final int quantity;
  final String? unit;
  ShoppingItem({
    required this.itemName,
    required this.quantity,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      unit: map['unit'],
    );
  }
}
