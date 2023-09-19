import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final List columns;

  TableHeader({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: columns.map((column) {
          return Text(
            column,
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500),
          );
        }).toList());
  }
}
