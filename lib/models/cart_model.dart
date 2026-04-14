import 'package:final_project/models/product_model.dart';

class CartModel {
  final ProductModel product;
  int quantity;

  CartModel({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}