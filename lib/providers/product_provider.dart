import 'dart:io';

import 'package:ecom_basic_admin/db/db_helper.dart';
import 'package:ecom_basic_admin/models/image_model.dart';
import 'package:ecom_basic_admin/models/product_model.dart';
import 'package:ecom_basic_admin/models/purchase_model.dart';
import 'package:ecom_basic_admin/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../models/category_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  List<PurchaseModel> purchaseList = [];

  Future<void> addCategory(String name) {
    final category = CategoryModel(categoryName: name);
    return DbHelper.addCategory(category);
  }
  
  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) { 
      categoryList = List.generate(snapshot.docs.length, (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllPurchases() {
    DbHelper.getAllPurchases().listen((snapshot) {
      purchaseList = List.generate(snapshot.docs.length, (index) => PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> updateProductField(String pid, String field, dynamic value) {
    return DbHelper.updateProductField(pid, {field : value});
  }

  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('$imageDirectory$imageName');
    final uploadTask = photoRef.putFile(File(imageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return ImageModel(
      imageName: imageName,
      downloadUrl: url,
      directoryName: imageDirectory,
    );
  }

  Future<void> addProduct(ProductModel product, PurchaseModel purchase) {
    return DbHelper.addProduct(product, purchase);
  }

  Future<void> repurchase(PurchaseModel purchaseModel) {
    return DbHelper.repurchase(purchaseModel);
  }

  List<PurchaseModel> getPurchasesByProductId(String productId) {
    return purchaseList.where((purchase) => purchase.productModel.productId == productId).toList();
  }

  Future<void> deleteImage(String pid, ImageModel image) async {
    final photoRef = FirebaseStorage.instance.ref()
        .child('${image.directoryName}${image.imageName}');
    return photoRef.delete();
  }

  num get totalPurchase {
    num total = 0;
    for(final p in purchaseList) {
      total += p.purchasePrice;
    }
    return total;
  }
}