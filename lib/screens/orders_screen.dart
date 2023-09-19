import 'package:flutter/material.dart';
import 'package:my_shop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/side_drawer.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'orders/';

  @override
  Widget build(BuildContext context) {
    final orderedItems = Provider.of<Orders>(context).orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hi"),
      ),
      drawer: const SideDrawer(),
      body: ListView.builder(
        itemCount: orderedItems.length,
        itemBuilder: (context, i) => OrderItemWidget(
          order: orderedItems[i],
        ),
      ),
    );
  }
}
