import 'package:final_project/controllers/product_provider.dart';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/core/widgets/home_page_widgets.dart/category_chip.dart';
import 'package:final_project/core/widgets/home_page_widgets.dart/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
 @override
void initState() {
  super.initState();
  // استخدام ديليه بسيط لضمان بناء الشجرة قبل طلب البيانات
  Future.delayed(Duration.zero, () {
    if (mounted) {
      context.read<ProductProvider>().getProducts();
    }
  });
}

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // header
              Row(
                  children: [
                    const Icon(Icons.restaurant_menu,
                        color: AppColor.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'TastyBites',
                      style: AppTextstyle.h1.copyWith(
                        color: AppColor.primary,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

              SizedBox(height: screenHeight * 0.02),

              //  search bar
              Container(
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) =>
                      context.read<ProductProvider>().searchProducts(value),
                  decoration: InputDecoration(
                    hintText: 'Search for food, drinks, or restaur...',
                    hintStyle: AppTextstyle.h2.copyWith(fontSize: 13),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.grey),
                    suffixIcon:
                        const Icon(Icons.tune, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              //  categories
              Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: productProvider.categories
                          .map((category) => CategoryChip(
                                category: category,
                                isSelected: productProvider.selectedCategory ==category,
                                onTap: () => productProvider
                                    .filterByCategory(category),
                              ))
                          .toList(),
                    ),
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.02),

              //  popular items header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Items',
                      style: AppTextstyle.h1.copyWith(fontSize: 20)),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: AppTextstyle.body.copyWith(
                        color: AppColor.primary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              //  products grid
              Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  // loading state
                  if (productProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // empty state
                  if (productProvider.filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const Icon(Icons.search_off,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text('No products found',
                              style: AppTextstyle.h2),
                        ],
                      ),
                    );
                  }

                  // products grid
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenWidth * 0.03,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: productProvider.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product=productProvider.filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}