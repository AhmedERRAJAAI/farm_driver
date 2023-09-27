import 'package:flutter/material.dart';

class ConsoWidget extends StatelessWidget {
  final double aps;
  final double eps;
  final double ratio;
  final String ratioColor;
  final int id;
  ConsoWidget({super.key, 
    required this.id,
    required this.aps,
    required this.eps,
    required this.ratio,
    required this.ratioColor,
  });

  final Map<String, Color> colors = {
    'red': const Color(0xFFD54503),
    'green': const Color(0xFF006203),
    'orange': const Color(0xFFFFAE00)
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Alt/sujet: ',
                style: TextStyle(color: Colors.brown),
              ),
              Text(
                '$aps',
                style: const TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'Eau/sujet: ',
                style: TextStyle(color: Colors.blue),
              ),
              Text(
                '$eps',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Ratio: '),
              Text(
                '$ratio',
                style: TextStyle(
                    color: colors[ratioColor], fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}
