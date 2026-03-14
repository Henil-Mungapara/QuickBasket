import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../widgets/app_network_image.dart';

/// Manage Products Screen — list, add, edit, delete products.
class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  final List<ProductModel> _products = List.from(ProductModel.dummyProducts);
  final _categories = CategoryModel.dummyCategories;

  String _getCategoryName(String catId) {
    final cat = _categories.firstWhere((c) => c.id == catId,
        orElse: () => CategoryModel(id: '', name: 'Unknown'));
    return cat.name;
  }

  void _showProductForm({ProductModel? product, int? index}) {
    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final priceCtrl =
        TextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl =
        TextEditingController(text: product?.stock.toString() ?? '');
    final descCtrl =
        TextEditingController(text: product?.description ?? '');
    String selectedCatId = product?.categoryId ?? _categories.first.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(product == null ? 'Add Product' : 'Edit Product',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 20),

              // ── Image Placeholder ─────────────────────
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          color: AppColors.primary, size: 36),
                      SizedBox(height: 4),
                      Text('Add Image',
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              UIHelper.customTextField(
                  controller: nameCtrl,
                  hintText: 'Product Name',
                  prefixIcon: Icons.shopping_bag_outlined),
              const SizedBox(height: 14),

              // ── Category Dropdown ─────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: StatefulBuilder(
                  builder: (context, setModalState) =>
                      DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCatId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (v) =>
                          setModalState(() => selectedCatId = v!),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: UIHelper.customTextField(
                        controller: priceCtrl,
                        hintText: 'Price (₹)',
                        prefixIcon: Icons.currency_rupee,
                        keyboardType: TextInputType.number),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: UIHelper.customTextField(
                        controller: stockCtrl,
                        hintText: 'Stock',
                        prefixIcon: Icons.inventory,
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              UIHelper.customTextField(
                  controller: descCtrl,
                  hintText: 'Description',
                  prefixIcon: Icons.description_outlined),
              const SizedBox(height: 24),

              UIHelper.customButton(
                text: product == null ? 'Add Product' : 'Update Product',
                width: AppSize.screenWidth(context),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    final p = ProductModel(
                      id: product?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      categoryId: selectedCatId,
                      price:
                          double.tryParse(priceCtrl.text) ?? 0,
                      stock: int.tryParse(stockCtrl.text) ?? 0,
                      description: descCtrl.text.trim(),
                    );
                    if (product == null) {
                      // TODO: Save to Firestore
                      _products.add(p);
                    } else {
                      // TODO: Update in Firestore
                      _products[index!] = p;
                    }
                  });
                  Navigator.pop(ctx);
                  UIHelper.showSnackBar(context,
                      product == null ? 'Product added' : 'Product updated');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProduct(int index) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete Product',
      content: 'Delete "${_products[index].name}"?',
      confirmText: 'Delete',
    );
    if (confirmed == true) {
      setState(() {
        // TODO: Delete from Firestore
        _products.removeAt(index);
      });
      if (!mounted) return;
      UIHelper.showSnackBar(context, 'Product deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Manage Products',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text('No products yet',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _products.length,
              itemBuilder: (ctx, i) {
                final p = _products[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: AppNetworkImage(
                      imageUrl: p.imageUrl,
                      width: 56,
                      height: 56,
                      borderRadius: 12,
                    ),
                    title: Text(p.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                          '${_getCategoryName(p.categoryId)} • ₹${p.price.toStringAsFixed(0)} • Stock: ${p.stock}',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.secondary, size: 22),
                          onPressed: () =>
                              _showProductForm(product: p, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 22),
                          onPressed: () => _deleteProduct(i),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
