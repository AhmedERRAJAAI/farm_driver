import 'package:flutter/material.dart';

class EventItem extends StatefulWidget {
  const EventItem({super.key});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  double _containerHeight = 50;
  void heightChanger(height) {
    setState(() {
      _containerHeight = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: GestureDetector(
      onTap: () {
        heightChanger(200);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _containerHeight,
        curve: Curves.easeIn,
        color: Colors.red,
      ),
    ));
  }
}
