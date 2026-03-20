import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/product_model.dart';
import '../../widgets/app_network_image.dart';
import 'product_details_screen.dart';

/// Wishlist Screen — saved products.
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // TODO: Fetch wishlist from Firestore
  final List<ProductModel> _wishlist =
      List.from(ProductModel.dummyProducts.take(4));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('My Wishlist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _wishlist.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: AppColors.divider),
                  SizedBox(height: 12),
                  Text('Your wishlist is empty',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _wishlist.length,
              itemBuilder: (ctx, i) {
                final p = _wishlist[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: AppNetworkImage(
                      imageUrl: p.imageUrl,
                      width: 60,
                      height: 60,
                      borderRadius: 12,
                    ),
                    title: Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    subtitle: Text('₹${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: AppColors.primary, size: 22),
                          onPressed: () {
                            // TODO: Add to cart
                            UIHelper.showSnackBar(
                                context, '${p.name} added to cart');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 22),
                          onPressed: () {
                            setState(() => _wishlist.removeAt(i));
                            UIHelper.showSnackBar(
                                context, 'Removed from wishlist');
                          },
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailsScreen(product: p))),
                  ),
                );
              },
            ),
    );
  }
}
