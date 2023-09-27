import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../screens/lots_screen.dart';

class SiteListItem extends StatelessWidget {
  final String name;
  final int lotNbr;
  final int id;
  const SiteListItem({super.key, required this.name, required this.id, required this.lotNbr});

  showLots(BuildContext ctx, siteId) {
    Navigator.of(ctx).pushNamed(LotsScreen.routeName,
        arguments: {'siteId': siteId, 'siteName': name});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => showLots(context, id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Container(
                width: 54,
                height: 58,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Hero(
                    tag: 'siteToLot$id',
                    child: Icon(MdiIcons.sitemapOutline,
                        size: 33, color: const Color(0xFF145da0)),
                  ),
                ),
              ),
              title: Text(
                name,
                style: const TextStyle(
                    color: Color(0xFF145da0), fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Text(lotNbr.toString(),
                      style: const TextStyle(
                          color: Color(0xFF145da0),
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      MdiIcons.circle,
                      color: lotNbr > 0 ? Colors.green : Colors.red[200],
                      size: 15,
                    ),
                  )
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
                size: 25,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
