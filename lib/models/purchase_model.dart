
import 'package:ecom_basic_admin/models/product_model.dart';

import 'date_model.dart';
const String collectionPurchase='Purchases';

const String purchaseFieldId='purchaseId';
const String purchaseFieldProduct='product';
const String purchaseFieldQuantity='purchaseQuantity';
const String purchaseFieldPrice='purchasePrice';
const String purchaseFieldDateModel='dateModel';


class PurchaseModel{
 String? purchaseId;
 ProductModel productModel;
 num purchaseQuantity;
 num purchasePrice;
 DateModel dateModel;

 PurchaseModel({
   this.purchaseId,
   required this.productModel,
   required this.purchaseQuantity,
   required this.purchasePrice,
   required this.dateModel,
 });

 Map<String,dynamic>toMap(){
   return <String,dynamic>{
     purchaseFieldId:purchaseId,
     purchaseFieldProduct:productModel.toMap(),
     purchaseFieldQuantity:purchaseQuantity,
     purchaseFieldPrice:purchasePrice,
     purchaseFieldDateModel:dateModel.toMap(),
   };
 }

 factory PurchaseModel.fromMap(Map<String,dynamic>map)=>PurchaseModel(
   purchaseId:map[purchaseFieldId],
   productModel: ProductModel.fromMap(map[purchaseFieldProduct]),
   purchaseQuantity: map[purchaseFieldQuantity],
   purchasePrice:map[purchaseFieldPrice],
   dateModel: DateModel.fromMap(map[purchaseFieldDateModel]),
 );
}