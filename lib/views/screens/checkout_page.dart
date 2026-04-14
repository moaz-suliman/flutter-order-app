import 'package:final_project/controllers/auth_provider.dart';
import 'package:final_project/controllers/cart_provider.dart';
import 'package:final_project/controllers/order_provider.dart';
import 'package:final_project/core/constents/app_color.dart'; 
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/widgets/cart_page_widget/cart_item_card.dart';
import 'package:final_project/core/widgets/common_widget/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onConfirmPressed() async {
    final cartProvider = context.read<CartProvider>();
    final authProvider = context.read<AuthProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first"), backgroundColor: Colors.red),
      );
      return;
    }

    final result = await orderProvider.createOrder(
      userId: authProvider.user!.uid,
      cartItems: cartProvider.items,
      total: cartProvider.totalPrice,
    );

    if (result) {
      await cartProvider.clearCart();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'), 
            backgroundColor: AppColor.primary, 
          ),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(orderProvider.errorMessage ?? 'Order Failed'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height; 
    
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text('Checkout', style: AppTextstyle.h3),
        centerTitle: true,
        backgroundColor: AppColor.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary', style: AppTextstyle.body.copyWith(fontWeight: FontWeight.w700)),
                SizedBox(height: screenHeight * 0.01), 
                
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartProvider.items.length,
                  separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.015), 
                  itemBuilder: (context, index) => CartItemCard(item: cartProvider.items[index]),
                ),
                
                SizedBox(height: screenHeight * 0.03), 
                
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      _buildRow('Total', '\$${cartProvider.totalPrice.toStringAsFixed(2)}', isBold: true),
                    ],
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.05), 
                
                CustomElevatedButton(
                  text: orderProvider.isLoading ? 'Processing...' : 'Confirm Order',
                  onPressed: orderProvider.isLoading ? () {} : _onConfirmPressed,
                ),
                
                SizedBox(height: screenHeight * 0.02), 
              ],
            ),
          ),
          if (orderProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator(color: AppColor.primary)),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextstyle.h2),
        Text(value, style: AppTextstyle.body.copyWith(
          fontWeight: isBold ? FontWeight.bold : null,
          color: isBold ? AppColor.primary : AppColor.black,
        )),
      ],
    );
  }
}