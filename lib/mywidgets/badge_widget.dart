import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final int count;

  BadgeWidget({required this.child, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: const Alignment(0.6, -0.7),
      children: [
        child,
        if (2 > 0)
          CircleAvatar(
            backgroundColor: count > 0 ? Colors.red : Colors.grey,
            radius: 8,
            child: Text(
              count.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
