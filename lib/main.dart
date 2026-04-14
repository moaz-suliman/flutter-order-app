import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:final_project/controllers/auth_provider.dart';
import 'package:final_project/controllers/cart_provider.dart';
import 'package:final_project/controllers/order_provider.dart';
import 'package:final_project/controllers/product_provider.dart';
import 'package:final_project/firebase_options.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';
import 'package:final_project/views/auth/create_account.dart';
import 'package:final_project/views/common/bottom_navigation_bar.dart';
import 'package:final_project/views/auth/login_screen.dart';
import 'package:final_project/views/auth/splash_screen.dart';
import 'package:final_project/views/screens/checkout_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تفعيل خاصية حفظ البيانات أوفلاين (Firestore Persistence)
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // تهيئة SQLite
  await DatabaseHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()..loadCart()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Alexandria',
        scaffoldBackgroundColor: const Color(0xfff6f7f6),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xfff6f7f6),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const CreateAccountScreen(),
        '/home': (context) => const HomeScreen(),
        '/checkout': (context) => const CheckoutScreen(),
      },
    );
  }
}
