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
    CartItemModel(productId: '1', productName: 'Fresh Mango', price: 120, quantity: 2, imageUrl: 'assets/images/mango.png'),
    CartItemModel(productId: '5', productName: 'Full Cream Milk', price: 65, quantity: 1, imageUrl: 'assets/images/milks.png'),
    CartItemModel(productId: '9', productName: 'Besan (Gram Flour)', price: 45, quantity: 3, imageUrl: 'assets/images/besan.png'),
  ];
}
