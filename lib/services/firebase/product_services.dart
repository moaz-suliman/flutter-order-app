import 'package:final_project/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    final snapshot = await db.collection('products').get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .toList();
  }  


  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final snapshot = await db
        .collection('products')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final snapshot = await db.collection('products').get();
    return snapshot.docs
        .map((doc) => ProductModel.fromMap(doc.id, doc.data()))
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}