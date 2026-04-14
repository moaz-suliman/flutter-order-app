import 'package:final_project/controllers/auth_provider.dart';
import 'package:final_project/controllers/order_provider.dart';
import 'package:final_project/core/constents/app_color.dart'; 
import 'package:final_project/core/constents/app_textStyle.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Profile', style: AppTextstyle.h3),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColor.white,
        foregroundColor: AppColor.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.03),      
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.08),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black.withOpacity(0.05),
                    spreadRadius: 2,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // الصورة الشخصية
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.primary.withOpacity(0.2), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColor.grey.withOpacity(0.1),
                      backgroundImage: authProvider.user?.photoURL != null 
                          ? NetworkImage(authProvider.user!.photoURL!) 
                          : null,
                      child: authProvider.user?.photoURL == null 
                          ? const Icon(Icons.person, size: 50, color: AppColor.primary)
                          : null,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  
                  Text(
                    authProvider.userData?.name ?? "Guest User",
                    style: AppTextstyle.body.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700, 
                    ),
                  ),
                  
                  Text(
                    authProvider.user?.email ?? "No Email found",
                    style: AppTextstyle.h2.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // log out button
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.05),
              child: InkWell(
               onTap: () async {
                  context.read<OrderProvider>().clearOrders();
                  
                  await authProvider.signOut();
                  
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false,
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: AppTextstyle.body.copyWith(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}