import 'package:flutter/material.dart';

class IndiceConvers extends StatelessWidget {
  final double ic_sem;
  final double ic_cuml;
  final int id;

  const IndiceConvers({super.key, 
    required this.ic_cuml,
    required this.ic_sem,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Indice de conversion'),
          Row(
            children: [const Text('Semaine'), Text('$ic_sem')],
          ),
          Row(
            children: [const Text('Cumulé'), Text('$ic_cuml')],
          ),
        ],
      ),
    );
  }
}
