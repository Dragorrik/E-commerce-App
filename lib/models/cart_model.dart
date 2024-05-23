
import 'product_model.dart';

const String collectionCart = 'MyCart';
const String cartFieldProduct = 'product';
const String cartFieldQuantity = 'quantity';


class CartModel {
  ProductModel productModel;
  num quantity;

  CartModel(
      {required this.productModel,
      this.quantity = 1,
      });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      cartFieldProduct: productModel.toMap(),
      cartFieldQuantity: quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
        productModel: ProductModel.fromMap(map[cartFieldProduct]),
        quantity: map[cartFieldQuantity],
      );
}
