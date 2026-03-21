import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';

/// Delivery Profile Screen — responsive design, no settings section.
class DeliveryProfileScreen extends StatelessWidget {
  const DeliveryProfileScreen({super.key});

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
            // Spacing for the floating avatar + name + rating
            SizedBox(height: avatarRadius + 68),

            // ── Stats Row ────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(),
                  const SizedBox(height: 24),

                  // ── Personal Info Section ────────────────────
                  _sectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _infoRow(
                        Icons.person_outline, 'Full Name', 'Radhu'),
                    _divider(),
                    _infoRow(
                        Icons.email_outlined, 'Email', 'radhu@email.com'),
                    _divider(),
                    _infoRow(
                        Icons.phone_outlined, 'Phone', '+91 98765 43212'),
                    _divider(),
                    _infoRow(Icons.two_wheeler_outlined, 'Vehicle',
                        'Bike — MH 01 AB 1234'),
                  ]),

                  const SizedBox(height: 24),

                  // ── Quick Actions ────────────────────────────
                  _sectionTitle('Quick Actions'),
                  const SizedBox(height: 12),
                  _infoCard([
                    _menuTile(
                        Icons.assignment_outlined, 'Assigned Orders',
                        onTap: () => Navigator.pushNamed(
                            context, '/delivery-assigned-orders')),
                    _divider(),
                    _menuTile(Icons.history, 'Delivery History',
                        onTap: () {}),
                    _divider(),
                    _menuTile(
                        Icons.account_balance_wallet_outlined, 'Earnings',
                        onTap: () {}),
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
                  const Text('My Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance the back button
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
                child: Icon(Icons.delivery_dining,
                    size: avatarRadius, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -(avatarRadius + 62),
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text('Radhu',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded,
                      color: AppColors.accent, size: 18),
                  const SizedBox(width: 4),
                  const Text('4.5',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(width: 6),
                  Text('(128 deliveries)',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary
                              .withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    return Row(
      children: [
        _statCard('128', 'Delivered', Icons.check_circle_outline,
            AppColors.success),
        const SizedBox(width: 12),
        _statCard(
            '3', 'Active', Icons.pending_outlined, AppColors.warning),
        const SizedBox(width: 12),
        _statCard('4.5', 'Rating', Icons.star_outline, AppColors.accent),
      ],
    );
  }

  Widget _statCard(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
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
