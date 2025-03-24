import 'dart:developer';

import 'package:aahar/data/model/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _orderNameController = TextEditingController();
  final _servingsController = TextEditingController();
  final _deliveryLocationController = TextEditingController();
  var _deliveryDateTime = DateTime.now();
  final _deliveryTimeController = TextEditingController();
  final _notesController = TextEditingController();

  // Lists to store menu items and ingredients
  List<MenuItemWidget> menuItems = [];
  List<ShoppingItemWidget> shoppingItems = [];

  @override
  void dispose() {
    _orderNameController.dispose();
    _servingsController.dispose();
    _deliveryLocationController.dispose();
    _deliveryTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<TextEditingController> menuItemNameControllers = [];
  List<TextEditingController> menuItemQuantityControllers = [];
  List<TextEditingController> shoppingItemNameControllers = [];
  List<TextEditingController> shoppingItemQuantityControllers = [];
  List<TextEditingController> shoppingItemUnitControllers = [];

  void _addMenuItem() {
    setState(() {
      var name = TextEditingController();
      var quantity = TextEditingController();
      menuItemNameControllers.add(name);
      menuItemQuantityControllers.add(quantity);

      menuItems.add(MenuItemWidget(
        itemController: name,
        quantityController: quantity,
        onRemove: (MenuItemWidget widget) {
          setState(() {
            menuItems.remove(widget);
          });
        },
      ));
    });
  }

  void _addShoppingItem() {
    setState(() {
      var name = TextEditingController();
      var quantity = TextEditingController();
      var unit = TextEditingController();
      shoppingItemNameControllers.add(name);
      shoppingItemQuantityControllers.add(quantity);
      shoppingItemUnitControllers.add(unit);

      shoppingItems.add(ShoppingItemWidget(
        itemController: name,
        quantityController: quantity,
        unitController: unit,
        onRemove: (ShoppingItemWidget widget) {
          setState(() {
            shoppingItems.remove(widget);
          });
        },
      ));
    });
  }

  Future<void> _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      List<MenuItem> menuItems = [];
      for (var i = 0; i < menuItemNameControllers.length; i++) {
        menuItems.add(MenuItem(
            name: menuItemNameControllers[i].text.trim(),
            quantity: int.parse(menuItemQuantityControllers[i].text.trim())));
      }
      List<ShoppingItem> shoppingItems = [];
      for (var i = 0; i < shoppingItemNameControllers.length; i++) {
        shoppingItems.add(ShoppingItem(
            itemName: shoppingItemNameControllers[i].text.trim(),
            quantity:
                int.parse(shoppingItemQuantityControllers[i].text.trim())));
      }

      var deliveryInfo = DeliveryInfo(
        location: _deliveryLocationController.text.trim(),
        time: Timestamp.fromDate(_deliveryDateTime),
      );

      var order = OrderModel(
        orderName: _orderNameController.text.trim(),
        numberOfServings: int.tryParse(_servingsController.text.trim()) ?? 0,
        menuItems: menuItems,
        shoppingItems: shoppingItems,
        deliveryInfo: deliveryInfo,
        notes: _notesController.text.trim(),
        addedDate: Timestamp.now(),
        updateDate: Timestamp.now(),
      );
      // Process the order

      await FirebaseFirestore.instance.collection('orders').add(order.toMap());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order created successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to order history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Order Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Order Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _orderNameController,
                          decoration: const InputDecoration(
                            labelText: 'Order Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an order name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _servingsController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Servings',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of servings';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Menu Items Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Menu Items',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _addMenuItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...menuItems,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Shopping Items Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Shopping List',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _addShoppingItem,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Item'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...shoppingItems,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Delivery Details Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivery Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _deliveryLocationController,
                          decoration: const InputDecoration(
                            labelText: 'Delivery Location',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter delivery location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          readOnly: true,
                          onTap: () async {
                            final res = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2099));

                            if (res == null) return;
                            _deliveryDateTime = res;
                            setState(() {});
                          },
                          controller: _deliveryTimeController
                            ..text = DateFormat("MMMM dd, yyyy")
                                .format(_deliveryDateTime),
                          decoration: const InputDecoration(
                            labelText: 'Delivery Date',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter delivery time';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Additional Notes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Create Order',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Menu Item Widget
class MenuItemWidget extends StatelessWidget {
  final Function(MenuItemWidget) onRemove;
  final TextEditingController itemController;
  final TextEditingController quantityController;

  const MenuItemWidget({
    super.key,
    required this.onRemove,
    required this.itemController,
    required this.quantityController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    labelText: 'Menu Item',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter menu item';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter quantity';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(this),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Shopping Item Widget
class ShoppingItemWidget extends StatelessWidget {
  final Function(ShoppingItemWidget) onRemove;
  final TextEditingController itemController;
  final TextEditingController quantityController;
  final TextEditingController unitController;

  const ShoppingItemWidget(
      {super.key,
      required this.onRemove,
      required this.itemController,
      required this.quantityController,
      required this.unitController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter quantity';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: unitController,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter unit';
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onRemove(this),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
