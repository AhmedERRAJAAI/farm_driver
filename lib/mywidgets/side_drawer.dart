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
          const Expanded(child: SizedBox()),
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
