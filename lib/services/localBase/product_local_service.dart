import 'package:final_project/models/product_model.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<List<ProductModel>> getProducts() async {
    final db = await _db.database;
    final result = await db.query('products');
    return result
        .map((row) => ProductModel(
              id: row['id'] as String,
              name: row['name'] as String,
              description: row['description'] as String,
              price: row['price'] as double,
              imageUrl: row['imageUrl'] as String,
              category: row['category'] as String,
            ))
        .toList();
  }

  Future<void> saveProducts(List<ProductModel> products) async {
    final db = await _db.database;
    final batch = db.batch();
    for (final product in products) {
      batch.insert(
        'products',
        {
          'id': product.id,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  //  التحقق إذا كان يوجد منتجات محفوظة
  Future<bool> hasProducts() async {
    final db = await _db.database;
    final result = await db.query('products', limit: 1);
    return result.isNotEmpty;
  }

  Future<void> clearProducts() async {
    final db = await _db.database;
    await db.delete('products');
  }
}