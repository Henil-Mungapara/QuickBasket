import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/category_model.dart';
import '../../widgets/app_network_image.dart';

/// Manage Categories Screen — Add / Edit / Delete categories (Firestore + base64 images).
class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  void _showCategoryDialog({CategoryModel? category}) {
    final controller = TextEditingController(text: category?.name ?? '');
    String selectedImageBase64 = category?.imageUrl ?? '';
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(category == null ? 'Add Category' : 'Edit Category',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isLoading
                    ? null
                    : () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 40);
                        if (image != null) {
                          final bytes = await image.readAsBytes();
                          setDialogState(() {
                            selectedImageBase64 =
                                'data:image/jpeg;base64,${base64Encode(bytes)}';
                          });
                        }
                      },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: selectedImageBase64.isNotEmpty
                      ? AppNetworkImage(
                          imageUrl: selectedImageBase64,
                          width: 100,
                          height: 100,
                          borderRadius: 12)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                color: AppColors.primary, size: 30),
                            SizedBox(height: 4),
                            Text('Add Image',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.primary)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              UIHelper.customTextField(
                controller: controller,
                hintText: 'Category Name',
                prefixIcon: Icons.category,
              ),
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
            ],
          ),
          actions: [
            if (!isLoading)
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.textSecondary))),
            if (!isLoading)
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isEmpty) {
                    UIHelper.showSnackBar(context, 'Please enter a name');
                    return;
                  }
                  if (selectedImageBase64.isEmpty) {
                    UIHelper.showSnackBar(context, 'Please select an image');
                    return;
                  }

                  setDialogState(() => isLoading = true);

                  try {
                    final col =
                        FirebaseFirestore.instance.collection('categories');
                    if (category == null) {
                      // Add new category — store base64 image directly
                      final doc = col.doc();
                      await doc.set(CategoryModel(
                        id: doc.id,
                        name: controller.text.trim(),
                        imageUrl: selectedImageBase64,
                        createdAt: DateTime.now(),
                      ).toJson());
                    } else {
                      // Update existing category
                      await col.doc(category.id).update({
                        'name': controller.text.trim(),
                        'imageUrl': selectedImageBase64,
                      });
                    }
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                      UIHelper.showSnackBar(
                          ctx,
                          category == null
                              ? 'Category added'
                              : 'Category updated');
                    }
                  } catch (e) {
                    setDialogState(() => isLoading = false);
                    if (ctx.mounted) UIHelper.showSnackBar(ctx, 'Error: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(category == null ? 'Add' : 'Update',
                    style: const TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(String id, String name) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete Category',
      content: 'Are you sure you want to delete "$name"?',
      confirmText: 'Delete',
    );
    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(id)
            .delete();
        if (mounted) UIHelper.showSnackBar(context, 'Category deleted');
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
        title: const Text('Manage Categories',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Category',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categories')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primary));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading categories'));
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(
                  child: Text('No categories yet',
                      style: TextStyle(color: AppColors.textSecondary)));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 100),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                final cat = CategoryModel.fromJson(docs[i].id, data);
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
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    leading: AppNetworkImage(
                      imageUrl: cat.imageUrl,
                      width: 46,
                      height: 46,
                      borderRadius: 12,
                      errorIcon: Icons.category,
                    ),
                    title: Text(cat.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.secondary, size: 22),
                          onPressed: () =>
                              _showCategoryDialog(category: cat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 22),
                          onPressed: () =>
                              _deleteCategory(cat.id, cat.name),
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
