import 'package:ecom_basic_admin/providers/order_provider.dart';
import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  static const String routeName = '/report';

  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  static const labelTxtStyle = TextStyle(
    fontSize: 30,
    color: Colors.grey,
  );
  static const subLabelTxtStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Orders',
                    style: labelTxtStyle,
                  ),
                  TweenAnimationBuilder<num>(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0, end: provider.totalOrders),
                    builder: (context, value, child) => Text(
                      '${value.round()}',
                      style: labelTxtStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<OrderProvider>(
              builder: (context, provider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Sale',
                    style: labelTxtStyle,
                  ),
                  TweenAnimationBuilder<num>(
                    curve: Curves.easeInOutCubic,
                      duration: const Duration(seconds: 2),
                      tween: Tween(begin: 0, end: provider.totalSale),
                      builder: (context, value, child) => Text(
                            '$currencySymbol${value.round()}',
                            style: labelTxtStyle,
                          )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<ProductProvider>(
              builder: (context, provider, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Purchase',
                    style: labelTxtStyle,
                  ),
                  TweenAnimationBuilder<num>(
                    curve: Curves.easeInOutCubic,
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0, end: provider.totalPurchase),
                    builder: (context, value, child) => Text(
                      '$currencySymbol${value.round()}',
                      style: labelTxtStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
