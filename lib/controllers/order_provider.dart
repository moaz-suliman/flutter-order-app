import 'package:final_project/models/cart_model.dart';
import 'package:final_project/models/order_model.dart';
import 'package:final_project/services/firebase/order_services.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];
  bool isLoading = false;
  String? errorMessage;

  List<OrderModel> get orders => _orders;

  Future<bool> createOrder({
    required String userId,
    required List<CartModel> cartItems,
    required double total,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final orderData = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        items: cartItems.map((item) => {
          'productId': item.product.id,
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
          'totalPrice': item.totalPrice,
          'imageUrl': item.product.imageUrl,
        }).toList(),
        total: total,
        status: 'Pending',
        createdAt: DateTime.now(),
      );

      // 1. محاولة الإرسال لـ Firebase
      await _orderService.createOrder(orderData);
      
      // 2. حفظ في الـ Local Database كنسخة احتياطية
      await DatabaseHelper.instance.insertOrder(orderData);

      await getUserOrders(userId);
      return true;
    } catch (e) {
      errorMessage = "خطأ: ${e.toString()}";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getUserOrders(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      // محاولة جلب البيانات (Firebase سيعيد بيانات الكاش إذا كنت أوفلاين)
      _orders = await _orderService.getUserOrders(userId);

      // إذا عادت القائمة فارغة (مثلاً أول مرة أوفلاين)، جرب SQLite
      if (_orders.isEmpty) {
        _orders = await DatabaseHelper.instance.getOrders(userId);
      } else {
        // تحديث البيانات المحلية بما جاء من السيرفر
        for (var order in _orders) {
          await DatabaseHelper.instance.insertOrder(order);
        }
      }
      
      errorMessage = null;
    } catch (e) {
      // في حالة الخطأ استرجع ما لديك محلياً
      _orders = await DatabaseHelper.instance.getOrders(userId);
      errorMessage = "تعذر التحديث من السيرفر، يتم عرض البيانات المحلية.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  //  حذف الطلبات عند تسجيل الخروج
void clearOrders() {
  _orders = [];
  notifyListeners();
}
Future<void> deleteOrder(String orderId, String userId) async {
  try {
    await _orderService.deleteOrder(orderId);
    await DatabaseHelper.instance.deleteOrder(orderId);
    _orders.removeWhere((o) => o.id == orderId);
    notifyListeners();
  } catch (e) {
    errorMessage = e.toString();
    notifyListeners();
  }
}
}