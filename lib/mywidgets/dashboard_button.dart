import 'package:flutter/material.dart';

class DashboardAppButton extends StatelessWidget {
  final double width;
  final double height;
  final Color bgcolor;
  final Icon icon;
  final String title;
  final Function toPage;
  
  DashboardAppButton({
    required this.width,
    required this.height,
    required this.bgcolor,
    required this.icon,
    required this.title,
    required this.toPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Set the width directly on the Container
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: bgcolor,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero, // Remove padding
          backgroundColor: Colors.transparent,
          side: BorderSide.none, // Remove border
        ),
        onPressed: () {
          toPage(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            icon,
            FittedBox(
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF2b2b2b)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
