import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LightWidget extends StatelessWidget {
  final String? starts_at;
  final String? end_at;
  final String period;
  final String name;
  final int id;
  LightWidget({
    required this.name,
    required this.period,
    required this.id,
    this.starts_at,
    this.end_at,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$starts_at ',
                  style: TextStyle(
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  MdiIcons.lightbulbOn10,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$end_at ',
                  style: TextStyle(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
                Icon(
                  MdiIcons.lightbulbOffOutline,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$period '),
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
