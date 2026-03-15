/// Simple User model for Firestore
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' | 'customer' | 'delivery_person'
  final String phone;
  final String address;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone = '',
    this.address = '',
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
    };
  }
}
