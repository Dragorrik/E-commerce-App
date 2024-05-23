import 'package:ecom_basic_admin/auth/auth_service.dart';
import 'package:ecom_basic_admin/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class LauncherPage extends StatefulWidget {
  static const String routeName = '/launcher';
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0), () {
      if(AuthService.currentUser != null) {
        Navigator.pushReplacementNamed(context, DashboardPage.routeName);
      } else {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}
