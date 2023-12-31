import 'package:flutter/material.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
  });
}


class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void placeOrder(List<CartItem> cartProducts, double amount) {
  
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            products: cartProducts,
            amount: amount,
            dateTime: DateTime.now()));
    
    notifyListeners();
  }
}
