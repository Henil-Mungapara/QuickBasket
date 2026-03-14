/// User model — ready for Firestore serialization later.
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' | 'customer' | 'delivery'
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

  // TODO: Add fromJson / toJson when Firebase Firestore is integrated.

  /// Dummy data for UI preview
  static List<UserModel> dummyUsers = [
    UserModel(id: '1', name: 'Admin User', email: 'admin@quickbasket.com', role: 'admin'),
    UserModel(id: '2', name: 'John Doe', email: 'john@email.com', role: 'customer', phone: '9876543210', address: '123 Main St'),
    UserModel(id: '3', name: 'Jane Smith', email: 'jane@email.com', role: 'customer', phone: '9876543211', address: '456 Oak Ave'),
    UserModel(id: '4', name: 'Ravi Kumar', email: 'ravi@email.com', role: 'delivery', phone: '9876543212'),
    UserModel(id: '5', name: 'Ankit Sharma', email: 'ankit@email.com', role: 'delivery', phone: '9876543213'),
  ];
}
