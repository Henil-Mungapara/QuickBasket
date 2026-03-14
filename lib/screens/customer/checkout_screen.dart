import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/cart_item_model.dart';

/// Checkout Screen — order summary and place order.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = CartItemModel.dummyCart;
    final subtotal = cartItems.fold<double>(0, (s, i) => s + i.total);
    const deliveryFee = 30.0;
    final total = subtotal + deliveryFee;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Delivery Address ─────────────────────────
            _sectionCard(
              icon: Icons.location_on_outlined,
              title: 'Delivery Address',
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Home',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('123 Main St, City, State 560001',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  UIHelper.customTextButton(
                      text: 'Change', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Order Summary ────────────────────────────
            _sectionCard(
              icon: Icons.receipt_long,
              title: 'Order Summary',
              child: Column(
                children: [
                  ...cartItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  '${item.productName} × ${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimary)),
                            ),
                            Text(
                                '₹${item.total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                          ],
                        ),
                      )),
                  const Divider(),
                  _summaryRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
                  _summaryRow('Delivery Fee',
                      '₹${deliveryFee.toStringAsFixed(0)}'),
                  const Divider(),
                  _summaryRow('Total', '₹${total.toStringAsFixed(0)}',
                      isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Payment Method ───────────────────────────
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
                    child: const Icon(Icons.credit_card,
                        color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Online Payment',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                        // TODO: Razorpay payment integration will be added here.
                        Text('Razorpay (to be integrated)',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  UIHelper.customTextButton(
                      text: 'Change', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Place Order ──────────────────────────────
            UIHelper.customButton(
              text: 'Place Order  •  ₹${total.toStringAsFixed(0)}',
              width: AppSize.screenWidth(context),
              onPressed: () {
                // TODO: Create order in Firestore and trigger Razorpay payment.
                UIHelper.showSnackBar(context, 'Order placed successfully! 🎉');
                Navigator.pushNamedAndRemoveUntil(
                    context, '/customer-home', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required IconData icon,
      required String title,
      required Widget child}) {
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
}
