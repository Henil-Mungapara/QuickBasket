import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/category_model.dart';
import '../../widgets/app_network_image.dart';

/// Manage Categories Screen — Add / Edit / Delete categories.
class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  final List<CategoryModel> _categories =
      List.from(CategoryModel.dummyCategories);



  void _showCategoryDialog({CategoryModel? category, int? index}) {
    final controller =
        TextEditingController(text: category?.name ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(category == null ? 'Add Category' : 'Edit Category',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        content: UIHelper.customTextField(
          controller: controller,
          hintText: 'Category Name',
          prefixIcon: Icons.category,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isEmpty) return;
              setState(() {
                if (category == null) {
                  // TODO: Save to Firestore
                  _categories.add(CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text.trim(),
                  ));
                } else {
                  // TODO: Update in Firestore
                  _categories[index!] = CategoryModel(
                    id: category.id,
                    name: controller.text.trim(),
                    icon: category.icon,
                  );
                }
              });
              Navigator.pop(ctx);
              UIHelper.showSnackBar(context,
                  category == null ? 'Category added' : 'Category updated');
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
    );
  }

  void _deleteCategory(int index) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete Category',
      content:
          'Are you sure you want to delete "${_categories[index].name}"?',
      confirmText: 'Delete',
    );
    if (confirmed == true) {
      setState(() {
        // TODO: Delete from Firestore
        _categories.removeAt(index);
      });
      if (!mounted) return;
      UIHelper.showSnackBar(context, 'Category deleted');
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
      body: _categories.isEmpty
          ? const Center(
              child: Text('No categories yet',
                  style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
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
                              _showCategoryDialog(category: cat, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 22),
                          onPressed: () => _deleteCategory(i),
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
