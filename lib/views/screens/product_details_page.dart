import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/controllers/cart_provider.dart';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/widgets/common_widget/custom_elevated_button.dart';
import 'package:final_project/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final cartProvider = context.read<CartProvider>();

    return Scaffold(
      body: Column(
        children: [
           // image + appBar
          Stack(
            children: [
              // image
              CachedNetworkImage(
                imageUrl: widget.product.imageUrl,
                height: screenHeight * 0.40,
                width: double.infinity,
                fit: BoxFit.cover,
                //  أثناء تحميل الصورة
                placeholder: (context, url) => Container(
                  height: screenHeight * 0.40,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                 //  إذا فشل تحميل الصورة
                errorWidget: (context, url, error) => Container(
                  height: screenHeight * 0.40,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),

              //  AppBar مع مسافة من الأعلى
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColor.primary, width: 2),
                          ),
                          child: const Icon(Icons.arrow_back,
                              size: 20, color: Colors.white), 
                        ),
                      ),

                      // Title
                      Align(
                        alignment: Alignment.center,
                        child: Text('Product Details',
                            style: AppTextstyle.body.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color:AppColor.black,
                              shadows: [
                                const Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                ),
                              ],
                            )),
                      ),                   
                    ],
                  ),
                ),
              ),

              //  favorite button
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isFavorite
                          ? Colors.red.shade50
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isFavorite ? AppColor.primary : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Best Seller Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'BEST SELLER',
                        style: AppTextstyle.h2.copyWith(
                          color: AppColor.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // name + rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style:
                                AppTextstyle.h1.copyWith(fontSize: 22),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text('4.8',
                                    style: AppTextstyle.body.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    )),
                              ],
                            ),
                            Text('(100+\nreview)',
                                style: AppTextstyle.h2
                                    .copyWith(fontSize: 10),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // description
                    Text(
                      widget.product.description,
                      style: AppTextstyle.h2.copyWith(fontSize: 13),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // price + quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: AppTextstyle.h1.copyWith(
                            color: AppColor.primary,
                            fontSize: 22,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove,
                                    size: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: Text(
                                '$_quantity',
                                style: AppTextstyle.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _quantity++),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: AppColor.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add,
                                    size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // add to cart button
                    CustomElevatedButton(
                      text: 'Add to Cart  •  \$${(widget.product.price * _quantity).toStringAsFixed(2)}',
                      onPressed: () async{
                        for (int i = 0; i < _quantity; i++) {
                         await cartProvider.addToCart(widget.product);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.name} added to cart!',
                              style: AppTextstyle.body
                                  .copyWith(color: Colors.white),
                            ),
                            backgroundColor: AppColor.primary,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}