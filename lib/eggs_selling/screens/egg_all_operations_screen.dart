import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './egg_single_client_screen.dart';
import '../widgets/operation_list_item.dart';
import '../widgets/drop_down_select.dart';
import '../widgets/ios_date_picker.dart';

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
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OperationsFilter(
                      clientsOptions: clientsOptions,
                      clientGetter: clientGetter,
                    );
                  });
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

class OperationsFilter extends StatefulWidget {
  final List<SelectOption>? clientsOptions;
  final Function? clientGetter;
  const OperationsFilter({super.key, required this.clientsOptions, required this.clientGetter});

  @override
  State<OperationsFilter> createState() => _OperationsFilterState();
}

class _OperationsFilterState extends State<OperationsFilter> {
  DateTime operationDate = DateTime.now();
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 6, right: 6, top: 12),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            if (widget.clientsOptions != null)
              OperationSelect(
                inputsOptions: widget.clientsOptions ?? [],
                name: "Clients",
                getter: widget.clientGetter ?? () {},
                borderColor: Colors.orange,
              ),
            DatePickerItem(
              children: <Widget>[
                const Text('Date'),
                CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: operationDate,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => operationDate = newDate);
                      },
                    ),
                  ),
                  child: Text(
                    '${operationDate.day}/${operationDate.month}/${operationDate.year}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "séléctioner une plage",
              ),
            ),
            SizedBox(height: 3),
            DatePickerItem(
              children: <Widget>[
                const Text('De'),
                CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: start_date,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => start_date = newDate);
                      },
                    ),
                  ),
                  child: Text(
                    '${start_date.day}/${start_date.month}/${start_date.year}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            DatePickerItem(
              children: <Widget>[
                const Text('à'),
                CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: end_date,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => end_date = newDate);
                      },
                    ),
                  ),
                  child: Text(
                    '${end_date.day}/${end_date.month}/${end_date.year}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 90,
              child: OutlinedButton(
                onPressed: () {},
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.orange,
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.orange.shade800,
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
