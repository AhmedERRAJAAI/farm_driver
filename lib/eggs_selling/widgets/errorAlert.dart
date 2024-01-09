import 'package:flutter/material.dart';
import 'dart:io';
import '../../urls.dart';

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

void imageViewModal(File? img, context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: img != null
          ? Image.file(
              img,
              fit: BoxFit.fill,
            )
          : null,
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

void networkImgDisplay(String? img, context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      content: img != null ? Image.network(Urls.url + img) : null,
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
