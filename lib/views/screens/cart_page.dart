import 'package:final_project/controllers/cart_provider.dart';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/widgets/cart_page_widget/cart_item_card.dart';
import 'package:final_project/core/widgets/common_widget/custom_elevated_button.dart';
import 'package:final_project/core/widgets/common_widget/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: AppTextstyle.h3),
        leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.popAndPushNamed(context,'/home');
        },
      ),
        actions: [       
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.items.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => cartProvider.clearCart(),
                child: Text(
                  'Clear All',
                  style: AppTextstyle.body.copyWith(
                    color: AppColor.primary,
                    fontSize: 14,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          //  empty state
          if (cartProvider.items.isEmpty) {
            return const EmptyState(
              icon: Icons.shopping_cart_outlined,
              message: 'Your cart is empty',
              subMessage: 'Add some items to get started',
            );
          }

          return Column(
            children: [
              //  cart items
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  itemCount: cartProvider.items.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: screenHeight * 0.01),
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return CartItemCard(item: item); 
                  },
                ),
              ),

              //  summary
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal',
                            style: AppTextstyle.h2
                                .copyWith(color: Colors.black54)),
                        Text(
                          '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: AppTextstyle.body.copyWith(fontSize: 14),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // delivery Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Fee',
                            style: AppTextstyle.h2
                                .copyWith(color: Colors.black54)),
                        Text(
                          'FREE',
                          style: AppTextstyle.body.copyWith(
                            fontSize: 14,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    Divider(
                      height: screenHeight * 0.03,
                      color: Colors.grey.shade200,
                    ),

                    // total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Payable',
                          style: AppTextstyle.body.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                          style: AppTextstyle.body.copyWith(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    //  checkout button
                    CustomElevatedButton(
                      text: 'Proceed to Checkout →',
                      onPressed: () {
                        Navigator.pushNamed(context, '/checkout');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}