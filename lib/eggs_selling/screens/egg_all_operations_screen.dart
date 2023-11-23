import 'package:flutter/material.dart';
import './egg_single_client_screen.dart';
import '../widgets/operation_list_item.dart';
import '../widgets/drop_down_select.dart';
import '../widgets/dates_filter.dart';

class EggAllOperations extends StatefulWidget {
  const EggAllOperations({super.key});
  static const routeName = "egg-opérations/";

  @override
  State<EggAllOperations> createState() => _EggAllOperationsState();
}

class _EggAllOperationsState extends State<EggAllOperations> {
  List<SelectOption> clientsOptions = [
    SelectOption(id: 0, value: "Client1"),
    SelectOption(id: 1, value: "Client2"),
  ];
  void clientGetter(value) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        title: const Text(
          "Opérations",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // showModalBottomSheet(
              //     context: context,
              //     builder: (context) {
              //       return OperationsFilter(
              //         clientsOptions: clientsOptions,
              //         clientGetter: clientGetter,
              //       );
              //     });
            },
            icon: const Icon(
              Icons.tune,
              size: 24,
            ),
            color: Colors.white,
          ),
        ],
        backgroundColor: Color(0xFF145da0),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          children: [
            OperationListOneItem(batiment: "T1", name: "AZIZ", date: "09/11/2023", id: 0, operType: 0, pu: "0.95", qty: 90000),
            OperationListOneItem(batiment: "T1", name: "T1", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 90000),
            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 2, pu: "0.95", qty: 90000),
            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 3, pu: "0.95", qty: 90000),
            OperationListOneItem(batiment: "T1", name: "T2", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 100000),
            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 4, pu: "0.95", qty: 90000),
            OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 0, pu: "0.95", qty: 90000),
          ],
        ),
      )),
    );
  }
}

class ClientListItem extends StatelessWidget {
  const ClientListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 6),
        height: 70,
        width: double.infinity,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(EggClientDetailScreen.routeName);
          },
          child: ListTile(
            leading: Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.blue,
            ),
            title: Text("Ahmed Errajaai"),
            subtitle: Text("10/12/2023 (T1)"),
          ),
        ));
  }
}

