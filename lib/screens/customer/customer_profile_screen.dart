import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';

/// Customer Profile Screen — premium design with gradient header & menu sections.
class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch customer data from Firebase Firestore
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient Header with Avatar ──────────────────
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // ── Personal Info Section ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(Icons.person_outline, 'Full Name', 'John Doe'),
                    _divider(),
                    _infoRow(Icons.email_outlined, 'Email', 'john@email.com'),
                    _divider(),
                    _infoRow(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
                    _divider(),
                    _infoRow(Icons.location_on_outlined, 'Address',
                        '123 Main St, City, State'),
                  ]),

                  const SizedBox(height: 24),

                  // ── Account Menu Section ─────────────────────
                  _sectionTitle('Account'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _menuTile(Icons.shopping_bag_outlined, 'My Orders',
                        onTap: () => Navigator.pushNamed(context, '/customer-orders')),
                    _divider(),
                    _menuTile(Icons.favorite_border, 'Wishlist',
                        onTap: () => Navigator.pushNamed(context, '/customer-wishlist')),
                    _divider(),
                    _menuTile(Icons.location_on_outlined, 'Saved Addresses',
                        onTap: () {}),
                    _divider(),
                    _menuTile(Icons.payment_outlined, 'Payment Methods',
                        onTap: () {}),
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
                    _menuTile(Icons.help_outline, 'Help & Support',
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
        // Gradient background
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
                  const Text('My Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 22),
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // Floating avatar card
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
                child: Icon(Icons.person, size: 48, color: Colors.white),
              ),
            ),
          ),
        ),
        // Name & email below avatar
        Positioned(
          bottom: -105,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text('John Doe',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('john@email.com',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary.withValues(alpha: 0.8))),
            ],
          ),
        ),
        // Spacer for the overlapping content
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

  Widget _menuTile(IconData icon, String title, {required VoidCallback onTap}) {
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
