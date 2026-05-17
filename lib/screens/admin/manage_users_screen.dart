import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/user_model.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);

    try {
      // Fetch all users except admin, or all users.
      // Assuming 'admin' role is separated, we fetch where role != 'admin' if possible,
      // but Firestore doesn't support != easily without index. We'll fetch all and filter locally.
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      final users = snapshot.docs.map((doc) {
        return UserModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).where((u) => u.role != 'admin').toList();

      if (mounted) {
        setState(() {
          _allUsers = users;
          _filteredUsers = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error loading data: $e', isError: true);
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() => _filteredUsers = _allUsers);
      return;
    }

    setState(() {
      _filteredUsers = _allUsers.where((u) {
        return u.name.toLowerCase().contains(query) ||
            u.email.toLowerCase().contains(query) ||
            u.phone.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showAddEditDialog({UserModel? user}) {
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final addressCtrl = TextEditingController(text: user?.address ?? '');
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
                user == null ? 'Add User' : 'Edit User',
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
                    UIHelper.customTextField(
                      controller: addressCtrl,
                      hintText: 'Address',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 12),
                    if (user == null)
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
                  text: user == null ? 'Add' : 'Update',
                  borderRadius: 10,
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (nameCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(context, 'Enter name', isError: true);
                            return;
                          }
                          if (emailCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(context, 'Enter email', isError: true);
                            return;
                          }
                          if (user == null && passwordCtrl.text.trim().isEmpty) {
                            UIHelper.showSnackBar(context, 'Enter password', isError: true);
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          if (user == null) {
                            await _addUser(
                              name: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
                              password: passwordCtrl.text.trim(),
                            );
                          } else {
                            await _updateUser(
                              id: user.id,
                              name: nameCtrl.text.trim(),
                              email: emailCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
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

  Future<void> _addUser({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'tempAuth',
        options: Firebase.app().options,
      );

      try {
        UserCredential cred = await FirebaseAuth.instanceFor(app: tempApp)
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String uid = cred.user!.uid;

        await _firestore.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'address': address,
          'role': 'customer',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await _loadUsers();

        if (mounted) {
          UIHelper.showSnackBar(context, 'User added successfully!');
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

  Future<void> _updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    try {
      await _firestore.collection('users').doc(id).update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      });

      await _loadUsers();

      if (mounted) {
        UIHelper.showSnackBar(context, 'Updated successfully!');
      }
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error updating: $e', isError: true);
      }
    }
  }

  void _deleteUser(int index) async {
    final confirmed = await UIHelper.showAlertDialog(
      context,
      title: 'Delete User',
      content: 'Remove "${_filteredUsers[index].name}" permanently?',
      confirmText: 'Delete',
    );

    if (confirmed == true) {
      try {
        String docId = _filteredUsers[index].id;

        await _firestore.collection('users').doc(docId).delete();
        
        await _loadUsers();

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
          'Manage Users',
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
          'Add User',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primary,
            child: UIHelper.customTextField(
              controller: _searchController,
              hintText: 'Search by name, email or phone...',
              prefixIcon: Icons.search,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredUsers.length,
                        itemBuilder: (ctx, i) {
                          final user = _filteredUsers[i];

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
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                '${user.email}\n${user.phone.isNotEmpty ? user.phone : 'No Phone'} • Role: ${user.role.toUpperCase()}',
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
                                    onPressed: () => _showAddEditDialog(user: user),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: AppColors.error,
                                    ),
                                    onPressed: () => _deleteUser(i),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
