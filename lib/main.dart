import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'utils/app_theme.dart';
import 'widgets/network_wrapper.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/checkout_provider.dart';

import 'core/local_storage.dart';
import 'core/di/injection.dart'; // Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(); // Inisialisasi DI Container

  await LocalStorage.saveOwnerToken('6c09eae77eaef74539acb3f2b3490ca29878cbe6');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );

  runApp(const FurnitureApp());
}

class FurnitureApp extends StatelessWidget {
  const FurnitureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => locator<ProductProvider>()..loadProducts(),
        ),
        ChangeNotifierProvider(create: (_) => locator<CartProvider>()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
      ],
      child: MaterialApp(
        title: 'Luxe Furnish',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/cart': (context) => const CartScreen(), // ← tambah
          '/checkout': (context) => const CheckoutScreen(), // ← tambah
        },
      ),
    );
  }
}

