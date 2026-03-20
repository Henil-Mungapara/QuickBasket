import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import 'invoice_screen.dart';

/// Customer Orders Screen — order history with status.
class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return AppColors.pending;
      case 'Accepted':
        return AppColors.accepted;
      case 'Out for Delivery':
        return AppColors.outForDelivery;
      case 'Delivered':
        return AppColors.delivered;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch orders from Firestore filtered by current user
    final orders = OrderModel.dummyOrders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('My Orders',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: AppColors.divider),
                  SizedBox(height: 12),
                  Text('No orders yet',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (ctx, i) {
                final o = orders[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => InvoiceScreen(order: o))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(o.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textPrimary)),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _statusColor(o.status).withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(o.status,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _statusColor(o.status))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...o.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Text(
                                  '${item.productName} × ${item.quantity}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary)),
                            )),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Total: ₹${o.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.primary)),
                            const Icon(Icons.arrow_forward_ios,
                                size: 16, color: AppColors.textSecondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
