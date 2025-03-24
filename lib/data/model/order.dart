import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:aahar/util/utils.dart';

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

// enum OrderStatus { pending, ongoing, completed }

// enum OrderStage { admin, shopping, cooking, delivering, completed, cancelled }

// enum StageStatus { pending, inProgress, completed }

class OrderModel {
  final String? id;
  final String orderName;
  final int numberOfServings;
  final List<MenuItem> menuItems;
  final List<ShoppingItem> shoppingItems;
  final DeliveryInfo deliveryInfo;
  final String? notes;
  final String status; // take order status
  final String stage; // order stage
  final String shoppingStatus;
  final String cookingStatus;
  final String deliveryStatus;
  final Timestamp addedDate;
  final Timestamp updateDate;

  OrderModel({
    this.id,
    required this.orderName,
    required this.numberOfServings,
    required this.menuItems,
    required this.shoppingItems,
    required this.deliveryInfo,
    this.notes,
    this.status = Status.pending,
    this.stage = OrderStage.admin,
    this.shoppingStatus = Status.pending,
    this.cookingStatus = Status.pending,
    this.deliveryStatus = Status.pending,
    required this.addedDate,
    required this.updateDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderName': orderName,
      'numberOfServings': numberOfServings,
      'menuItems': menuItems.map((x) => x.toMap()).toList(),
      'shoppingItems': shoppingItems.map((x) => x.toMap()).toList(),
      'deliveryInfo': deliveryInfo.toMap(),
      'notes': notes,
      'status': status,
      'stage': stage,
      'shoppingStatus': shoppingStatus,
      'cookingStatus': cookingStatus,
      'deliveryStatus': deliveryStatus,
      'addedDate': addedDate,
      'updateDate': updateDate,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      orderName: map['orderName'] ?? '',
      numberOfServings: map['numberOfServings']?.toInt() ?? 0,
      menuItems: List<MenuItem>.from(
          map['menuItems']?.map((x) => MenuItem.fromMap(x))),
      shoppingItems: List<ShoppingItem>.from(
          map['shoppingItems']?.map((x) => ShoppingItem.fromMap(x))),
      deliveryInfo: DeliveryInfo.fromMap(map['deliveryInfo']),
      notes: map['notes'] ?? '',
      status: map['status'],
      stage: map['stage'],
      shoppingStatus: map['shoppingStatus'],
      cookingStatus: map['cookingStatus'],
      deliveryStatus: map['deliveryStatus'],
      addedDate: map['addedDate'],
      updateDate: map['updateDate'],
    );
  }

  // String encoding for URL parameter
  String toParam() => Uri.encodeComponent(jsonEncode(toMap()));

  // Create from URL parameter
  // factory OrderModel.fromParam(String param) {
  //   final decoded = jsonDecode(Uri.decodeComponent(param));
  //   return OrderModel.fromMap(
  //     decoded,
  //   );
  // }

  OrderModel copyWith({
    String? id,
    String? orderName,
    int? numberOfServings,
    List<MenuItem>? menuItems,
    List<ShoppingItem>? shoppingItems,
    DeliveryInfo? deliveryInfo,
    String? notes,
    String? status,
    String? stage,
    String? shoppingStatus,
    String? cookingStatus,
    String? deliveryStatus,
    Timestamp? addedDate,
    Timestamp? updateDate,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderName: orderName ?? this.orderName,
      numberOfServings: numberOfServings ?? this.numberOfServings,
      menuItems: menuItems ?? this.menuItems,
      shoppingItems: shoppingItems ?? this.shoppingItems,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      stage: stage ?? this.stage,
      shoppingStatus: shoppingStatus ?? this.shoppingStatus,
      cookingStatus: cookingStatus ?? this.cookingStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      addedDate: addedDate ?? this.addedDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }
}

class DeliveryInfo {
  final String location;
  final String? contact;
  final String? notes;
  final Timestamp time;
  DeliveryInfo({
    required this.location,
    this.contact,
    this.notes,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'contact': contact,
      'notes': notes,
      'time': time,
    };
  }

  factory DeliveryInfo.fromMap(Map<String, dynamic> map) {
    return DeliveryInfo(
      location: map['location'] ?? '',
      contact: map['contact'] ?? '',
      notes: map['notes'] ?? '',
      time: map['time'],
    );
  }
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
