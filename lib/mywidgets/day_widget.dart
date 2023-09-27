import 'package:flutter/material.dart';

class DayWidget extends StatelessWidget {
  final List days;
  const DayWidget({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    print(days);
    return const Text("test");
    //   return Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
    //     margin: const EdgeInsets.symmetric(horizontal: 6),
    //     decoration: BoxDecoration(
    //       border: Border(
    //         bottom: BorderSide(color: Colors.grey.shade200, width: 1),
    //       ),
    //     ),
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //           flex: 8,
    //           child: Row(
    //             children: [
    //               FittedBox(
    //                 fit: BoxFit.scaleDown,
    //                 child: Text(
    //                   "$day | $date",
    //                   style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
    //                 ),
    //               ),
    //               Text(
    //                 unity != null ? '($unity)' : "",
    //                 style: TextStyle(color: Colors.grey.shade800, fontSize: 10),
    //               ),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           flex: 10,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 reel.toString(),
    //                 style: TextStyle(
    //                     color: Colors.grey.shade800,
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 14),
    //               ),
    //               EcartChip(
    //                 colorName: color,
    //                 directionIndex: isUp ?? 1,
    //                 ecart: ecart ?? 0,
    //               ),
    //             ],
    //           ),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               guide != null ? guide.toString() : '-',
    //               style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   );
  }
}
