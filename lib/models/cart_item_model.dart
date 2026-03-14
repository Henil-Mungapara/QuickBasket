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

  // TODO: Add fromJson / toJson when Firebase Firestore is integrated.

  static List<CartItemModel> dummyCart = [
    CartItemModel(productId: '1', productName: 'Fresh Apples', price: 120, quantity: 2, imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&q=80'),
    CartItemModel(productId: '5', productName: 'Full Cream Milk', price: 65, quantity: 1, imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80'),
    CartItemModel(productId: '9', productName: 'Whole Wheat Bread', price: 45, quantity: 3, imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80'),
  ];
}
