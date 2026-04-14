import 'package:final_project/models/cart_model.dart';
import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/localBase/cart_local_service.dart'; 
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final CartLocalService _cartLocalService = CartLocalService(); 
  List<CartModel> _items = []; 

  List<CartModel> get items => _items;

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  // تحميل السلة من المحلي
  Future<void> loadCart() async {
    try {
      _items = await _cartLocalService.getCartItems();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
    notifyListeners();
  }

  Future<void> addToCart(ProductModel product) async { 
    try {
      final index = _items.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        // المنتج موجود  زيادة الكمية
        _items[index].quantity++;
        await _cartLocalService.updateQuantity(product.id, _items[index].quantity);
      } else {
        // منتج جديد اذا إضافة
        final cartItem = CartModel(product: product);
        _items.add(cartItem);
        await _cartLocalService.addToCart(cartItem); 
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  // إزالة منتج
  Future<void> removeFromCart(String productId) async {
    try {
      _items.removeWhere((item) => item.product.id == productId);
      await _cartLocalService.removeFromCart(productId); 
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from cart: $e');
    }
  }

  // زيادة الكمية
  Future<void> increaseQuantity(String productId) async { 
    try {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        _items[index].quantity++;
        await _cartLocalService.updateQuantity(productId, _items[index].quantity); 
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error increasing quantity: $e');
    }
  }

  // تقليل الكمية
  Future<void> decreaseQuantity(String productId) async { 
    try {
      final index = _items.indexWhere((item) => item.product.id == productId);
      if (index != -1) {
        if (_items[index].quantity > 1) {
          _items[index].quantity--;
          await _cartLocalService.updateQuantity(productId, _items[index].quantity); 
        } else {
          _items.removeAt(index);
          await _cartLocalService.removeFromCart(productId); 
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error decreasing quantity: $e');
    }
  }

  // التحقق إذا كان المنتج في السلة
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // جلب كمية منتج معين
  int getQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? _items[index].quantity : 0;
  }

  // تفريغ السلة
  Future<void> clearCart() async {
    try {
      _items.clear();
      await _cartLocalService.clearCart();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing cart: $e');
    }
  }
}