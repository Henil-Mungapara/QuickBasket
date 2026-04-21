import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/user_model.dart';

class ManageDeliveryPersonsScreen extends StatefulWidget {
  const ManageDeliveryPersonsScreen({super.key});

  @override
  State<ManageDeliveryPersonsScreen> createState() =>
      _ManageDeliveryPersonsScreenState();
}

class _ManageDeliveryPersonsScreenState
    extends State<ManageDeliveryPersonsScreen> {
  final _firestore = FirebaseFirestore.instance;

  List<UserModel> _deliveryPersons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDeliveryPersons();
  }

  Future<void> _loadDeliveryPersons() async {
    setState(() => _isLoading = true);

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'delivery_person')
          .get();

      _deliveryPersons = snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error loading data: $e', isError: true);
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _showAddEditDialog({UserModel? person}) {
    final nameCtrl = TextEditingController(text: person?.name ?? '');
    final emailCtrl = TextEditingController(text: person?.email ?? '');
    final phoneCtrl = TextEditingController(text: person?.phone ?? '');
    final passwordCtrl = TextEditingController();

    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                person == null ? 'Add Delivery Person' : 'Edit Delivery Person',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    UIHelper.customTextField(
                      controller: nameCtrl,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                    ),

                    const SizedBox(height: 12),

                    UIHelper.customTextField(
                      controller: emailCtrl,
                      hintText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 12),

                    UIHelper.customTextField(
                      controller: phoneCtrl,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 12),

                    if (person == null)
                      UIHelper.customTextField(
                        controller: passwordCtrl,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                      ),

                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
              actions: [
                UIHelper.customTextButton(
                  text: 'Cancel',
                  color: AppColors.textSecondary,
                  onPressed: () => Navigator.pop(ctx),
                ),

                UIHelper.customButton(
                  text: person == null ? 'Add' : 'Update',
                  borderRadius: 10,
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nameCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(
                              context,
                              'Enter name',
                              isError: true,
                            );
                            return;
                          }

                          if (emailCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(
                              context,
                              'Enter email',
                              isError: true,
                            );
                            return;
                          }

                          if (person == null &&
                              passwordCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(
                              context,
                              'Enter password',
                              isError: true,
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          if (person == null) {
                            await _addDeliveryPerson(
                              name: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              password: passwordCtrl.text.trim(),
                            );
                          } else {
                            await _updateDeliveryPerson(
                              id: person.id,
                              name: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                            );
                          }

                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addDeliveryPerson({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'tempAuth',
        options: Firebase.app().options,
      );

      try {
        UserCredential cred =
            await FirebaseAuth.instanceFor(app: tempApp)
                .createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );

        String uid = cred.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'role': 'delivery_person',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _loadDeliveryPersons();

        if (mounted) {
          UIHelper.showSnackBar(context, 'Delivery person added!');
        }
      } finally {
        await tempApp.delete();
      }
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error: $e', isError: true);
      }
    }
  }

  Future<void> _updateDeliveryPerson({
    required String id,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'name': name,
        'email': email,
        'phone': phone,
      });

      await _loadDeliveryPersons();

      if (mounted) {
        UIHelper.showSnackBar(context, 'Updated successfully!');
      }
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error updating: $e', isError: true);
      }
    }
  }

  void _deletePerson(int index) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete',
      content: 'Remove "${_deliveryPersons[index].name}"?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      try {
        String docId = _deliveryPersons[index].id;

        await _firestore.collection('users').doc(docId).delete();

        await _loadDeliveryPersons();

        if (mounted) {
          UIHelper.showSnackBar(context, 'Deleted successfully!');
        }
      } catch (e) {
        if (mounted) {
          UIHelper.showSnackBar(context, 'Error deleting: $e', isError: true);
        }
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
        title: const Text(
          'Delivery Persons',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Person',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deliveryPersons.isEmpty
          ? const Center(
              child: Text(
                'No delivery persons yet',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
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

                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.delivery_dining,
                        color: AppColors.primary,
                      ),
                    ),

                    title: Text(
                      p.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    subtitle: Text(
                      '${p.email}\n${p.phone}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    isThreeLine: true,

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit_outlined,
                            color: AppColors.secondary,
                          ),
                          onPressed: () => _showAddEditDialog(person: p),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
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
