import 'package:ecom_basic_admin/db/db_helper.dart';
import 'package:ecom_basic_admin/models/order_model.dart';
import 'package:flutter/foundation.dart';

import '../models/order_constant_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantModel orderConstantModel = OrderConstantModel();
  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;

  int get totalOrders => _orderList.length;

  getAllOrders() {
    DbHelper.getAllOrders().listen((event) {
      _orderList = List.generate(event.docs.length, (index) =>
      OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getOrderConstants() {
    DbHelper.getOrderConstants().listen((snapshot) {
      if(snapshot.exists) {
        orderConstantModel = OrderConstantModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> updateOrderConstants(OrderConstantModel model) {
    return DbHelper.updateOrderConstants(model);
  }

  int getOrdersByStatus(String status) {
    return orderList.where((element) => element.orderStatus == status).length;
  }

  num get totalSale {
    num total = 0;
    for(final order in _orderList) {
      total += order.grandTotal;
    }
    return total;
  }




}