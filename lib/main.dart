import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickbasket/firebase_options.dart';
import 'constants/app_colors.dart';

// ── Auth Screens ─────────────────────────────────────────────────────
import 'screens/auth/login_screen.dart';
import 'screens/auth/registration_screen.dart';

// ── Admin Screens ────────────────────────────────────────────────────
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/manage_categories_screen.dart';
import 'screens/admin/manage_products_screen.dart';
import 'screens/admin/manage_delivery_persons_screen.dart';
import 'screens/admin/manage_orders_screen.dart';
import 'screens/admin/admin_profile_screen.dart';

// ── Customer Screens ─────────────────────────────────────────────────
import 'screens/customer/customer_home_screen.dart';
import 'screens/customer/category_products_screen.dart';
import 'screens/customer/product_details_screen.dart';
import 'screens/customer/cart_screen.dart';
import 'screens/customer/checkout_screen.dart';
import 'screens/customer/customer_orders_screen.dart';
import 'screens/customer/wishlist_screen.dart';
import 'screens/customer/customer_profile_screen.dart';
import 'screens/customer/invoice_screen.dart';

// ── Delivery Screens ─────────────────────────────────────────────────
import 'screens/delivery/delivery_dashboard.dart';
import 'screens/delivery/assigned_orders_screen.dart';
import 'screens/delivery/delivery_profile_screen.dart';

/// ─────────────────────────────────────────────────────────────────────
/// QuickBasket — Grocery Delivery Application
/// ─────────────────────────────────────────────────────────────────────
///
/// TODO: Firebase Integration Checklist
///   1. Add firebase_core, firebase_auth, cloud_firestore to pubspec.yaml
///   2. Initialize Firebase in main() → await Firebase.initializeApp()
///   3. Replace mock login/register with FirebaseAuth calls
///   4. Replace dummy data with Firestore queries
///   5. Add Razorpay package for payment integration in CheckoutScreen
///   6. Add pdf & printing packages for InvoiceScreen
/// ─────────────────────────────────────────────────────────────────────

void main()async{
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

      // ── Start Route ────────────────────────────────────────
      initialRoute: '/delivery-dashboard',

      // ── Named Routes ───────────────────────────────────────
      routes: {
        // Auth
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegistrationScreen(),

        // Admin Panel
        '/admin-dashboard': (_) => const AdminDashboard(),
        '/admin-categories': (_) => const ManageCategoriesScreen(),
        '/admin-products': (_) => const ManageProductsScreen(),
        '/admin-delivery-persons': (_) => const ManageDeliveryPersonsScreen(),
        '/admin-orders': (_) => const ManageOrdersScreen(),
        '/admin-profile': (_) => const AdminProfileScreen(),

        // Customer Panel
        '/customer-home': (_) => const CustomerHomeScreen(),
        '/category-products': (_) => const CategoryProductsScreen(),
        '/product-details': (_) => const ProductDetailsScreen(),
        '/customer-cart': (_) => const CartScreen(),
        '/customer-checkout': (_) => const CheckoutScreen(),
        '/customer-orders': (_) => const CustomerOrdersScreen(),
        '/customer-wishlist': (_) => const WishlistScreen(),
        '/customer-profile': (_) => const CustomerProfileScreen(),
        '/customer-invoice': (_) => const InvoiceScreen(),

        // Delivery Panel
        '/delivery-dashboard': (_) => const DeliveryDashboard(),
        '/delivery-assigned-orders': (_) => const AssignedOrdersScreen(),
        '/delivery-profile': (_) => const DeliveryProfileScreen(),
      },
    );
  }
}
