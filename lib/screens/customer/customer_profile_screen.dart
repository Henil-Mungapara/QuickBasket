import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';

/// Modern Customer Profile Screen with real-time Firestore data
class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Screen width adjustments
    final width = AppSize.screenWidth(context);
    final isTablet = width > 600;
    final paddingH = isTablet ? width * 0.15 : 20.0;
    final avatarRadius = isTablet ? 60.0 : 50.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirestoreService.userProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final name = userData?['name'] ?? 'Customer';
          final email = userData?['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
          final phone = userData?['phone'] ?? 'Update your phone number';
          final address = userData?['address'] ?? 'Update your address';

          return SingleChildScrollView(
            child: Column(
              children: [
                // ── HEADER SECTION ─────────────────────────────────────
                Stack(
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
                              const SizedBox(width: 48), // Balance spacing
                              const Spacer(),
                              const Text('My Profile',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              const SizedBox(width: 48), // Balance spacing
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Floating avatar
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
                            child: Icon(Icons.person,
                                size: avatarRadius, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    // Name & email below avatar
                    Positioned(
                      bottom: -(avatarRadius + 58),
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
                          Text(email,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary.withValues(alpha: 0.8))),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: avatarRadius + 65), // Spacing for avatar & text

                // ── BODY CONTENT ───────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Personal Info'),
                      const SizedBox(height: 12),
                      _infoCard([
                        _infoRow(Icons.phone_outlined, 'Phone Number', phone),
                        _divider(),
                        _infoRow(Icons.location_on_outlined, 'Delivery Address', address),
                      ]),
                      const SizedBox(height: 24),

                      _sectionTitle('Account'),
                      const SizedBox(height: 12),
                      _infoCard([
                        // Re-using the built-in tabs, so these just trigger UI state
                        // or show coming soon for settings.
                        _menuTile(Icons.shopping_bag_outlined, 'My Orders', onTap: () {}),
                        _divider(),
                        _menuTile(Icons.favorite_border, 'Wishlist', onTap: () {}),
                        _divider(),
                        _menuTile(Icons.settings_outlined, 'Settings', onTap: () {
                          UIHelper.showSnackBar(context, 'Settings coming soon!');
                        }),
                      ]),
                      const SizedBox(height: 32),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: UIHelper.customButton(
                          text: 'Logout',
                          backgroundColor: AppColors.primary,
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              if (!context.mounted) return;
                              UIHelper.showSnackBar(context, 'Logged out successfully');
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
                            } catch (e) {
                              if (!context.mounted) return;
                              UIHelper.showSnackBar(context, 'Logout failed: $e', isError: true);
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textSecondary.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.background.withValues(alpha: 0.5),
      indent: 52,
      endIndent: 16,
    );
  }
}
