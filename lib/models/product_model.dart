/// Product model
class ProductModel {
  final String id;
  final String name;
  final String categoryId;
  final double price;
  final int stock;
  final String description;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.stock,
    this.description = '',
    this.imageUrl = '',
  });

  // TODO: Add fromJson / toJson when Firebase Firestore is integrated.

  static List<ProductModel> dummyProducts = [
    // ── Fruits (categoryId: '1') ──────────────────────────
    ProductModel(
      id: '1', name: 'Fresh Mango', categoryId: '1', price: 120, stock: 50,
      description: 'Sweet and juicy Alphonso mangoes, freshly picked.',
      imageUrl: 'assets/images/mango.png',
    ),
    ProductModel(
      id: '2', name: 'Green Grapes', categoryId: '1', price: 80, stock: 100,
      description: 'Seedless green grapes, perfectly sweet.',
      imageUrl: 'assets/images/grapes.png',
    ),
    ProductModel(
      id: '12', name: 'Fresh Lemon', categoryId: '1', price: 30, stock: 90,
      description: 'Tangy and fresh lemons, perfect for drinks and cooking.',
      imageUrl: 'assets/images/lemon.webp',
    ),

    // ── Vegetables (categoryId: '2') ──────────────────────
    ProductModel(
      id: '3', name: 'Palak (Spinach)', categoryId: '2', price: 25, stock: 80,
      description: 'Fresh green spinach leaves, washed and ready to cook.',
      imageUrl: 'assets/images/palak.png',
    ),
    ProductModel(
      id: '4', name: 'Tomato', categoryId: '2', price: 30, stock: 120,
      description: 'Vine-ripened tomatoes, perfect for salads and cooking.',
      imageUrl: 'assets/images/tomato.webp',
    ),
    ProductModel(
      id: '13', name: 'Potato', categoryId: '2', price: 25, stock: 200,
      description: 'Fresh potatoes, great for curries and fries.',
      imageUrl: 'assets/images/Potato.jpg',
    ),
    ProductModel(
      id: '14', name: 'Cabbage', categoryId: '2', price: 20, stock: 60,
      description: 'Fresh green cabbage, crisp and healthy.',
      imageUrl: 'assets/images/cabbage.png',
    ),
    ProductModel(
      id: '15', name: 'Capsicum', categoryId: '2', price: 40, stock: 45,
      description: 'Colorful bell peppers, crunchy and fresh.',
      imageUrl: 'assets/images/capsi.png',
    ),
    ProductModel(
      id: '16', name: 'Green Chili', categoryId: '2', price: 15, stock: 100,
      description: 'Spicy green chilies for authentic Indian cooking.',
      imageUrl: 'assets/images/greenchili.png',
    ),
    ProductModel(
      id: '17', name: 'Bhindi (Okra)', categoryId: '2', price: 35, stock: 55,
      description: 'Fresh lady fingers, tender and perfect for stir-fry.',
      imageUrl: 'assets/images/bindi.png',
    ),
    ProductModel(
      id: '18', name: 'Matar (Green Peas)', categoryId: '2', price: 45, stock: 70,
      description: 'Sweet green peas, freshly shelled.',
      imageUrl: 'assets/images/matar.png',
    ),

    // ── Dairy (categoryId: '3') ───────────────────────────
    ProductModel(
      id: '5', name: 'Full Cream Milk', categoryId: '3', price: 65, stock: 60,
      description: 'Fresh full cream milk, 1 litre pack.',
      imageUrl: 'assets/images/milks.png',
    ),
    ProductModel(
      id: '6', name: 'Chocolate Milk', categoryId: '3', price: 85, stock: 40,
      description: 'Rich and creamy chocolate flavored milk.',
      imageUrl: 'assets/images/chocomilk.png',
    ),
    ProductModel(
      id: '19', name: 'Slim Milk', categoryId: '3', price: 55, stock: 50,
      description: 'Low-fat slim milk, healthy and nutritious.',
      imageUrl: 'assets/images/smilk.png',
    ),

    // ── Beverages (categoryId: '4') ───────────────────────
    ProductModel(
      id: '7', name: 'Coca-Cola', categoryId: '4', price: 40, stock: 100,
      description: 'Classic Coca-Cola soft drink, chilled and refreshing.',
      imageUrl: 'assets/images/coke.png',
    ),
    ProductModel(
      id: '20', name: 'Pepsi', categoryId: '4', price: 40, stock: 100,
      description: 'Pepsi soft drink, bold cola taste.',
      imageUrl: 'assets/images/pepsi.png',
    ),
    ProductModel(
      id: '21', name: 'Red Bull', categoryId: '4', price: 125, stock: 35,
      description: 'Red Bull energy drink, gives you wings.',
      imageUrl: 'assets/images/redbul.png',
    ),
    ProductModel(
      id: '22', name: 'Energy Drink', categoryId: '4', price: 110, stock: 40,
      description: 'Refreshing energy drink to keep you active.',
      imageUrl: 'assets/images/energy.png',
    ),
    ProductModel(
      id: '23', name: 'Green Tea', categoryId: '4', price: 90, stock: 55,
      description: 'Premium green tea for a healthy start.',
      imageUrl: 'assets/images/greentea.jpg',
    ),
    ProductModel(
      id: '24', name: 'Tea & Coffee', categoryId: '4', price: 150, stock: 45,
      description: 'Premium tea and coffee combo pack.',
      imageUrl: 'assets/images/cha-coffee.png',
    ),

    // ── Snacks (categoryId: '5') ──────────────────────────
    ProductModel(
      id: '8', name: 'Maggie Noodles', categoryId: '5', price: 14, stock: 200,
      description: '2-minute Maggie noodles, everyone\'s favorite snack.',
      imageUrl: 'assets/images/maggie.jpg',
    ),

    // ── Bakery / Besan (categoryId: '6') ──────────────────
    ProductModel(
      id: '9', name: 'Besan (Gram Flour)', categoryId: '6', price: 45, stock: 70,
      description: 'Pure gram flour for making pakoras and sweets.',
      imageUrl: 'assets/images/besan.png',
    ),

    // ── Dry Fruits (categoryId: '7') ──────────────────────
    ProductModel(
      id: '10', name: 'Almonds', categoryId: '7', price: 350, stock: 30,
      description: 'Premium California almonds, crunchy and healthy.',
      imageUrl: 'assets/images/almond.webp',
    ),
    ProductModel(
      id: '25', name: 'Mixed Dry Fruits', categoryId: '7', price: 500, stock: 20,
      description: 'Assorted dry fruits pack, a healthy snack option.',
      imageUrl: 'assets/images/dryfruits.webp',
    ),

    // ── Dal & Pulses (categoryId: '8') ────────────────────
    ProductModel(
      id: '11', name: 'Toor Dal', categoryId: '8', price: 110, stock: 65,
      description: 'Premium quality toor dal, essential for daily cooking.',
      imageUrl: 'assets/images/toordal.webp',
    ),
    ProductModel(
      id: '26', name: 'Moong Dal', categoryId: '8', price: 95, stock: 55,
      description: 'Yellow moong dal, great for light and healthy meals.',
      imageUrl: 'assets/images/dal.png',
    ),
  ];
}
