import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/product_model.dart';

/// Product Details Screen
class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Image Header ───────────────────────────────────
          SliverAppBar(
            expandedHeight: AppSize.heightFraction(context, 0.38),
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 18,
                child: Icon(Icons.arrow_back_ios_new,
                    color: AppColors.textPrimary, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(Icons.favorite_border,
                      color: AppColors.error, size: 20),
                ),
                onPressed: () {
                  // TODO: Add to wishlist in Firestore
                  UIHelper.showSnackBar(context, 'Added to Wishlist ❤️');
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: const Center(
                    child: Icon(Icons.image_outlined,
                        size: 80, color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),

          // ── Details ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              transform: Matrix4.translationValues(0, -24, 0),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name & Price ─────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(product.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ── Stock Status ─────────────────────
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: product.stock > 0
                              ? AppColors.success
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                          product.stock > 0
                              ? 'In Stock (${product.stock} available)'
                              : 'Out of Stock',
                          style: TextStyle(
                              fontSize: 13,
                              color: product.stock > 0
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Description ──────────────────────
                  const Text('Description',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                      product.description.isNotEmpty
                          ? product.description
                          : 'No description available.',
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5)),
                  const SizedBox(height: 28),

                  // ── Info chips ───────────────────────
                  Row(
                    children: [
                      _infoChip(Icons.local_shipping_outlined, 'Free Delivery'),
                      const SizedBox(width: 10),
                      _infoChip(Icons.verified_outlined, '100% Fresh'),
                      const SizedBox(width: 10),
                      _infoChip(Icons.access_time, '30 min'),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Bar ─────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: UIHelper.customButton(
                text: 'Add to Cart 🛒',
                onPressed: () {
                  // TODO: Add to cart in state / Firestore
                  UIHelper.showSnackBar(context, '${product.name} added to cart');
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: AppColors.accent, size: 26),
                onPressed: () {
                  // TODO: Add to wishlist in Firestore
                  UIHelper.showSnackBar(context, 'Added to Wishlist');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 4),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
