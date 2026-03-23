import 'package:cloud_firestore/cloud_firestore.dart';

/// Order model with Firestore serialization.
class OrderModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final String status; // Pending | Accepted | Out for Delivery | Delivered
  final String? deliveryPersonId;
  final String? deliveryPersonName;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.customerName,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    this.status = 'Pending',
    this.deliveryPersonId,
    this.deliveryPersonName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create from Firestore document.
  factory OrderModel.fromJson(String id, Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>?)
            ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    DateTime parsedDate;
    if (json['createdAt'] is Timestamp) {
      parsedDate = (json['createdAt'] as Timestamp).toDate();
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.tryParse(json['createdAt']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return OrderModel(
      id: id,
      userId: json['userId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerAddress: json['customerAddress'] ?? '',
      items: itemsList,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      deliveryPersonId: json['deliveryPersonId'],
      deliveryPersonName: json['deliveryPersonName'],
      createdAt: parsedDate,
    );
  }

  /// Convert to Firestore map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'deliveryPersonId': deliveryPersonId,
      'deliveryPersonName': deliveryPersonName,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}

class OrderItem {
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  /// Create from Firestore map.
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'] ?? '',
      quantity: (json['quantity'] ?? 1).toInt(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  /// Convert to Firestore map.
  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}
