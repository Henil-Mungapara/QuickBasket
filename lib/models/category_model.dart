class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;
  final DateTime? createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.icon = '',
    this.imageUrl = '',
    this.createdAt,
  });

  factory CategoryModel.fromJson(String id, Map<String, dynamic> json) {
    return CategoryModel(
      id: id,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'imageUrl': imageUrl,
      'createdAt':
          createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  static List<CategoryModel> dummyCategories = [
    CategoryModel(
        id: '1',
        name: 'Fruits',
        icon: 'fruit',
        imageUrl: 'assets/images/fruits.png'),
    CategoryModel(
        id: '2',
        name: 'Vegetables',
        icon: 'vegetable',
        imageUrl: 'assets/images/veg.png'),
    CategoryModel(
        id: '3',
        name: 'Dairy',
        icon: 'dairy',
        imageUrl: 'assets/images/milks.png'),
    CategoryModel(
        id: '4',
        name: 'Beverages',
        icon: 'beverage',
        imageUrl: 'assets/images/sodas.png'),
    CategoryModel(
        id: '5',
        name: 'Snacks',
        icon: 'snack',
        imageUrl: 'assets/images/maggie.jpg'),
    CategoryModel(
        id: '6',
        name: 'Bakery',
        icon: 'bakery',
        imageUrl: 'assets/images/besan.png'),
    CategoryModel(
        id: '7',
        name: 'Dry Fruits',
        icon: 'dryfruits',
        imageUrl: 'assets/images/dryfruits.webp'),
    CategoryModel(
        id: '8',
        name: 'Dal & Pulses',
        icon: 'dal',
        imageUrl: 'assets/images/dal.png'),
  ];
}
