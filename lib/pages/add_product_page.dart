import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_basic_admin/models/category_model.dart';
import 'package:ecom_basic_admin/models/date_model.dart';
import 'package:ecom_basic_admin/models/image_model.dart';
import 'package:ecom_basic_admin/models/product_model.dart';
import 'package:ecom_basic_admin/models/purchase_model.dart';
import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/utils/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/addproduct';

  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CategoryModel? categoryModel;
  String? imageLocalPath;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          IconButton(
            onPressed: _saveProduct,
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Column(
                children: [
                  imageLocalPath == null
                      ? const Icon(
                          Icons.photo,
                          size: 100,
                        )
                      : Image.file(
                          File(imageLocalPath!),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Capture'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.photo_album),
                        label: const Text('Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _selectDate,
                      child: const Text('Select Purchase Date'),
                    ),
                    Text(dateTime == null
                        ? 'No date chosen'
                        : getFormattedDate(dateTime!)),
                  ],
                ),
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, provider, child) =>
                  DropdownButtonFormField<CategoryModel>(
                onChanged: (value) {
                  categoryModel = value;
                },
                hint: const Text('Select Category'),
                isExpanded: true,
                value: categoryModel,
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                items: provider.categoryList
                    .map((category) => DropdownMenuItem<CategoryModel>(
                        value: category, child: Text(category.categoryName)))
                    .toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                maxLines: 2,
                controller: _shortDescriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Short Description(optional)',
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                maxLines: 3,
                controller: _longDescriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Long Description(optional)',
                ),
                validator: (value) {
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _purchasePriceController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Purchase Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Price should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _salePriceController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Sale Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Price should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _quantityController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Quantity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) <= 0) {
                    return 'Quantity should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: _discountController,
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Enter Discount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (num.parse(value) < 0) {
                    return 'Discount should not be a negative value';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    final file =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (file != null) {
      setState(() {
        imageLocalPath = file.path;
      });
    }
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        dateTime = date;
      });
    }
  }

  void _saveProduct() async {
    if (imageLocalPath == null) {
      showMsg(context, 'Please select a product image');
      return;
    }
    if (dateTime == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');

      try {
        final imageModel =
            await Provider.of<ProductProvider>(context, listen: false)
                .uploadImage(imageLocalPath!);
        final product = ProductModel(
          productName: _nameController.text,
          shortDescription: _shortDescriptionController.text,
          longDescription: _longDescriptionController.text,
          category: categoryModel!,
          salePrice: num.parse(_salePriceController.text),
          stock: num.parse(_quantityController.text),
          productDiscount: num.parse(_discountController.text),
          thumbnailImage: imageModel,
          additionalImages: <ImageModel>[],
        );
        final purchase = PurchaseModel(
          productModel: product,
          purchasePrice: num.parse(_purchasePriceController.text),
          purchaseQuantity: num.parse(_quantityController.text),
          dateModel: DateModel(
            timestamp: Timestamp.fromDate(dateTime!),
            day: dateTime!.day,
            month: dateTime!.month,
            year: dateTime!.year,
          ),
        );
        Provider.of<ProductProvider>(context, listen: false)
        .addProduct(product, purchase)
        .then((value) {
          showMsg(context, 'Saved');
          EasyLoading.dismiss();
          _resetFields();
        });
      } catch (error) {
        EasyLoading.dismiss();
        showMsg(context, 'could not save');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _salePriceController.dispose();
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _nameController.clear();
      _shortDescriptionController.clear();
      _longDescriptionController.clear();
      _purchasePriceController.clear();
      _quantityController.clear();
      _discountController.clear();
      _salePriceController.clear();
      dateTime = null;
      categoryModel = null;
      imageLocalPath = null;
    });
  }
}
