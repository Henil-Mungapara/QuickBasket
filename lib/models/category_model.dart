/// Category model
class CategoryModel {
  final String id;
  final String name;
  final String icon; // Material icon name or asset path
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon = '',
    this.imageUrl = '',
  });

  // TODO: Add fromJson / toJson when Firebase Firestore is integrated.

  
  static List<CategoryModel> dummyCategories = [
    CategoryModel(id: '1', name: 'Fruits', icon: 'fruit', imageUrl: 'https://images.unsplash.com/photo-1619566636858-adf3ef46400b?w=200&q=80'),
    CategoryModel(id: '2', name: 'Vegetables', icon: 'vegetable', imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200&q=80'),
    CategoryModel(id: '3', name: 'Dairy', icon: 'dairy', imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=200&q=80'),
    CategoryModel(id: '4', name: 'Beverages', icon: 'beverage', imageUrl: 'https://images.unsplash.com/photo-1534353473418-4cfa6c56fd38?w=200&q=80'),
    CategoryModel(id: '5', name: 'Snacks', icon: 'snack', imageUrl: 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=200&q=80'),
    CategoryModel(id: '6', name: 'Bakery', icon: 'bakery', imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200&q=80'),
    CategoryModel(id: '7', name: 'Meat', icon: 'meat', imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=200&q=80'),
    CategoryModel(id: '8', name: 'Frozen', icon: 'frozen', imageUrl: 'https://images.unsplash.com/photo-1584568694244-14fbdf83bd30?w=200&q=80'),
  ];
}
