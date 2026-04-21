import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../auth/login_screen.dart';
import 'admin_profile_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_products_screen.dart';
import 'manage_orders_screen.dart';
import 'manage_delivery_persons_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _userCount = 0;
  int _orderCount = 0;
  int _productCount = 0;
  double _totalRevenue = 0.0;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final db = FirebaseFirestore.instance;

      final usersFuture = db.collection('users').count().get();
      final ordersFuture = db.collection('orders').get();
      final productsFuture = db.collection('products').count().get();

      final results =
          await Future.wait([usersFuture, ordersFuture, productsFuture]);

      final usersSnap = results[0] as AggregateQuerySnapshot;
      final ordersSnap = results[1] as QuerySnapshot;
      final productsSnap = results[2] as AggregateQuerySnapshot;

      double revenue = 0;
      for (var doc in ordersSnap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        revenue += (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
      }

      if (mounted) {
        setState(() {
          _userCount = usersSnap.count ?? 0;
          _orderCount = ordersSnap.docs.length;
          _productCount = productsSnap.count ?? 0;
          _totalRevenue = revenue;
          _isLoadingStats = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingStats = false);
    }
  }

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
            const Text('Welcome, Admin 👋',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Here\'s your store overview',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            _isLoadingStats
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary))
                : _buildStatsGrid(context),
            const SizedBox(height: 28),

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
          icon:
              const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AdminProfileScreen()),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              UIHelper.showSnackBar(
                  context, 'Logged out successfully');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
              );
            } catch (e) {
              if (!context.mounted) return;
              UIHelper.showSnackBar(context, 'Logout failed: $e',
                  isError: true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    String formatRevenue(double revenue) {
      if (revenue >= 100000) {
        return '₹${(revenue / 100000).toStringAsFixed(1)}L';
      }
      if (revenue >= 1000) {
        return '₹${(revenue / 1000).toStringAsFixed(1)}K';
      }
      return '₹${revenue.toStringAsFixed(0)}';
    }

    final stats = [
      {
        'title': 'Total Users',
        'value': '$_userCount',
        'icon': Icons.people_alt_rounded,
        'color': const Color(0xFF3498DB),
      },
      {
        'title': 'Total Orders',
        'value': '$_orderCount',
        'icon': Icons.shopping_bag_rounded,
        'color': const Color(0xFF8E44AD),
      },
      {
        'title': 'Total Products',
        'value': '$_productCount',
        'icon': Icons.inventory_2_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Total Revenue',
        'value': formatRevenue(_totalRevenue),
        'icon': Icons.currency_rupee_rounded,
        'color': const Color(0xFFF39C12),
      },
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard(stats[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(stats[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard(stats[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(stats[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(Map<String, dynamic> data) {
    return Card(
      elevation: 3,
      shadowColor:
          (data['color'] as Color).withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (data['color'] as Color)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data['icon'] as IconData,
                  color: data['color'] as Color, size: 24),
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(data['value'] as String,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 4),
            Text(data['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Manage Categories',
        'subtitle': 'Add, edit or delete project categories',
        'icon': Icons.category_rounded,
        'screen': const ManageCategoriesScreen()
      },
      {
        'title': 'Manage Products',
        'subtitle': 'Control inventory and updating pricing',
        'icon': Icons.inventory_2_rounded,
        'screen': const ManageProductsScreen()
      },
      {
        'title': 'Manage Orders',
        'subtitle': 'View and process new customer orders',
        'icon': Icons.receipt_long_rounded,
        'screen': const ManageOrdersScreen()
      },
      {
        'title': 'Delivery Personnel',
        'subtitle': 'Assign and track your delivery agents',
        'icon': Icons.delivery_dining_rounded,
        'screen': const ManageDeliveryPersonsScreen()
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        final a = actions[i];
        return Card(
          elevation: 2,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(a['icon'] as IconData,
                  color: AppColors.primary, size: 28),
            ),
            title: Text(a['title'] as String,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(a['subtitle'] as String,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary)),
            ),
            trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => a['screen'] as Widget),
            ),
          ),
        );
      },
    );
  }
}
