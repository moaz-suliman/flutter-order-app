import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/localBase/product_local_service.dart'; 
import 'package:final_project/services/firebase/product_services.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final ProductLocalService _productLocalService = ProductLocalService(); // 

  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool isLoading = false;
  String? errorMessage;
  String _selectedCategory = 'All';

  List<ProductModel> get products => _products;
  List<ProductModel> get filteredProducts => _filteredProducts;
  String get selectedCategory => _selectedCategory;

  Future<void> getProducts() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // الخطوة 1: جلب البيانات من SQLite أولاً لضمان السرعة وعمل الأوفلاين فوراً
      final localProducts = await _productLocalService.getProducts();
      if (localProducts.isNotEmpty) {
        _products = localProducts;
        _filteredProducts = _products;
        isLoading = false; // ننهي حالة التحميل بمجرد ظهور بيانات الجهاز
        notifyListeners();
      }

      // الخطوة 2:  جديد - حاول الجلب من Firebase أولاً (لتحديث البيانات)
      final remoteProducts = await _productService.getProducts();
      _products = remoteProducts;
      _filteredProducts = _products;

      //  جديد - احفظ في SQLite للاستخدام offline (تحديث الكاش المحلي)
      await _productLocalService.saveProducts(_products);

    } catch (e) {
      //  جديد - إذا فشل Firebase اقرأ من SQLite (في حال لم نقرأ منها في البداية)
      if (_products.isEmpty) {
        final localProducts = await _productLocalService.getProducts();
        if (localProducts.isNotEmpty) {
          _products = localProducts;
          _filteredProducts = _products;
        } else {
          errorMessage = e.toString();
        }
      }
      debugPrint("Offline mode or Network error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  List<String> get categories {
    // استخدمنا set لمنع التكرار و toList لتحويلها لقائمة
    final categoriesSet = _products.map((p) => p.category).toSet().toList();
    // التأكد من عدم إضافة All أكثر من مرة
    if (!categoriesSet.contains('All')) {
      categoriesSet.insert(0, 'All');
    }
    return categoriesSet;
  }
}