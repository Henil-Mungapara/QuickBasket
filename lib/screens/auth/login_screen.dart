import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/app_colors.dart';
import '../../helpers/app_size.dart';
import '../../helpers/ui_helper.dart';
import '../admin/admin_dashboard.dart';
import '../customer/customer_home_screen.dart';
import '../delivery/delivery_dashboard.dart';
import 'registration_screen.dart';

/// Login Screen — authentication UI.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Authenticate with Firebase Auth
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Fetch User Data from Firestore to check Role
      String uid = userCred.user!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        if (mounted) {
          UIHelper.showSnackBar(context, 'User data not found.', isError: true);
        }
        await FirebaseAuth.instance.signOut();
        setState(() => _isLoading = false);
        return;
      }

      // 3. Determine Role and Navigate
      String role = userDoc.get('role') ?? 'customer';

      if (mounted) {
        if (role == 'admin') {
          UIHelper.showSnackBar(context, 'Welcome Admin!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else if (role == 'delivery_person') {
          UIHelper.showSnackBar(context, 'Welcome Delivery Partner!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DeliveryDashboard()),
          );
        } else {
          UIHelper.showSnackBar(context, 'Login Successful!');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Authentication failed.';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        } else if (e.code == 'invalid-credential') {
          message = 'Invalid email or password.';
        }
        UIHelper.showSnackBar(context, message, isError: true);
      }
    } catch (e) {
      if (mounted) {
        UIHelper.showSnackBar(context, 'Error: $e', isError: true);
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _handleGoogleSignIn() {
    // TODO: Implement Google Sign-In with firebase_auth & google_sign_in
    UIHelper.showSnackBar(context, 'Google Sign-In coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Logo / Brand ───────────────────────────
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.shopping_basket_rounded,
                          size: 44, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    const Text('QuickBasket',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    const Text('Fresh groceries at your doorstep',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 40),

                    // ── Email ──────────────────────────────────
                    UIHelper.customTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ── Password ───────────────────────────────
                    UIHelper.customTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                          size: 22,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Minimum 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),

                    // ── Login Button ──────────────────────────
                    UIHelper.customButton(
                      text: _isLoading ? 'Logging in...' : 'Login',
                      onPressed: _isLoading ? null : _handleLogin,
                      width: AppSize.screenWidth(context),
                    ),
                    const SizedBox(height: 16),

                    // ── OR Divider ────────────────────────────
                    Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('OR', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                        Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Sign in with Google ───────────────────
                    SizedBox(
                      width: AppSize.screenWidth(context),
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _handleGoogleSignIn,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'G',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF4285F4),
                                      Color(0xFFDB4437),
                                      Color(0xFFF4B400),
                                      Color(0xFF0F9D58),
                                    ],
                                  ).createShader(const Rect.fromLTWH(0, 0, 24, 24)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Register Link ─────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(color: AppColors.textSecondary)),
                        UIHelper.customTextButton(
                          text: 'Register',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RegistrationScreen()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
