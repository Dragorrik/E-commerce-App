import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_basic_admin/models/category_model.dart';
import 'package:ecom_basic_admin/models/image_model.dart';
import 'package:ecom_basic_admin/models/order_constant_model.dart';
import 'package:ecom_basic_admin/models/order_model.dart';
import 'package:ecom_basic_admin/models/product_model.dart';
import 'package:ecom_basic_admin/models/purchase_model.dart';
import 'package:ecom_basic_admin/models/user_model.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collectionAdmin = 'Admins';

  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(collectionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addCategory(CategoryModel categoryModel) {
    final catDoc = _db.collection(collectionCategory).doc();
    categoryModel.categoryId = catDoc.id;
    return catDoc.set(categoryModel.toMap());
  }
  
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPurchases() =>
      _db.collection(collectionPurchase).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllOrders() =>
      _db.collection(collectionOrder).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() =>
      _db.collection(collectionUser).snapshots();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getOrderConstants() =>
      _db.collection(collectionOrderConstant).doc(documentOrderConstant).snapshots();

  static Future<void> addProduct(ProductModel product, PurchaseModel purchase) async {
    final wb = _db.batch();
    final productDoc = _db.collection(collectionProduct).doc();
    final purchaseDoc = _db.collection(collectionPurchase).doc();
    final catDoc = _db.collection(collectionCategory).doc(product.category.categoryId);
    product.productId = productDoc.id;
    purchase.purchaseId = purchaseDoc.id;
    purchase.productModel.productId = productDoc.id;
    final updatedCountInCategory = product.category.productCount + purchase.purchaseQuantity;
    wb.update(catDoc, {categoryFieldProductCount : updatedCountInCategory});
    product.category.productCount = updatedCountInCategory;
    wb.set(productDoc, product.toMap());
    wb.set(purchaseDoc, purchase.toMap());
    return wb.commit();
  }

  static Future<void> repurchase(PurchaseModel purchaseModel) async {
    final wb = _db.batch();
    final purDoc = _db.collection(collectionPurchase).doc();
    purchaseModel.purchaseId = purDoc.id;
    purchaseModel.productModel.stock += purchaseModel.purchaseQuantity;
    final productDoc = _db.collection(collectionProduct).doc(purchaseModel.productModel.productId!);
    wb.update(productDoc, {productFieldStock : purchaseModel.productModel.stock + purchaseModel.purchaseQuantity});
    final catSnapshot = await _db.collection(collectionCategory)
    .doc(purchaseModel.productModel.category.categoryId)
    .get();
    final prevCatProCount = catSnapshot.data()![categoryFieldProductCount];
    final catDoc = _db.collection(collectionCategory).doc(purchaseModel.productModel.category.categoryId);
    wb.update(catDoc, {categoryFieldProductCount : prevCatProCount + purchaseModel.purchaseQuantity});
    wb.set(purDoc, purchaseModel.toMap());
    return wb.commit();
  }

  static Future<void> updateProductField(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProduct).doc(pid)
        .update(map);
  }

  static Future<void> updateOrderConstants(OrderConstantModel model) {
    return _db
        .collection(collectionOrderConstant)
        .doc(documentOrderConstant)
        .set(model.toMap());
  }

}