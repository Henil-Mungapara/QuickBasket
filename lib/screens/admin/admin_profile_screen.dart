import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';

/// Admin Profile Screen — premium design with gradient header & menu sections.
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch admin data from Firebase Firestore
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient Header with Avatar ──────────────────
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // ── Admin Info Section ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    _infoRow(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
                    _divider(),
                    _infoRow(Icons.calendar_today_outlined, 'Joined', 'Jan 2025'),
                  ]),

                  const SizedBox(height: 24),

                  // ── Admin Quick Actions ──────────────────────
                  _sectionTitle('Management'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _menuTile(Icons.category_outlined, 'Manage Categories',
                        onTap: () => Navigator.pushNamed(context, '/admin-categories')),
                    _divider(),
                    _menuTile(Icons.inventory_2_outlined, 'Manage Products',
                        onTap: () => Navigator.pushNamed(context, '/admin-products')),
                    _divider(),
                    _menuTile(Icons.delivery_dining_outlined,
                        'Manage Delivery Persons',
                        onTap: () => Navigator.pushNamed(
                            context, '/admin-delivery-persons')),
                    _divider(),
                    _menuTile(Icons.receipt_long_outlined, 'Manage Orders',
                        onTap: () => Navigator.pushNamed(context, '/admin-orders')),
                  ]),

                  const SizedBox(height: 24),

                  // ── Settings Section ─────────────────────────
                  _sectionTitle('Settings'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _menuTile(Icons.notifications_outlined, 'Notifications',
                        onTap: () {}),
                    _divider(),
                    _menuTile(Icons.lock_outline, 'Change Password',
                        onTap: () {}),
                    _divider(),
                    _menuTile(Icons.analytics_outlined, 'App Analytics',
                        onTap: () {}),
                    _divider(),
                    _menuTile(Icons.info_outline, 'About',
                        onTap: () {}),
                  ]),

                  const SizedBox(height: 28),

                  // ── Logout Button ────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: UIHelper.customButton(
                      text: 'Logout',
                      backgroundColor: AppColors.error,
                      onPressed: () {
                        // TODO: Firebase sign out
                        Navigator.pushReplacementNamed(context, '/login');
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
  Widget _buildProfileHeader(BuildContext context) {
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
                  IconButton(
                    icon: const Icon(Icons.settings_outlined,
                        color: Colors.white, size: 22),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
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
              child: const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.admin_panel_settings,
                    size: 48, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -105,
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
        const SizedBox(height: 120),
      ],
    );
  }

  // ── Reusable Helpers ───────────────────────────────────────────────

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
