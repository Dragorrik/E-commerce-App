import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_basic_admin/models/image_model.dart';
import 'package:ecom_basic_admin/models/product_model.dart';
import 'package:ecom_basic_admin/pages/product_repurchase_page.dart';
import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../customwidgets/image_holder_view.dart';
import '../utils/constants.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = '/productdetails';

  const ProductDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late ProductModel productModel;
  late ProductProvider productProvider;

  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    productModel = ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.productName),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            width: double.infinity,
            height: 200,
            imageUrl: productModel.thumbnailImage.downloadUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Card(
              child: ListView(
                padding: const EdgeInsets.all(8.0),
                scrollDirection: Axis.horizontal,
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    },
                    tooltip: 'Add additional image',
                    child: const Icon(Icons.add),
                  ),
                  if (productModel.additionalImages.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Center(
                        child: Text(
                          'Add other images',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ...productModel.additionalImages.map((e) => ImageHolderView(
                        imageModel: e,
                        onImagePressed: () {
                          _showImageOnDialog(e);
                        },
                      )),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  ProductRepurchasePage.routeName,
                  arguments: productModel,
                ),
                child: const Text('Re-Purchase'),
              ),
              OutlinedButton(
                onPressed: _showPurchaseList,
                child: const Text('Purchase History'),
              ),
            ],
          ),
          ListTile(
            title: Text(productModel.productName),
            subtitle: Text(productModel.category.categoryName),
          ),
          ListTile(
            title: Text('Sale Price: $currencySymbol${productModel.salePrice}'),
            subtitle: Text('Stock: ${productModel.stock}'),
          ),
          SwitchListTile(
            value: productModel.available,
            onChanged: (value) {
              setState(() {
                productModel.available = !productModel.available;
              });
              productProvider.updateProductField(productModel.productId!,
                  productFieldAvailable, productModel.available);
            },
            title: const Text('Available'),
          ),
          SwitchListTile(
            value: productModel.featured,
            onChanged: (value) {
              setState(() {
                productModel.featured = !productModel.featured;
              });
              productProvider.updateProductField(productModel.productId!,
                  productFieldFeatured, productModel.featured);
            },
            title: const Text('Featured'),
          ),
          OutlinedButton(
            onPressed: _notifyUser,
            child: const Text('Notify Users'),
          )
        ],
      ),
    );
  }

  void getImage(ImageSource source) async {
    final file =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (file != null) {
      EasyLoading.show(status: 'Please wait');
      final newImage = await productProvider.uploadImage(file.path);
      productModel.additionalImages.add(newImage);
      productProvider.updateProductField(
        productModel.productId!,
        productFieldImages,
        productModel.toImageMapList(),
      ).then((value) {
        showMsg(context, 'Added');
        EasyLoading.dismiss();
        setState(() {});
      }).catchError((error) {
        print(error.toString());
        showMsg(context, 'Failed to add');
        EasyLoading.dismiss();
      });
    }
  }

  void _showPurchaseList() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          final pList =
              productProvider.getPurchasesByProductId(productModel.productId!);
          return Container(
            margin: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: pList.length,
              itemBuilder: (context, index) {
                final purchase = pList[index];
                return ListTile(
                  title: Text(
                      getFormattedDate(purchase.dateModel.timestamp.toDate())),
                  subtitle: Text('$currencySymbol${purchase.purchasePrice}'),
                  trailing: Text('Qty: ${purchase.purchaseQuantity}'),
                );
              },
            ),
          );
        });
  }

  void _showImageOnDialog(ImageModel image) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: CachedNetworkImage(
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height / 2,
                imageUrl: image.downloadUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    EasyLoading.show(status: 'Deleting...');
                    try {
                      await productProvider.deleteImage(
                          productModel.productId!, image);
                      productModel.additionalImages.remove(image);
                      await productProvider.updateProductField(
                        productModel.productId!,
                        productFieldImages,
                        productModel.toImageMapList(),
                      );
                      EasyLoading.dismiss();
                      setState(() {});
                    } catch (error) {
                      EasyLoading.dismiss();
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ));
  }

  void _notifyUser() {}
}
