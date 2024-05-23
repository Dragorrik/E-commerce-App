import 'dart:io';

import 'package:ecom_basic_admin/auth/auth_service.dart';
import 'package:ecom_basic_admin/customwidgets/badge_view.dart';
import 'package:ecom_basic_admin/providers/order_provider.dart';
import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customwidgets/dashboard_item_view.dart';
import '../models/dashboard_model.dart';
import 'add_product_page.dart';
import 'category_page.dart';
import 'dashboard_home.dart';
import 'launcher_page.dart';
import 'order_page.dart';
import 'report_page.dart';
import 'settings_page.dart';
import 'user_list_page.dart';
import 'view_product_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {

    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    Provider.of<OrderProvider>(context, listen: false).getAllOrders();
    Provider.of<UserProvider>(context, listen: false).getAllUsers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGrey5,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout().then((value) => Navigator.pushReplacementNamed(context, LauncherPage.routeName));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
        ),
        itemCount: dashboardModelList.length,
        itemBuilder: (context, index) {
          final model = dashboardModelList[index];
          return DashboardItemView(
            model: dashboardModelList[index],
          );
        },
      ),
    );
  }
}
