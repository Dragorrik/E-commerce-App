import 'package:ecom_basic_admin/pages/dashboard_page.dart';
import 'package:ecom_basic_admin/providers/order_provider.dart';
import 'package:ecom_basic_admin/providers/product_provider.dart';
import 'package:ecom_basic_admin/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/add_product_page.dart';
import 'pages/category_page.dart';
import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/order_details_Page.dart';
import 'pages/order_page.dart';
import 'pages/product_details_page.dart';
import 'pages/product_repurchase_page.dart';
import 'pages/report_page.dart';
import 'pages/settings_page.dart';
import 'pages/user_list_page.dart';
import 'pages/view_product_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
  if(message.notification != null) {
    print('You have a notification: ${message.notification!.title}');
  }
  print('DATA: ${message.data['value']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic('order');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
        ChangeNotifierProvider(create: (context) => OrderProvider(),),
        ChangeNotifierProvider(create: (context) => UserProvider(),),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
          actionsIconTheme: Theme.of(context).iconTheme.copyWith(
            color: Colors.white,
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18,),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        DashboardPage.routeName: (_) => const DashboardPage(),
        AddProductPage.routeName: (_) => const AddProductPage(),
        ViewProductPage.routeName: (_) => const ViewProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        CategoryPage.routeName: (_) => const CategoryPage(),
        OrderPage.routeName: (_) => const OrderPage(),
        OrderDetailsPage.routeName: (_) => const OrderDetailsPage(),
        ReportPage.routeName: (_) => const ReportPage(),
        SettingsPage.routeName: (_) => const SettingsPage(),
        ProductRepurchasePage.routeName: (_) => const ProductRepurchasePage(),
        UserListPage.routeName: (_) => const UserListPage(),
      },
    );
  }
}

