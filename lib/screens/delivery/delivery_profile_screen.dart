import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreService.userProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primary));
          }

          final userData =
              snapshot.data?.data() as Map<String, dynamic>?;
          final name = userData?['name'] ?? 'Delivery Partner';
          final email = userData?['email'] ??
              FirebaseAuth.instance.currentUser?.email ??
              '';
          final phone = userData?['phone'] ?? 'Update your phone number';
          final vehicle = userData?['vehicle'] ?? 'Update your vehicle info';

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context, avatarRadius, name),
                SizedBox(height: avatarRadius + 68),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: horizontalPad),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsRow(),
                      const SizedBox(height: 24),

                      _sectionTitle('Personal Information'),
                      const SizedBox(height: 12),
                      _infoCard([
                        _infoRow(
                          Icons.person_outline,
                          'Full Name',
                          name,
                          onEdit: () => _showEditDialog(
                              context, 'Name', name, 'name'),
                        ),
                        _divider(),
                        _infoRow(
                            Icons.email_outlined, 'Email', email),
                        _divider(),
                        _infoRow(
                          Icons.phone_outlined,
                          'Phone',
                          phone,
                          onEdit: () => _showEditDialog(
                              context, 'Phone Number', phone, 'phone'),
                        ),
                        _divider(),
                        _infoRow(
                          Icons.two_wheeler_outlined,
                          'Vehicle',
                          vehicle,
                          onEdit: () => _showEditDialog(
                              context, 'Vehicle', vehicle, 'vehicle'),
                        ),
                      ]),

                      const SizedBox(height: 24),

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
                            Icons.account_balance_wallet_outlined,
                            'Earnings',
                            onTap: () {}),
                      ]),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: UIHelper.customButton(
                          text: 'Logout',
                          backgroundColor: AppColors.primary,
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              if (!context.mounted) return;
                              UIHelper.showSnackBar(
                                  context, 'Logged out successfully');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreen()));
                            } catch (e) {
                              if (!context.mounted) return;
                              UIHelper.showSnackBar(
                                  context, 'Logout failed: $e',
                                  isError: true);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, double avatarRadius, String name) {
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
              Text(name,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Delivery Partner',
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

  Future<void> _showEditDialog(BuildContext context, String title,
      String currentValue, String fieldKey) async {
    final ctrl = TextEditingController(text: currentValue);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit $title',
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18)),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Enter new $title',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                try {
                  await FirestoreService.updateUserProfile(
                      {fieldKey: ctrl.text.trim()});
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  UIHelper.showSnackBar(
                      context, '$title updated successfully');
                } catch (e) {
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                  UIHelper.showSnackBar(
                      context, 'Failed to update $title',
                      isError: true);
                }
              } else {
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
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

  Widget _infoRow(IconData icon, String label, String value,
      {VoidCallback? onEdit}) {
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
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined,
                  size: 20, color: AppColors.primary),
              onPressed: onEdit,
              splashRadius: 20,
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
