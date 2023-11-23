
import 'package:flutter/material.dart';


  void alertMsg(String title, String text, context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.normal,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Fermer',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }