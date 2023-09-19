import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/user_products_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: const Text("Hello drawer"),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Shop"),
          onTap: () {
            goToPage(context, "/");
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shopping_cart_checkout),
          title: const Text("Orders"),
          onTap: () {
            goToPage(context, OrdersScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text("Cart"),
          onTap: () {
            goToPage(context, CartScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("User Products"),
          onTap: () {
            goToPage(context, UserProductScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("LOGOUT"),
          onTap: () {
            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("TEST"),
          onTap: () {
            Provider.of<Auth>(context, listen: false).tryAutoLogin();
          },
        ),
      ]),
    );
  }
}
