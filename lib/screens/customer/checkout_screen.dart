import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/cart_item_model.dart';
import '../../services/firestore_service.dart';
import 'customer_home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _customerNameCtrl = TextEditingController(text: 'Customer Name');
  final _addressCtrl = TextEditingController(text: '123 Main St, City, State 560001');

  bool _isProcessing = false;

  Future<void> _placeOrder(List<CartItemModel> cartItems, double total) async {
    if (cartItems.isEmpty) {
      UIHelper.showSnackBar(context, 'Your cart is empty', isError: true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final items = cartItems.map((item) => item.toJson()).toList();
      await FirestoreService.placeOrder(
        customerName: _customerNameCtrl.text.trim(),
        customerAddress: _addressCtrl.text.trim(),
        items: items,
        totalAmount: total,
      );

      if (!mounted) return;
      UIHelper.showSnackBar(context, 'Order placed successfully! 🎉');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      UIHelper.showSnackBar(context, 'Failed to place order: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Checkout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.cartStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final docs = snapshot.data?.docs ?? [];
          final cartItems = docs
              .map((doc) => CartItemModel.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          final subtotal = cartItems.fold<double>(0, (s, i) => s + i.total);
          const deliveryFee = 30.0;
          final total = cartItems.isEmpty ? 0.0 : subtotal + deliveryFee;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionCard(
                  icon: Icons.location_on_outlined,
                  title: 'Delivery Address',
                  child: Column(
                    children: [
                      TextField(
                        controller: _customerNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _addressCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Full Address',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                _sectionCard(
                  icon: Icons.receipt_long,
                  title: 'Order Summary',
                  child: cartItems.isEmpty
                      ? const Text('Your cart is empty', style: TextStyle(color: AppColors.textSecondary))
                      : Column(
                          children: [
                            ...cartItems.map((item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            '${item.productName} × ${item.quantity}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: AppColors.textPrimary)),
                                      ),
                                      Text('₹${item.total.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary)),
                                    ],
                                  ),
                                )),
                            const Divider(),
                            _summaryRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
                            _summaryRow('Delivery Fee', '₹${deliveryFee.toStringAsFixed(0)}'),
                            const Divider(),
                            _summaryRow('Total', '₹${total.toStringAsFixed(0)}', isBold: true),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

                _sectionCard(
                  icon: Icons.payment,
                  title: 'Payment Method',
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.credit_card, color: AppColors.accent),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cash on Delivery',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                            Text('Pay when you receive the order',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _isProcessing
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : UIHelper.customButton(
                        text: cartItems.isEmpty ? 'Cart is Empty' : 'Place Order  •  ₹${total.toStringAsFixed(0)}',
                        width: AppSize.screenWidth(context),
                        onPressed: cartItems.isEmpty
                            ? () {}
                            : () => _placeOrder(cartItems, total),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionCard(
      {required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.textPrimary)),
          Text(value,
              style: TextStyle(
                  fontSize: isBold ? 18 : 14,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                  color: isBold ? AppColors.primary : AppColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customerNameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
}
