import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/order_model.dart';
import 'package:intl/intl.dart';

/// Delivery Dashboard — assigned orders and completed count from Firestore.
class DeliveryDashboard extends StatelessWidget {
  const DeliveryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Delivery Dashboard',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () =>
                Navigator.pushNamed(context, '/delivery-profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // FIXME: Once auth is linked to delivery person, filter by deliveryPersonId
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', whereIn: ['Accepted', 'Out for Delivery', 'Delivered'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          
          final docs = snapshot.data?.docs ?? [];
          final allOrders = docs.map((doc) => OrderModel.fromJson(doc.id, doc.data() as Map<String, dynamic>)).toList();
          
          final assignedOrders = allOrders.where((o) => o.status != 'Delivered').toList();
          final completedOrders = allOrders.where((o) => o.status == 'Delivered').toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Welcome ─────────────────────────────────
                const Text('Hello, Delivery Partner 👋',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                const Text('Here are your deliveries today',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 24),

                // ── Stats Row ───────────────────────────────
                Row(
                  children: [
                    _statCard('Assigned', '${assignedOrders.length}',
                        Icons.assignment_outlined, AppColors.accepted),
                    const SizedBox(width: 14),
                    _statCard('Completed', '${completedOrders.length}',
                        Icons.check_circle_outline, AppColors.delivered),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Button to Assigned Orders ───────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Assigned Orders',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/delivery-assigned-orders'),
                      child: const Text('View All',
                          style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ── Recent Orders ───────────────────────────
                if (assignedOrders.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.assignment_turned_in_outlined,
                            size: 48, color: AppColors.divider),
                        SizedBox(height: 12),
                        Text('No assigned orders',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ),
                  )
                else
                  ...assignedOrders.take(3).map((o) => _orderCard(context, o)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(value,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _orderCard(BuildContext context, OrderModel o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
              Text('#${o.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accepted.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(o.status,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accepted)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(o.customerName,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(o.customerAddress,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
