import 'package:final_project/models/product_model.dart';
import 'package:final_project/models/cart_model.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';
import 'package:sqflite/sqflite.dart';

class CartLocalService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<CartModel>> getCartItems() async {
    final db = await _db.database;
    final result = await db.query('cart');
    return result.map((row) => CartModel(
      product: ProductModel(
        id: row['productId'] as String,
        name: row['name'] as String,
        description: row['description'] as String,
        price: row['price'] as double,
        imageUrl: row['imageUrl'] as String,
        category: row['category'] as String,
      ),
      quantity: row['quantity'] as int,
    )).toList();
  }

  Future<void> addToCart(CartModel cartItem) async {
    final db = await _db.database;
    await db.insert(
      'cart',
      {
        'productId': cartItem.product.id,
        'name': cartItem.product.name,
        'description': cartItem.product.description,
        'price': cartItem.product.price,
        'imageUrl': cartItem.product.imageUrl,
        'category': cartItem.product.category,
        'quantity': cartItem.quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> updateQuantity(String productId, int quantity) async {
    final db = await _db.database;
    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> removeFromCart(String productId) async {
    final db = await _db.database;
    await db.delete(
      'cart',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clearCart() async {
    final db = await _db.database;
    await db.delete('cart');
  }
}