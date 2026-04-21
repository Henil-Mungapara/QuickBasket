import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';

class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text('No orders found.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final order = OrderModel.fromJson(docs[index].id, data);
              return _AdminOrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;
  const _AdminOrderCard({required this.order});

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .update({'status': newStatus});
      if (!context.mounted) return;
      UIHelper.showSnackBar(context, 'Order #${order.id.substring(0, 5)} marked as $newStatus');
    } catch (e) {
      if (!context.mounted) return;
      UIHelper.showSnackBar(context, 'Failed to update status', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (order.status == 'Pending') {
      statusColor = AppColors.pending;
    } else if (order.status == 'Accepted') {
      statusColor = AppColors.accepted;
    } else if (order.status == 'Out for Delivery') {
      statusColor = AppColors.outForDelivery;
    } else {
      statusColor = AppColors.delivered;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.person_outline, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(child: Text(order.customerName, style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(child: Text(order.customerAddress, style: const TextStyle(fontSize: 14))),
              ],
            ),
            const SizedBox(height: 16),

            Text('${order.items.length} items', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('Total: ₹${order.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
            
            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == 'Pending')
                  UIHelper.customButton(
                    text: 'Accept Order',
                    onPressed: () => _updateStatus(context, 'Accepted'),
                    width: 140,
                  ),
                if (order.status == 'Accepted')
                  UIHelper.customButton(
                    text: 'Out for Delivery',
                    onPressed: () => _updateStatus(context, 'Out for Delivery'),
                    width: 160,
                  ),
                if (order.status == 'Out for Delivery')
                  UIHelper.customButton(
                    text: 'Mark Delivered',
                    backgroundColor: AppColors.success,
                    onPressed: () => _updateStatus(context, 'Delivered'),
                    width: 150,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
