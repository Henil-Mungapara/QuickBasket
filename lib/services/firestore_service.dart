import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

/// Central Firestore helper for cart, wishlist, and order operations.
/// All paths are scoped to the current authenticated user.
class FirestoreService {
  FirestoreService._();

  static final _firestore = FirebaseFirestore.instance;

  /// Current user UID — throws if not logged in.
  static String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // ──────────────────────────────────────────────────────────────────────
  // CART   users/{uid}/cart/{productId}
  // ──────────────────────────────────────────────────────────────────────

  static CollectionReference get _cartRef =>
      _firestore.collection('users').doc(_uid).collection('cart');

  /// Add product to cart (or increment quantity if already exists).
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

  /// Update quantity of a cart item.
  static Future<void> updateCartQty(String productId, int newQty) async {
    if (newQty < 1) return;
    await _cartRef.doc(productId).update({'quantity': newQty});
  }

  /// Remove a product from cart.
  static Future<void> removeFromCart(String productId) async {
    await _cartRef.doc(productId).delete();
  }

  /// Clear all items from cart.
  static Future<void> clearCart() async {
    final batch = _firestore.batch();
    final snaps = await _cartRef.get();
    for (final doc in snaps.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Real-time cart items stream.
  static Stream<QuerySnapshot> cartStream() => _cartRef.snapshots();

  /// Real-time cart item count.
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

  // ──────────────────────────────────────────────────────────────────────
  // WISHLIST   users/{uid}/wishlist/{productId}
  // ──────────────────────────────────────────────────────────────────────

  static CollectionReference get _wishRef =>
      _firestore.collection('users').doc(_uid).collection('wishlist');

  /// Add product to wishlist.
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

  /// Remove product from wishlist.
  static Future<void> removeFromWishlist(String productId) async {
    await _wishRef.doc(productId).delete();
  }

  /// Toggle wishlist — add if absent, remove if present. Returns new state.
  static Future<bool> toggleWishlist(ProductModel product) async {
    final ref = _wishRef.doc(product.id);
    final snap = await ref.get();
    if (snap.exists) {
      await ref.delete();
      return false; // removed
    } else {
      await addToWishlist(product);
      return true; // added
    }
  }

  /// Check if product is in wishlist.
  static Future<bool> isInWishlist(String productId) async {
    final snap = await _wishRef.doc(productId).get();
    return snap.exists;
  }

  /// Real-time wishlist stream.
  static Stream<QuerySnapshot> wishlistStream() => _wishRef.snapshots();

  // ──────────────────────────────────────────────────────────────────────
  // ORDERS   orders/{orderId}
  // ──────────────────────────────────────────────────────────────────────

  /// Place a new order from current cart, then clear cart.
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

  /// Real-time stream of current user's orders (newest first).
  static Stream<QuerySnapshot> userOrdersStream() {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: _uid)
        .snapshots();
  }

  // ──────────────────────────────────────────────────────────────────────
  // USER PROFILE   users/{uid}
  // ──────────────────────────────────────────────────────────────────────

  /// Get current user's profile data stream.
  static Stream<DocumentSnapshot> userProfileStream() {
    return _firestore.collection('users').doc(_uid).snapshots();
  }
}
