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
    ProductModel(
      id: '1', name: 'Fresh Apples', categoryId: '1', price: 120, stock: 50,
      description: 'Crisp and juicy red apples, sourced from Himalayan orchards.',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&q=80',
    ),
    ProductModel(
      id: '2', name: 'Organic Bananas', categoryId: '1', price: 45, stock: 100,
      description: 'Farm-fresh organic bananas, naturally ripened.',
      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&q=80',
    ),
    ProductModel(
      id: '3', name: 'Baby Spinach', categoryId: '2', price: 35, stock: 80,
      description: 'Tender baby spinach leaves, washed and ready to eat.',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
    ),
    ProductModel(
      id: '4', name: 'Tomatoes', categoryId: '2', price: 30, stock: 120,
      description: 'Vine-ripened tomatoes, perfect for salads and cooking.',
      imageUrl: 'https://images.unsplash.com/photo-1546470427-0d4db154ceb8?w=400&q=80',
    ),
    ProductModel(
      id: '5', name: 'Full Cream Milk', categoryId: '3', price: 65, stock: 60,
      description: 'Fresh full cream milk, 1 litre pack.',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&q=80',
    ),
    ProductModel(
      id: '6', name: 'Greek Yogurt', categoryId: '3', price: 85, stock: 40,
      description: 'Thick and creamy Greek yogurt, high in protein.',
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&q=80',
    ),
    ProductModel(
      id: '7', name: 'Orange Juice', categoryId: '4', price: 110, stock: 35,
      description: '100% pure orange juice, no added sugar.',
      imageUrl: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=400&q=80',
    ),
    ProductModel(
      id: '8', name: 'Potato Chips', categoryId: '5', price: 50, stock: 90,
      description: 'Crunchy classic salted potato chips.',
      imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&q=80',
    ),
    ProductModel(
      id: '9', name: 'Whole Wheat Bread', categoryId: '6', price: 45, stock: 70,
      description: 'Soft whole wheat bread, freshly baked.',
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    ),
    ProductModel(
      id: '10', name: 'Chicken Breast', categoryId: '7', price: 250, stock: 30,
      description: 'Boneless chicken breast, hygienically packed.',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&q=80',
    ),
    ProductModel(
      id: '11', name: 'Frozen Peas', categoryId: '8', price: 55, stock: 65,
      description: 'Premium quality frozen green peas.',
      imageUrl: 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400&q=80',
    ),
    ProductModel(
      id: '12', name: 'Strawberries', categoryId: '1', price: 150, stock: 25,
      description: 'Sweet and fresh strawberries.',
      imageUrl: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&q=80',
    ),
  ];
}
