import 'package:aahar/data/model/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<OrderModel> orders = [
    OrderModel(
      orderName: "Meal for 50 People",
      numberOfServings: 50,
      menuItems: [
        MenuItem(name: "Rice", quantity: 5),
        MenuItem(name: "Dal", quantity: 3)
      ],
      shoppingItems: [
        ShoppingItem(itemName: "Rice", quantity: 10),
        ShoppingItem(itemName: "Lentils", quantity: 5)
      ],
      deliveryLocation: "Downtown Shelter",
      deliveryTime: "6:00 PM",
      notes: "Make sure to use less spice",
      status: "Ongoing",
      addedDate: Timestamp.now(),
      updateDate: Timestamp.now(),
    ),
    OrderModel(
      orderName: "Lunch for Homeless",
      numberOfServings: 30,
      menuItems: [
        MenuItem(name: "Chapati", quantity: 30),
        MenuItem(name: "Vegetables", quantity: 5)
      ],
      shoppingItems: [
        ShoppingItem(itemName: "Flour", quantity: 10),
        ShoppingItem(itemName: "Vegetables", quantity: 7)
      ],
      deliveryLocation: "West Center",
      deliveryTime: "12:30 PM",
      notes: "Include extra rotis",
      status: "Pending",
      addedDate: Timestamp.now(),
      updateDate: Timestamp.now(),
    ),
  ];

  final Map<int, bool> expandedState = {};

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'ongoing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final isExpanded = expandedState[index] ?? false;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    order.orderName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Delivery: ${order.deliveryLocation} at ${order.deliveryTime}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: getStatusColor(order.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      expandedState[index] = !isExpanded;
                    });
                  },
                ),
                if (isExpanded)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Number of Servings",
                            order.numberOfServings.toString()),
                        _buildDetailRow(
                            "Added Date", order.addedDate.toDate().toString()),
                        _buildDetailRow("Updated Date",
                            order.updateDate.toDate().toString()),
                        const SizedBox(height: 10),
                        _buildSectionTitle("Menu Items"),
                        _buildListItems(order.menuItems
                            .map((item) => "${item.name} - ${item.quantity}")
                            .toList()),
                        const SizedBox(height: 10),
                        _buildSectionTitle("Shopping Items"),
                        _buildListItems(order.shoppingItems
                            .map(
                                (item) => "${item.itemName} - ${item.quantity}")
                            .toList()),
                        const SizedBox(height: 10),
                        if (order.notes != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("Notes"),
                              Text(order.notes!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black87)),
                            ],
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildListItems(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text("• $item",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black87)),
              ))
          .toList(),
    );
  }
}
