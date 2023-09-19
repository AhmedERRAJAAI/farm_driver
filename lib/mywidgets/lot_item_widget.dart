import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../screens/display_data_screen.dart';

class LotListItem extends StatelessWidget {
  final String name;
  final String batname;
  final int? effectif;
  final int? edp;
  final int? fAge;
  final int? lAge;
  final int? id;

  LotListItem(
      {required this.name,
      required this.id,
      required this.batname,
      this.fAge,
      this.lAge,
      required this.effectif,
      required this.edp});

  showReports(BuildContext ctx, lotId) {
    Navigator.of(ctx).pushNamed(DisplayDataScreen.routeName, arguments: {
      'lotId': lotId,
      'lotCode': name,
      'batiment': batname,
      'edp': edp,
      'fage': fAge,
      'lage': lAge,
      'ep': effectif,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => showReports(context, id),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/chicken.png'),
                      Chip(
                        label: Text(batname),
                        padding: EdgeInsets.zero,
                      )
                    ],
                  ),
                ),
              ),
              title: Text(
                name,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Text(effectif.toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      MdiIcons.circle,
                      color: Colors.green,
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
        const SizedBox(height: 4)
      ],
    );
  }
}
