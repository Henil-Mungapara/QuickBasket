import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../auth/login_screen.dart';
import 'admin_profile_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_products_screen.dart';
import 'manage_orders_screen.dart';
import 'manage_delivery_persons_screen.dart';

/// Admin Dashboard — overview cards and navigation to admin sub-screens.
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Header ──────────────────────────────
            const Text('Welcome, Radhu 👋',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Here\'s your store overview',
                style:
                    TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            // ── Stats Cards ─────────────────────────────────
            _buildStatsGrid(context),
            const SizedBox(height: 28),

            // ── Quick Actions ───────────────────────────────
            const Text('Quick Actions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      title: const Text('Admin Dashboard',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20)),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final stats = [
      {
        'title': 'Total Users',
        'value': '1,240',
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF3498DB),
      },
      {
        'title': 'Total Orders',
        'value': '856',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF8E44AD),
      },
      {
        'title': 'Total Products',
        'value': '320',
        'icon': Icons.inventory_2_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Total Revenue',
        'value': '₹2.4L',
        'icon': Icons.currency_rupee_rounded,
        'color': const Color(0xFFF39C12),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemCount: stats.length,
      itemBuilder: (ctx, i) => _buildStatCard(stats[i]),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (data['color'] as Color).withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (data['color'] as Color).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                Icon(data['icon'] as IconData, color: data['color'] as Color, size: 22),
          ),
          const Spacer(),
          Text(data['value'] as String,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(data['title'] as String,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'title': 'Categories', 'icon': Icons.category_rounded, 'screen': const ManageCategoriesScreen()},
      {'title': 'Products', 'icon': Icons.inventory_2_rounded, 'screen': const ManageProductsScreen()},
      {'title': 'Orders', 'icon': Icons.receipt_long_rounded, 'screen': const ManageOrdersScreen()},
      {'title': 'Delivery', 'icon': Icons.delivery_dining_rounded, 'screen': const ManageDeliveryPersonsScreen()},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: actions.length,
      itemBuilder: (ctx, i) {
        final a = actions[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => a['screen'] as Widget),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a['icon'] as IconData,
                    color: AppColors.primary, size: 28),
                const SizedBox(height: 8),
                Text(a['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        );
      },
    );
  }
}
