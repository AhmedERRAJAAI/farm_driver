import 'package:flutter/material.dart';

class FetchRefresher extends StatelessWidget {
  final Function refetch;
  final int? paramId;
  final double deviceWidth;
  const FetchRefresher({super.key, required this.refetch, required this.paramId, required this.deviceWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.red, // Border color
          width: 1.6, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(children: [
        const Text("échec de la récupération des données"),
        FittedBox(
          child: TextButton(
              onPressed: () {
                refetch(paramId);
              },
              child: const Text("Actualiser")),
        )
      ]),
    );
  }
}
