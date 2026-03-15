import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';

/// Manage Orders Screen — view orders, assign delivery, change status.
class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final List<OrderModel> _orders = List.from(OrderModel.dummyOrders);
  List<UserModel> _deliveryPersons = [];
  final _statuses = ['Pending', 'Accepted', 'Out for Delivery', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _loadDeliveryPersons();
  }

  // Load delivery persons from Firestore
  Future<void> _loadDeliveryPersons() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'delivery_person')
          .get();

      setState(() {
        _deliveryPersons = snapshot.docs.map((doc) {
          return UserModel.fromJson(
              doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (_) {}
  }

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

  void _changeStatus(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Change Order Status',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ..._statuses.map((s) => ListTile(
                  onTap: () {
                    setState(() {
                      // TODO: Update in Firestore
                      _orders[index].status = s;
                    });
                    Navigator.pop(ctx);
                    UIHelper.showSnackBar(context, 'Status updated to $s');
                  },
                  leading: CircleAvatar(
                    radius: 6,
                    backgroundColor: _statusColor(s),
                  ),
                  title: Text(s,
                      style: TextStyle(
                          fontWeight: _orders[index].status == s
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: AppColors.textPrimary)),
                  trailing: _orders[index].status == s
                      ? const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 20)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  void _assignDelivery(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assign Delivery Person',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ..._deliveryPersons.map((dp) => ListTile(
                  onTap: () {
                    setState(() {
                      // TODO: Update in Firestore
                      _orders[index].deliveryPersonId = dp.id;
                      _orders[index].deliveryPersonName = dp.name;
                    });
                    Navigator.pop(ctx);
                    UIHelper.showSnackBar(
                        context, 'Assigned to ${dp.name}');
                  },
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.delivery_dining,
                        color: AppColors.primary, size: 20),
                  ),
                  title: Text(dp.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  subtitle: Text(dp.phone,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  trailing: _orders[index].deliveryPersonId == dp.id
                      ? const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 20)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Manage Orders',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _orders.isEmpty
          ? const Center(
              child: Text('No orders yet',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (ctx, i) {
                final o = _orders[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header row ─────────────────────
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

                      // ── Customer info ──────────────────
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
                      const SizedBox(height: 10),

                      // ── Items ──────────────────────────
                      ...o.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                                '${item.productName} × ${item.quantity}  ₹${item.total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary)),
                          )),
                      const Divider(height: 20),

                      // ── Footer ─────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total: ₹${o.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: AppColors.textPrimary)),
                          Row(
                            children: [
                              _miniButton(
                                icon: Icons.delivery_dining,
                                label: o.deliveryPersonName ?? 'Assign',
                                onTap: () => _assignDelivery(i),
                              ),
                              const SizedBox(width: 8),
                              _miniButton(
                                icon: Icons.sync_alt,
                                label: 'Status',
                                onTap: () => _changeStatus(i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _miniButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
