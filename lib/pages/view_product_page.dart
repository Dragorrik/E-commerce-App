import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom_basic_admin/pages/product_details_page.dart';
import 'package:ecom_basic_admin/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.productList.length,
          itemBuilder: (context, index) {
            final product = provider.productList[index];
            return ListTile(
              onTap: () {
                Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product);
              },
              title: Text(product.productName),
              subtitle: Text('Stock: ${product.stock}'),
              trailing: Text('$currencySymbol${product.salePrice}'),
            );
          },
        ),
      ),
    );
  }
}
