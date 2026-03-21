/// Order model
class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerAddress;
  final List<OrderItem> items;
  final double totalAmount;
  String status; // Pending | Accepted | Out for Delivery | Delivered
  String? deliveryPersonId;
  String? deliveryPersonName;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.items,
    required this.totalAmount,
    this.status = 'Pending',
    this.deliveryPersonId,
    this.deliveryPersonName,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // TODO: Add fromJson / toJson when Firebase Firestore is integrated.

  static List<OrderModel> dummyOrders = [
    OrderModel(
      id: 'ORD-1001',
      customerId: '2',
      customerName: 'Radhu',
      customerAddress: '123 Main St, City',
      items: [
        OrderItem(productName: 'Fresh Apples', quantity: 2, price: 120),
        OrderItem(productName: 'Full Cream Milk', quantity: 1, price: 65),
      ],
      totalAmount: 305,
      status: 'Pending',
    ),
    OrderModel(
      id: 'ORD-1002',
      customerId: '3',
      customerName: 'Jane Smith',
      customerAddress: '456 Oak Ave, Town',
      items: [
        OrderItem(productName: 'Chicken Breast', quantity: 1, price: 250),
        OrderItem(productName: 'Greek Yogurt', quantity: 2, price: 85),
      ],
      totalAmount: 420,
      status: 'Accepted',
      deliveryPersonId: '4',
      deliveryPersonName: 'Radhu',
    ),
    OrderModel(
      id: 'ORD-1003',
      customerId: '2',
      customerName: 'Radhu',
      customerAddress: '123 Main St, City',
      items: [
        OrderItem(productName: 'Orange Juice', quantity: 3, price: 110),
      ],
      totalAmount: 330,
      status: 'Out for Delivery',
      deliveryPersonId: '5',
      deliveryPersonName: 'Ankit Sharma',
    ),
    OrderModel(
      id: 'ORD-1004',
      customerId: '3',
      customerName: 'Jane Smith',
      customerAddress: '456 Oak Ave, Town',
      items: [
        OrderItem(productName: 'Whole Wheat Bread', quantity: 2, price: 45),
        OrderItem(productName: 'Potato Chips', quantity: 1, price: 50),
      ],
      totalAmount: 140,
      status: 'Delivered',
      deliveryPersonId: '4',
      deliveryPersonName: 'Radhu',
    ),
  ];
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
}
