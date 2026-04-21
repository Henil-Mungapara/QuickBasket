import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignedOrdersScreen extends StatelessWidget {
  const AssignedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assigned Orders'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', whereIn: ['Accepted', 'Out for Delivery'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primary));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text('No orders assigned to you currently.',
                  style: TextStyle(
                      fontSize: 16, color: AppColors.textSecondary)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;
              final order = OrderModel.fromJson(docs[index].id, data);
              return _DeliveryOrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class _DeliveryOrderCard extends StatelessWidget {
  final OrderModel order;
  const _DeliveryOrderCard({required this.order});

  Future<void> _updateStatus(
      BuildContext context, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .update({'status': newStatus});
      if (!context.mounted) return;
      UIHelper.showSnackBar(context, 'Order marked as $newStatus');
    } catch (e) {
      if (!context.mounted) return;
      UIHelper.showSnackBar(context, 'Failed to update status',
          isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Order #${order.id.substring(0, 8).toUpperCase()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(order.status,
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on,
                    color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.customerName,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(order.customerAddress,
                          style: const TextStyle(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UIHelper.customTextButton(
                  text: 'View Details',
                  onPressed: () {},
                ),
                if (order.status == 'Accepted')
                  UIHelper.customButton(
                    text: 'Start Delivery',
                    width: 140,
                    onPressed: () =>
                        _updateStatus(context, 'Out for Delivery'),
                  )
                else if (order.status == 'Out for Delivery')
                  UIHelper.customButton(
                    text: 'Mark Delivered',
                    width: 150,
                    backgroundColor: AppColors.success,
                    onPressed: () =>
                        _updateStatus(context, 'Delivered'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
