/// Cart item model — wraps a product with quantity.
class CartItemModel {
  final String productId;
  final String productName;
  final double price;
  int quantity;
  final String imageUrl;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
    this.imageUrl = '',
  });

  double get total => price * quantity;

  factory CartItemModel.fromJson(String id, Map<String, dynamic> json) {
    double parsedPrice = 0.0;
    if (json['price'] is num) {
      parsedPrice = (json['price'] as num).toDouble();
    } else if (json['price'] is String) {
      parsedPrice = double.tryParse(json['price']) ?? 0.0;
    }

    int parsedQty = 1;
    if (json['quantity'] is num) {
      parsedQty = (json['quantity'] as num).toInt();
    } else if (json['quantity'] is String) {
      parsedQty = int.tryParse(json['quantity']) ?? 1;
    }

    return CartItemModel(
      productId: id,
      productName: json['name']?.toString() ?? '',
      price: parsedPrice,
      quantity: parsedQty,
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  /// Convert to Firestore map.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}
