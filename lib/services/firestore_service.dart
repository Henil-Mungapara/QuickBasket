import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FirestoreService {
  FirestoreService._();

  static final _firestore = FirebaseFirestore.instance;

  static String get _uid => FirebaseAuth.instance.currentUser!.uid;

  static CollectionReference get _cartRef =>
      _firestore.collection('cart').doc(_uid).collection('items');

  static Future<void> addToCart(ProductModel product, {int qty = 1}) async {
    final ref = _cartRef.doc(product.id);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.update({'quantity': FieldValue.increment(qty)});
    } else {
      await ref.set({
        'name': product.name,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'quantity': qty,
      });
    }
  }

  static Future<void> updateCartQty(String productId, int newQty) async {
    if (newQty < 1) return;
    await _cartRef.doc(productId).update({'quantity': newQty});
  }

  static Future<void> removeFromCart(String productId) async {
    await _cartRef.doc(productId).delete();
  }

  static Future<void> clearCart() async {
    final batch = _firestore.batch();
    final snaps = await _cartRef.get();
    for (final doc in snaps.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  static Stream<QuerySnapshot> cartStream() => _cartRef.snapshots();

  static Stream<int> cartCountStream() {
    return _cartRef.snapshots().map((snap) {
      int count = 0;
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        count += (data['quantity'] as num?)?.toInt() ?? 1;
      }
      return count;
    });
  }

  static CollectionReference get _wishRef =>
      _firestore.collection('wishlist').doc(_uid).collection('items');

  static Future<void> addToWishlist(ProductModel product) async {
    await _wishRef.doc(product.id).set({
      'name': product.name,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'stock': product.stock,
      'description': product.description,
      'categoryId': product.categoryId,
    });
  }

  static Future<void> removeFromWishlist(String productId) async {
    await _wishRef.doc(productId).delete();
  }

  static Future<bool> toggleWishlist(ProductModel product) async {
    final ref = _wishRef.doc(product.id);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
      return false;
    } else {
      await addToWishlist(product);
      return true;
    }
  }

  static Future<bool> isInWishlist(String productId) async {
    final snap = await _wishRef.doc(productId).get();
    return snap.exists;
  }

  static Stream<QuerySnapshot> wishlistStream() => _wishRef.snapshots();

  static Future<String> placeOrder({
    required String customerName,
    required String customerAddress,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final ref = await _firestore.collection('orders').add({
      'userId': _uid,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'items': items,
      'totalAmount': totalAmount,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    await clearCart();
    return ref.id;
  }

  static Stream<QuerySnapshot> userOrdersStream() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: _uid)
        .snapshots();
  }

  static Stream<DocumentSnapshot> userProfileStream() {
    return _firestore.collection('users').doc(_uid).snapshots();
  }

  static Future<void> updateUserProfile(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(_uid).update(data);
  }
}
