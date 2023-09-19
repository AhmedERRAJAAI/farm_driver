import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
// import '../screens/charts_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 60,
                color: const Color(0xFF145da0),
                child: const Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "FARM DRIVER",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      Text(
                        " by SAVAS",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ),
              // ListTile(
              //   leading: const Icon(Icons.shopping_cart_checkout),
              //   title: const Text("Charts"),
              //   onTap: () {
              //     goToPage(context, ChartsScreen.routeName);
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  "LOGOUT",
                ),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            ]),
      ),
    );
  }
}

// AppBar(
//           title: const Text(
//             "FARM DRIVER",
//             style: TextStyle(
//                 color: Color(0xFF145da0),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.italic,
//                 letterSpacing: 2),
//           ),
//           leading: Text('SAVAS'),
//           automaticallyImplyLeading: false,
//         ),
//         const Divider(),
