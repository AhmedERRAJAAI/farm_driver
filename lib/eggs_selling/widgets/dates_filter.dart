import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './drop_down_select.dart';
import './ios_date_picker.dart';

class OperationsFilter extends StatefulWidget {
  final List<SelectOption>? clientsOptions;
  final Function? clientGetter;
  final Function firstDateGetter;
  final Function lastDateGetter;
  final Function clearFilter;
  final Function submitter;
  const OperationsFilter({
    super.key,
    required this.clientsOptions,
    required this.clientGetter,
    required this.firstDateGetter,
    required this.lastDateGetter,
    required this.clearFilter,
    required this.submitter,
  });

  @override
  State<OperationsFilter> createState() => _OperationsFilterState();
}

class _OperationsFilterState extends State<OperationsFilter> {
  TextEditingController dateInput = TextEditingController();
  DateTime operationDate = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.clearFilter();
                    },
                    child: Text("supprimer le filtre")),
                TextButton(
                    onPressed: () {
                      setState(() {
                        widget.lastDateGetter("${endDate.year}-${endDate.month}-${endDate.day}");
                        widget.firstDateGetter("${startDate.year}-${startDate.month}-${startDate.day}");
                      });
                      widget.submitter();
                      Navigator.of(context).pop();
                    },
                    child: Text("Effectuer")),
              ],
            ),
            SizedBox(height: 10),
            if (widget.clientsOptions != null)
              OperationSelect(
                inputsOptions: widget.clientsOptions ?? [],
                name: "Clients",
                getter: widget.clientGetter ?? () {},
                borderColor: Colors.orange,
              ),
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
                      initialDateTime: startDate,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          startDate = newDate;
                        });
                      },
                    ),
                  ),
                  child: Text(
                    '${startDate.day}/${startDate.month}/${startDate.year}',
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
                      initialDateTime: endDate,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          endDate = newDate;
                        });
                      },
                    ),
                  ),
                  child: Text(
                    '${endDate.day}/${endDate.month}/${endDate.year}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
