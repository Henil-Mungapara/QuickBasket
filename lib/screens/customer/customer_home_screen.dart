import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../widgets/app_network_image.dart';
import 'cart_screen.dart';
import 'category_products_screen.dart';
import 'customer_orders_screen.dart';
import 'customer_profile_screen.dart';
import 'product_details_screen.dart';
import 'wishlist_screen.dart';

/// Customer Home Screen — search, categories, featured products.
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _searchController = TextEditingController();
  final _categories = CategoryModel.dummyCategories;
  final _products = ProductModel.dummyProducts;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 16),

              // ── Search Bar ────────────────────────────────
              _buildSearchBar(),
              const SizedBox(height: 24),

              // ── Categories ────────────────────────────────
              _sectionTitle('Shop by Category'),
              const SizedBox(height: 12),
              _buildCategoryList(),
              const SizedBox(height: 24),

              // ── Featured ──────────────────────────────────
              _sectionTitle('Featured Products'),
              const SizedBox(height: 12),
              _buildFeaturedProducts(),
              const SizedBox(height: 24),

              // ── All Products Grid ─────────────────────────
              _sectionTitle('All Products'),
              const SizedBox(height: 12),
              _buildProductGrid(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('QuickBasket 🛒',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text('Delivering to Home',
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border,
                    color: AppColors.textPrimary),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistScreen())),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen())),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                          color: AppColors.error, shape: BoxShape.circle),
                      child: const Center(
                        child: Text('3',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for groceries...',
            hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6), fontSize: 14),
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary)),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (ctx, i) {
          final cat = _categories[i];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        CategoryProductsScreen(category: cat))),
            child: Container(
              width: 78,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  AppNetworkImage(
                    imageUrl: cat.imageUrl,
                    width: 60,
                    height: 60,
                    borderRadius: 16,
                    errorIcon: Icons.category,
                  ),
                  const SizedBox(height: 8),
                  Text(cat.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    final featured = _products.take(4).toList();
    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: featured.length,
        itemBuilder: (ctx, i) {
          final p = featured[i];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsScreen(product: p))),
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16)),
                    child: AppNetworkImage(
                      imageUrl: p.imageUrl,
                      width: double.infinity,
                      height: 110,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${p.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.primary)),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: _products.length,
        itemBuilder: (ctx, i) {
          final p = _products[i];
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsScreen(product: p))),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: AppNetworkImage(
                        imageUrl: p.imageUrl,
                        width: double.infinity,
                        borderRadius: 0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textPrimary)),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${p.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppColors.primary)),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (i) {
          switch (i) {
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerOrdersScreen()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerProfileScreen()));
              break;
          }
        },
      ),
    );
  }
}
