import 'dart:async';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/views/common/bottom_navigation_bar.dart';
import 'package:final_project/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.08).animate(_controller);

    _checkAuthAndNavigate();
  }

void _checkAuthAndNavigate() {
  Timer(const Duration(seconds: 3), () async {
    if (!mounted) return;

    final String? savedUid = await DatabaseHelper.instance.getUid();

    if (!mounted) return;

    if (savedUid != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  });
}

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBackgroundIcons(double screenWidth, double screenHeight) {
    final icons = [
      Icons.fastfood, Icons.local_pizza, Icons.coffee, Icons.icecream,
      Icons.restaurant, Icons.cake, Icons.lunch_dining, Icons.set_meal,
      Icons.local_cafe, Icons.fastfood, Icons.local_pizza, Icons.coffee,
      Icons.icecream, Icons.restaurant, Icons.cake, Icons.lunch_dining,
    ];

    final double iconSize = screenWidth * 0.17;
    final double spacing = screenWidth * 0.05;

    return Transform.rotate(
      angle: -0.2,
      child: Wrap(
        spacing: spacing,
        runSpacing: screenHeight * 0.04,
        children: List.generate(
          icons.length,
          (index) => Icon(
            icons[index],
            size: iconSize,
            color: const Color(0xff4cae4f).withOpacity(0.15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double logoSize = screenWidth * 0.30;
    final double logoIconSize = logoSize * 0.50;

    return Scaffold(
      backgroundColor: const Color(0xfff6f7f6),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.50,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: buildBackgroundIcons(screenWidth, screenHeight),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: const BoxDecoration(
                      color: AppColor.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: logoIconSize,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const Text("TastyBites", style: AppTextstyle.h1),
                SizedBox(height: screenHeight * 0.01),
                const Text("Delicious moments, delivered.", style: AppTextstyle.h2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}