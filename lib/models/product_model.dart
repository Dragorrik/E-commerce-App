

import 'package:ecom_basic_admin/models/image_model.dart';

import 'category_model.dart';

const String collectionProduct = 'Products';
const String productFieldId = 'productId';
const String productFieldName = 'productName';
const String productFieldCategory = 'category';
const String productFieldShortDescription = 'shortDescription';
const String productFieldLongDescription = 'LongDescription';
const String productFieldSalePrice = 'salePrice';
const String productFieldStock = 'stock';
const String productFieldAvgRating = 'avgRating';
const String productFieldDiscount = 'discount';
const String productFieldThumbnail = 'thumbnail';
const String productFieldImages = 'images';
const String productFieldAvailable = 'available';
const String productFieldFeatured = 'featured';

class ProductModel {
  String? productId;
  String productName;
  CategoryModel category;
  String shortDescription;
  String longDescription;
  num salePrice;
  num stock;
  num avgRating;
  num productDiscount;
  ImageModel thumbnailImage;
  List<ImageModel> additionalImages;
  bool available;
  bool featured;

  ProductModel(
      {this.productId,
      required this.productName,
      required this.category,
      this.shortDescription = '',
      this.longDescription = '',
      required this.salePrice,
      required this.stock,
      this.productDiscount = 0,
      this.avgRating = 0.0,
      required this.thumbnailImage,
      required this.additionalImages,
      this.available = true,
      this.featured = false});

  Map<String, dynamic> toMap() {
    return <String,dynamic>{
      productFieldId : productId,
      productFieldName : productName,
      productFieldCategory : category.toMap(),
      productFieldShortDescription : shortDescription,
      productFieldLongDescription : longDescription,
      productFieldDiscount : productDiscount,
      productFieldSalePrice : salePrice,
      productFieldStock : stock,
      productFieldAvgRating : avgRating,
      productFieldThumbnail : thumbnailImage.toJson(),
      productFieldImages : additionalImages.map((imageModel) => imageModel.toJson()).toList(),
      productFieldAvailable : available,
      productFieldFeatured : featured,
    };
  }

  factory ProductModel.fromMap(Map<String,dynamic> map) => ProductModel(
    productId: map[productFieldId],
    productName: map[productFieldName],
    category: CategoryModel.fromMap(map[productFieldCategory]),
    shortDescription: map[productFieldShortDescription],
    longDescription: map[productFieldLongDescription],
    salePrice: map[productFieldSalePrice],
    stock: map[productFieldStock],
    avgRating: map[productFieldAvgRating],
    productDiscount: map[productFieldDiscount],
    thumbnailImage: ImageModel.fromJson(map[productFieldThumbnail]),
    additionalImages: (map[productFieldImages] as List)
    .map((e) => ImageModel.fromJson(e)).toList(),
    available: map[productFieldAvailable],
    featured: map[productFieldFeatured],
  );

  List<Map<String, dynamic>> toImageMapList() {
    return List.generate(additionalImages.length, (index) => additionalImages[index].toJson());
  }
}