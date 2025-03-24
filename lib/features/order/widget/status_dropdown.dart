import 'dart:developer';

import 'package:aahar/data/model/order.dart';
import 'package:aahar/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StatusDropdown extends StatefulWidget {
  final OrderModel order;
  final String userRole;

  const StatusDropdown({
    super.key,
    required this.order,
    required this.userRole,
  });

  @override
  State<StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  late String currentStatus;
  final List<String> statusOptions = [
    Status.pending,
    Status.ongoing,
    Status.completed,
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with the provided initial status or default to 'Pending'
    if (widget.userRole == UserRole.shopping) {
      currentStatus = widget.order.shoppingStatus;
    } else if (widget.userRole == UserRole.cooking) {
      currentStatus = widget.order.cookingStatus;
    } else if (widget.userRole == UserRole.delivery) {
      currentStatus = widget.order.deliveryStatus;
    }
    // Validate that the initial status is in our list of options
    if (!statusOptions.contains(currentStatus)) {
      currentStatus = Status.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.userRole.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentStatus,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    currentStatus = newValue;
                  });
                  final doc = FirebaseFirestore.instance
                      .collection('orders')
                      .doc(widget.order.id);
                  if (widget.userRole == UserRole.shopping) {
                    await doc.update(
                      widget.order
                          .copyWith(
                              shoppingStatus: newValue,
                              stage: OrderStage.shopping)
                          .toMap(),
                    );
                  } else if (widget.userRole == UserRole.cooking) {
                    await doc.update(
                      widget.order
                          .copyWith(
                              cookingStatus: newValue,
                              stage: OrderStage.cooking)
                          .toMap(),
                    );
                  } else if (widget.userRole == UserRole.delivery) {
                    await doc.update(
                      widget.order
                          .copyWith(
                              deliveryStatus: newValue,
                              stage: newValue == Status.completed
                                  ? OrderStage.completed
                                  : OrderStage.delivery)
                          .toMap(),
                    );
                  }
                }
              },
              items:
                  statusOptions.map<DropdownMenuItem<String>>((String value) {
                Color statusColor;
                IconData statusIcon;

                // Set color and icon based on status
                switch (value) {
                  case Status.pending:
                    statusColor = Colors.orange;
                    statusIcon = Icons.hourglass_empty;
                    break;
                  case Status.ongoing:
                    statusColor = Colors.blue;
                    statusIcon = Icons.timelapse;
                    break;
                  case Status.completed:
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.circle;
                }

                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        value,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
