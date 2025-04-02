import 'package:aahar/data/model/order.dart';
import 'package:aahar/features/auth/model/user_model.dart';
import 'package:aahar/features/order/widget/status_dropdown.dart';
import 'package:aahar/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  final UserModel user;

  const OrderDetailPage({super.key, required this.order, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Order #${order.id}'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.support_agent),
          //   onPressed: () {
          //     // TODO: Implement support chat
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderStatusTracker(),
            _buildSectionDivider(),
            if (user.role == UserRole.shopping || user.role == UserRole.admin)
              StatusDropdown(order: order, userRole: UserRole.shopping),
            if (user.role == UserRole.cooking || user.role == UserRole.admin)
              StatusDropdown(order: order, userRole: UserRole.cooking),
            if (user.role == UserRole.delivery || user.role == UserRole.admin)
              StatusDropdown(order: order, userRole: UserRole.delivery),
            _buildOrderDetails(),
            _buildSectionDivider(),
            _buildMenuItems(),
            _buildSectionDivider(),
            _buildShoppingItems(),
            _buildSectionDivider(),
            _buildDeliveryInfo(),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildOrderStatusTracker() {
    // Determine status of each stage
    String shoppingStatus = Status.pending;
    String cookingStatus = Status.pending;
    String deliveryStatus = Status.pending;

    switch (order.stage) {
      case OrderStage.shopping:
        shoppingStatus = Status.ongoing;
        break;
      case OrderStage.cooking:
        shoppingStatus = Status.completed;
        cookingStatus = Status.ongoing;
        break;
      case OrderStage.delivery:
        shoppingStatus = Status.completed;
        cookingStatus = Status.completed;
        deliveryStatus = Status.ongoing;
        break;
      case OrderStage.completed:
        shoppingStatus = Status.completed;
        cookingStatus = Status.completed;
        deliveryStatus = Status.completed;
        break;
      case "OrderStage.cancelled":
        // Handle cancelled order
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildStageIndicator(
                'Shopping',
                1,
                shoppingStatus,
                Icons.shopping_cart,
              ),
              _buildStageLine(shoppingStatus, cookingStatus),
              _buildStageIndicator(
                'Cooking',
                2,
                cookingStatus,
                Icons.restaurant,
              ),
              _buildStageLine(cookingStatus, deliveryStatus),
              _buildStageIndicator(
                'Delivery',
                3,
                deliveryStatus,
                Icons.delivery_dining,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusMessage(),
        ],
      ),
    );
  }

  Widget _buildStageIndicator(
    String title,
    int step,
    String status,
    IconData icon,
  ) {
    Color backgroundColor = Colors.grey;
    Color textColor = Colors.grey;
    Color iconColor = Colors.grey;

    switch (status) {
      case Status.completed:
        backgroundColor = Colors.green;
        textColor = Colors.green;
        iconColor = Colors.white;
        break;
      case Status.ongoing:
        backgroundColor = Colors.blue;
        textColor = Colors.blue;
        iconColor = Colors.white;
        break;
      case Status.pending:
        backgroundColor = Colors.grey[300]!;
        textColor = Colors.grey;
        iconColor = Colors.grey;
        break;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageLine(String startStatus, String endStatus) {
    Color color;
    if (startStatus == Status.completed) {
      color = Colors.green;
    } else {
      color = Colors.grey[300]!;
    }

    return Expanded(
      child: Container(
        height: 3,
        color: color,
      ),
    );
  }

  Widget _buildStatusMessage() {
    String message = "";
    String timeInfo = '';
    Color color = Colors.blue;

    switch (order.stage) {
      case OrderStage.shopping:
        message = 'Your items are being shopped for you';
        color = Colors.blue;
        break;
      case OrderStage.cooking:
        message = 'Your food is being prepared';
        color = Colors.blue;
        break;
      case OrderStage.delivery:
        message = 'Your order is on the way!';
        // if (order.deliveryInfo.estimatedDeliveryTime != null) {
        //   final formatter = DateFormat('h:mm a');
        //   timeInfo = ' (Est. arrival: ${formatter.format(order.deliveryInfo.estimatedDeliveryTime!)})';
        // }
        color = Colors.blue;
        break;
      case OrderStage.completed:
        message = 'Order delivered successfully';
        color = Colors.green;
        break;
      case OrderStage.cancelled:
        message = 'Order has been cancelled';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            order.stage == OrderStage.cancelled
                ? Icons.error
                : Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$message$timeInfo',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    final formatter = DateFormat('MMMM d, yyyy • h:mm a');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Order ID', '#${order.id}'),
          _buildDetailRow(
              'Date & Time', formatter.format(order.addedDate.toDate())),
          // _buildDetailRow('Items', '${order.items.length} items'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingItems() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shopping Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...order.shoppingItems
              .map((item) => _buildShoppingItemCard(item))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu Items',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...order.menuItems.map((item) => _buildmenuItemCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildShoppingItemCard(ShoppingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildmenuItemCard(MenuItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDeliveryInfoRow(Icons.place, 'Delivery Address',
                    order.deliveryInfo.location),
                const Divider(height: 24),
                if (order.deliveryInfo.contact != null &&
                    order.deliveryInfo.contact!.isNotEmpty)
                  _buildDeliveryInfoRow(Icons.phone, 'Contact Number',
                      order.deliveryInfo.contact!),
                if (order.deliveryInfo.notes != null &&
                    order.deliveryInfo.notes!.isNotEmpty)
                  Column(
                    children: [
                      const Divider(height: 24),
                      _buildDeliveryInfoRow(Icons.note, 'Delivery Notes',
                          order.deliveryInfo.notes!),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      height: 8,
      color: Colors.grey[100],
    );
  }

  Widget _buildBottomBar() {
    if (order.stage == OrderStage.completed ||
        order.stage == OrderStage.cancelled) {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement reorder functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reorder',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement cancel order functionality
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement track delivery functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
