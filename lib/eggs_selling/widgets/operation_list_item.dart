import 'package:flutter/material.dart';
import '../screens/operation_details.dart';
import '../widgets/drop_down_select.dart';

class OperationListOneItem extends StatelessWidget {
  final int id;
  final String date;
  final int operType;
  final String? name;
  final double? pu;
  final int? qty;
  final String batiment;
  const OperationListOneItem({
    super.key,
    required this.id,
    required this.date,
    required this.operType,
    required this.name,
    required this.pu,
    required this.qty,
    required this.batiment,
  });

  @override
  Widget build(BuildContext context) {
    List<SelectOption> operationOptions = [
      SelectOption(id: 0, value: "Vente"),
      SelectOption(id: 1, value: "Entrée"),
      SelectOption(id: 2, value: "Gratuit"),
      SelectOption(id: 3, value: "Accident"),
      SelectOption(id: 4, value: "Change"),
    ];
    List<Color> operationColor = [
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.red,
      Colors.orange
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(OperationDetailsScreen.routeName, arguments: {
            'operation_id': id,
          });
        },
        leading: Chip(
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: operationColor[operationOptions[operType].id],
            label: Icon(
              operationOptions[operType].id == 1 ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: Colors.white,
            )),
        title: Text(
          "${operationOptions[operType].value} ($batiment)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(name ?? ""),
            operationOptions[operType].id == 0 ? Text("$pu X $qty") : Text("Quantité: $qty")
          ],
        ),
      ),
    );
  }
}
