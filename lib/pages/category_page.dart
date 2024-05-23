import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/utils/helper_functions.dart';
import 'package:ecom_basic_admin/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';

  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CATEGORY LIST'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Add New Category',
            onSubmit: (value) {
              EasyLoading.show(status: 'Please wait');
              Provider
                  .of<ProductProvider>(context, listen: false)
                  .addCategory(value)
              .then((_) {
                EasyLoading.dismiss();
                showMsg(context, 'Category Added');
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return ListTile(
              title: Text(category.categoryName),
              trailing: Text('${category.productCount}', style: const TextStyle(fontSize: 22,),),
            );
          },
        ),
      ),
    );
  }
}
