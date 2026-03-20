import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../auth/login_screen.dart';
import 'manage_categories_screen.dart';
import 'manage_products_screen.dart';
import 'manage_delivery_persons_screen.dart';
import 'manage_orders_screen.dart';

/// Admin Profile Screen — responsive design, no settings section.
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final horizontalPad = isWide ? screenWidth * 0.1 : 20.0;
    final avatarRadius = isWide ? 56.0 : 48.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient Header with Avatar ──────────────────
            _buildProfileHeader(context, avatarRadius),
            // Spacing for the floating avatar + name
            SizedBox(height: avatarRadius + 64),

            // ── Admin Info Section ───────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(Icons.person_outline, 'Full Name', 'Admin User'),
                    _divider(),
                    _infoRow(Icons.email_outlined, 'Email',
                        'admin@quickbasket.com'),
                    _divider(),
                    _infoRow(
                        Icons.phone_outlined, 'Phone', '+91 98765 43210'),
                    _divider(),
                    _infoRow(Icons.calendar_today_outlined, 'Joined',
                        'Jan 2025'),
                  ]),

                  const SizedBox(height: 24),

                  // ── Admin Quick Actions ──────────────────────
                  _sectionTitle('Management'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _menuTile(Icons.category_outlined, 'Manage Categories',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ManageCategoriesScreen()))),
                    _divider(),
                    _menuTile(Icons.inventory_2_outlined, 'Manage Products',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ManageProductsScreen()))),
                    _divider(),
                    _menuTile(Icons.delivery_dining_outlined,
                        'Manage Delivery Persons',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ManageDeliveryPersonsScreen()))),
                    _divider(),
                    _menuTile(Icons.receipt_long_outlined, 'Manage Orders',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ManageOrdersScreen()))),
                  ]),

                  const SizedBox(height: 28),

                  // ── Logout Button ────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: UIHelper.customButton(
                      text: 'Logout',
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        // TODO: Firebase sign out
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Gradient Header ────────────────────────────────────────────────
  Widget _buildProfileHeader(BuildContext context, double avatarRadius) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text('Admin Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -avatarRadius,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.admin_panel_settings,
                    size: avatarRadius, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -(avatarRadius + 58),
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text('Admin User',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Administrator',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.3));
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
        height: 1,
        thickness: 0.8,
        indent: 70,
        color: AppColors.divider.withValues(alpha: 0.6));
  }
}
