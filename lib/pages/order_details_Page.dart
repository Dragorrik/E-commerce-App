import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/order_model.dart';
import '../utils/constants.dart';
import '../utils/helper_functions.dart';

class OrderDetailsPage extends StatelessWidget {
  static const String routeName = '/order_details';

  const OrderDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [],
      ),
    );
  }
}
