import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';

/// Assigned Orders Screen — accept and change delivery status.
class AssignedOrdersScreen extends StatefulWidget {
  const AssignedOrdersScreen({super.key});

  @override
  State<AssignedOrdersScreen> createState() => _AssignedOrdersScreenState();
}

class _AssignedOrdersScreenState extends State<AssignedOrdersScreen> {
  // TODO: Fetch orders assigned to current delivery person from Firestore
  final List<OrderModel> _orders = List.from(OrderModel.dummyOrders);
  final _statuses = ['Pending', 'Accepted', 'Out for Delivery', 'Delivered'];

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

  int _nextStatusIndex(String current) {
    final idx = _statuses.indexOf(current);
    return idx < _statuses.length - 1 ? idx + 1 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Assigned Orders',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _orders.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined,
                      size: 64, color: AppColors.divider),
                  SizedBox(height: 12),
                  Text('No assigned orders',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
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
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ───────────────────────────
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
                              color:
                                  _statusColor(o.status).withValues(alpha: 0.12),
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

                      // ── Customer info ────────────────────
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(o.customerName,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
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
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ── Items ────────────────────────────
                      ...o.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                                '• ${item.productName} × ${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary)),
                          )),
                      const Divider(height: 20),

                      // ── Actions ──────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Total: ₹${o.totalAmount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.primary)),
                          Row(
                            children: [
                              if (o.status == 'Pending')
                                _actionButton(
                                  label: 'Accept',
                                  color: AppColors.accepted,
                                  icon: Icons.check,
                                  onTap: () {
                                    setState(() {
                                      // TODO: Update in Firestore
                                      o.status = 'Accepted';
                                    });
                                    UIHelper.showSnackBar(
                                        context, 'Order accepted');
                                  },
                                ),
                              if (o.status != 'Delivered') ...[
                                const SizedBox(width: 8),
                                _actionButton(
                                  label: _statuses[_nextStatusIndex(o.status)],
                                  color: _statusColor(
                                      _statuses[_nextStatusIndex(o.status)]),
                                  icon: Icons.arrow_forward,
                                  onTap: () {
                                    setState(() {
                                      // TODO: Update in Firestore
                                      o.status =
                                          _statuses[_nextStatusIndex(o.status)];
                                    });
                                    UIHelper.showSnackBar(context,
                                        'Status updated to ${o.status}');
                                  },
                                ),
                              ],
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

  Widget _actionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
