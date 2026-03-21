import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../widgets/app_network_image.dart';

/// Manage Products Screen — list, add, edit, delete products (Firestore + base64 images).
class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  List<CategoryModel> _categories = [];
  bool _isLoadingCats = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final snap =
          await FirebaseFirestore.instance.collection('categories').get();
      if (mounted) {
        setState(() {
          _categories = snap.docs
              .map((doc) => CategoryModel.fromJson(doc.id, doc.data()))
              .toList();
          _isLoadingCats = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCats = false);
    }
  }

  String _getCategoryName(String catId) {
    if (_categories.isEmpty) return 'Loading...';
    final cat = _categories.firstWhere((c) => c.id == catId,
        orElse: () => CategoryModel(id: '', name: 'Unknown'));
    return cat.name;
  }

  void _showProductForm({ProductModel? product}) {
    if (_categories.isEmpty) {
      UIHelper.showSnackBar(
          context, 'No categories found. Please add a category first.');
      return;
    }

    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final priceCtrl =
        TextEditingController(text: product?.price.toString() ?? '');
    final stockCtrl =
        TextEditingController(text: product?.stock.toString() ?? '');
    final descCtrl = TextEditingController(text: product?.description ?? '');

    // Ensure selectedCatId is valid
    String selectedCatId = product?.categoryId ?? '';
    if (selectedCatId.isEmpty ||
        !_categories.any((c) => c.id == selectedCatId)) {
      selectedCatId = _categories.first.id;
    }

    String selectedImageBase64 = product?.imageUrl ?? '';
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product == null ? 'Add Product' : 'Edit Product',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    if (!isSaving)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Image Placeholder ─────────────────────
                Center(
                  child: GestureDetector(
                    onTap: isSaving
                        ? null
                        : () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 40);
                            if (image != null) {
                              final bytes = await image.readAsBytes();
                              setModalState(() {
                                selectedImageBase64 =
                                    'data:image/jpeg;base64,${base64Encode(bytes)}';
                              });
                            }
                          },
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
                      child: selectedImageBase64.isNotEmpty
                          ? AppNetworkImage(
                              imageUrl: selectedImageBase64,
                              width: 120,
                              height: 120,
                              borderRadius: 16)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    color: AppColors.primary, size: 36),
                                SizedBox(height: 4),
                                Text('Add Image',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCatId,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary),
                      items: _categories
                          .map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: isSaving
                          ? null
                          : (v) =>
                              setModalState(() => selectedCatId = v!),
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

                if (isSaving)
                  const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary))
                else
                  UIHelper.customButton(
                    text: product == null ? 'Add Product' : 'Update Product',
                    width: AppSize.screenWidth(context),
                    onPressed: () async {
                      if (nameCtrl.text.trim().isEmpty) {
                        UIHelper.showSnackBar(
                            context, 'Please enter product name');
                        return;
                      }
                      if (selectedImageBase64.isEmpty) {
                        UIHelper.showSnackBar(
                            context, 'Please select an image');
                        return;
                      }

                      setModalState(() => isSaving = true);

                      try {
                        // Store base64 image string directly in Firestore
                        final col = FirebaseFirestore.instance
                            .collection('products');
                        if (product == null) {
                          final doc = col.doc();
                          await doc.set(ProductModel(
                            id: doc.id,
                            name: nameCtrl.text.trim(),
                            categoryId: selectedCatId,
                            price:
                                double.tryParse(priceCtrl.text) ?? 0,
                            stock:
                                int.tryParse(stockCtrl.text) ?? 0,
                            description: descCtrl.text.trim(),
                            imageUrl: selectedImageBase64,
                            createdAt: DateTime.now(),
                          ).toJson());
                        } else {
                          await col.doc(product.id).update({
                            'name': nameCtrl.text.trim(),
                            'categoryId': selectedCatId,
                            'price':
                                double.tryParse(priceCtrl.text) ?? 0,
                            'stock':
                                int.tryParse(stockCtrl.text) ?? 0,
                            'description': descCtrl.text.trim(),
                            'imageUrl': selectedImageBase64,
                          });
                        }

                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                          UIHelper.showSnackBar(
                              ctx,
                              product == null
                                  ? 'Product added'
                                  : 'Product updated');
                        }
                      } catch (e) {
                        setModalState(() => isSaving = false);
                        if (ctx.mounted) {
                          UIHelper.showSnackBar(ctx, 'Error: $e');
                        }
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteProduct(String id, String name) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete Product',
      content: 'Delete "$name"?',
      confirmText: 'Delete',
    );
    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(id)
            .delete();
        if (mounted) UIHelper.showSnackBar(context, 'Product deleted');
      } catch (e) {
        if (mounted) UIHelper.showSnackBar(context, 'Error: $e');
      }
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
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
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
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _isLoadingCats
          ? const Center(
              child:
                  CircularProgressIndicator(color: AppColors.primary))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading products'));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('No products yet',
                          style: TextStyle(
                              color: AppColors.textSecondary)));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 100),
                  itemCount: docs.length,
                  itemBuilder: (ctx, i) {
                    final data =
                        docs[i].data() as Map<String, dynamic>;
                    final p =
                        ProductModel.fromJson(docs[i].id, data);

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
                                  fontSize: 12,
                                  color:
                                      AppColors.textSecondary)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                  Icons.edit_outlined,
                                  color: AppColors.secondary,
                                  size: 22),
                              onPressed: () =>
                                  _showProductForm(product: p),
                            ),
                            IconButton(
                              icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.error,
                                  size: 22),
                              onPressed: () =>
                                  _deleteProduct(p.id, p.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
    );
  }
}
