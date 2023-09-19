import 'package:flutter/material.dart';

class EcartChip extends StatelessWidget {
  final String colorName;
  final double ecart;
  final int directionIndex;

  EcartChip({
    required this.colorName,
    required this.ecart,
    required this.directionIndex,
  });

  final Map<String, Color> colors = {
    'red': const Color(0xFFD54503),
    'green': const Color(0xFF006203),
    'orange': const Color(0xFFFFAE00)
  };

  final Map<String, Color> bgcolors = {
    'red': const Color(0xFFFFCAC7),
    'green': const Color(0xFFDBFFDC),
    'orange': const Color(0xFFFEE6C5),
  };

  final List<IconData> myIcons = [
    Icons.trending_down,
    Icons.done,
    Icons.trending_up,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.only(left: 6),
      decoration: BoxDecoration(
        border: Border.all(color: colors[colorName] ?? Colors.green),
        borderRadius: BorderRadius.circular(10),
        color: bgcolors[colorName],
      ),
      child: Row(
        children: <Widget>[
          Text(
            ecart.toString(),
            style: TextStyle(fontSize: 12, color: colors[colorName]),
          ),
          Icon(
            myIcons[directionIndex],
            color: colors[colorName],
            size: 14,
          )
        ],
      ),
    );
  }
}
