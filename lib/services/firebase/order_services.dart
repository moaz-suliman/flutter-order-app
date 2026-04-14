import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOrder(OrderModel order) async {
    try {
      await _db.collection('orders').add(order.toMap());
    } catch (e) {
      rethrow; 
    }
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final snapshot = await _db
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }
  Future<void> deleteOrder(String orderId) async {
  await _db.collection('orders').doc(orderId).delete();
}
}