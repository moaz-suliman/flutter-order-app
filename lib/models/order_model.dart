import 'dart:convert'; // ضروري للتعامل مع JSON
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<dynamic> items;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    // 1. معالجة القائمة (items) سواء كانت List من Firebase أو String من SQLite
    // dynamic لأن البيانات تختلف بين Firebase و SQLite
    List<dynamic> parsedItems = [];
    if (map['items'] != null) {
      if (map['items'] is String) {
        parsedItems = jsonDecode(map['items']);
      } else {
        parsedItems = map['items'] as List<dynamic>;
      }
    }

    // 2. معالجة التاريخ (createdAt) سواء كان Timestamp أو String ISO
    DateTime parsedDate;
    if (map['createdAt'] is Timestamp) {
      parsedDate = (map['createdAt'] as Timestamp).toDate();
    } else if (map['createdAt'] is String) {
      parsedDate = DateTime.parse(map['createdAt']);
    } else {
      parsedDate = DateTime.now();
    }

    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      items: parsedItems,
      // ضمان تحويل الرقم إلى double لتجنب أخطاء النوع
      total: (map['total'] is int) 
          ? (map['total'] as int).toDouble() 
          : (map['total'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'Pending',
      createdAt: parsedDate,
    );
  }

  // دالة للتحويل إلى Map لغايات التخزين في Firebase أو SQLite
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items, // يتم إرسالها كقائمة لـ Firebase
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // دالة مساعدة خصيصاً للـ SQLite لأنها تحتاج التاريخ كـ String والقائمة كـ JSON
  Map<String, dynamic> toLocalMap() {
    return {
      'id': id,
      'userId': userId,
      'items': jsonEncode(items),
      'total': total,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}