import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../helpers/app_size.dart';
import '../../models/user_model.dart';

/// Manage Delivery Persons Screen
class ManageDeliveryPersonsScreen extends StatefulWidget {
  const ManageDeliveryPersonsScreen({super.key});

  @override
  State<ManageDeliveryPersonsScreen> createState() =>
      _ManageDeliveryPersonsScreenState();
}

class _ManageDeliveryPersonsScreenState
    extends State<ManageDeliveryPersonsScreen> {
  final List<UserModel> _deliveryPersons = UserModel.dummyUsers
      .where((u) => u.role == 'delivery')
      .toList();

  void _showDeliveryPersonForm({UserModel? person, int? index}) {
    final nameCtrl = TextEditingController(text: person?.name ?? '');
    final emailCtrl = TextEditingController(text: person?.email ?? '');
    final phoneCtrl = TextEditingController(text: person?.phone ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(person == null ? 'Add Delivery Person' : 'Edit Delivery Person',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              UIHelper.customTextField(
                  controller: nameCtrl, hintText: 'Full Name',
                  prefixIcon: Icons.person_outline),
              const SizedBox(height: 14),
              UIHelper.customTextField(
                  controller: emailCtrl, hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 14),
              UIHelper.customTextField(
                  controller: phoneCtrl, hintText: 'Phone Number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 24),
              UIHelper.customButton(
                text: person == null ? 'Add' : 'Update',
                width: AppSize.screenWidth(context),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    final p = UserModel(
                      id: person?.id ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text.trim(),
                      email: emailCtrl.text.trim(),
                      role: 'delivery',
                      phone: phoneCtrl.text.trim(),
                    );
                    if (person == null) {
                      // TODO: Save to Firestore
                      _deliveryPersons.add(p);
                    } else {
                      // TODO: Update in Firestore
                      _deliveryPersons[index!] = p;
                    }
                  });
                  Navigator.pop(ctx);
                  UIHelper.showSnackBar(context,
                      person == null ? 'Delivery person added' : 'Updated');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePerson(int index) async {
    final confirmed = await UIHelper.showAlertDialog(context,
        title: 'Delete', content: 'Remove "${_deliveryPersons[index].name}"?',
        confirmText: 'Delete');
    if (confirmed == true) {
      setState(() {
        // TODO: Delete from Firestore
        _deliveryPersons.removeAt(index);
      });
      if (!mounted) return;
      UIHelper.showSnackBar(context, 'Deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary, elevation: 0,
        title: const Text('Delivery Persons',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDeliveryPersonForm(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Person',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _deliveryPersons.isEmpty
          ? const Center(child: Text('No delivery persons',
              style: TextStyle(color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _deliveryPersons.length,
              itemBuilder: (ctx, i) {
                final p = _deliveryPersons[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.delivery_dining, color: AppColors.primary),
                    ),
                    title: Text(p.name,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    subtitle: Text('${p.email}\n${p.phone}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.secondary, size: 22),
                          onPressed: () => _showDeliveryPersonForm(person: p, index: i),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 22),
                          onPressed: () => _deletePerson(i),
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
