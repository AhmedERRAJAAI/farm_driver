import 'package:flutter/material.dart';

import '../screens/edit_products_screen.dart';

class UserProductWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteHandler;

  const UserProductWidget(
      {super.key, required this.deleteHandler,
      required this.id,
      required this.title,
      required this.imageUrl});

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  editProductPage(BuildContext ctx, productId) {
    Navigator.of(ctx)
        .pushNamed(EditProductScreen.routeName, arguments: productId);
  }

  // Future<Future> _showDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Deleting'),
  //         content: const Text('Are you sure'),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(true); // Close the dialog
  //             },
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(
  //                 color: Colors.red,
  //               ),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(false); // Close the dialog
  //             },
  //             child: const Text('cancel'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              onPressed: () {
                editProductPage(context, id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {
                deleteHandler(id);
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
