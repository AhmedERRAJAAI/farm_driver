import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/auth.dart';

import '../eggs_selling/screens/dashboard_eggs_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  ),
                  Text(
                    " by SAVAS",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.spa),
                  title: const Text("Zootechnique"),
                  onTap: () {
                    goToPage(context, "/");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.egg),
                  title: const Text("Vente de oeufs"),
                  onTap: () {
                    goToPage(context, EggsDashboard.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(
                    MdiIcons.barley,
                  ),
                  title: const Text("Nutrition & alimentation"),
                  onTap: () {
                    // goToPage(context, ChartsScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
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
