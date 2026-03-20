import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickbasket/firebase_options.dart';
import 'package:quickbasket/screens/auth/registration_screen.dart';
import 'constants/app_colors.dart';
import 'screens/auth/login_screen.dart';

/// ─────────────────────────────────────────────────────────────────────
/// QuickBasket — Grocery Delivery Application
/// ─────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const QuickBasketApp());
}

class QuickBasketApp extends StatelessWidget {
  const QuickBasketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickBasket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
