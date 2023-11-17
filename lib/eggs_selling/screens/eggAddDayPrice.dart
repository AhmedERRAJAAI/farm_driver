import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/ios_date_picker.dart';
import './egg_all_operations_screen.dart';

class EggDayPrice extends StatefulWidget {
  const EggDayPrice({super.key});
  static const routeName = "egg-day-price/";

  @override
  State<EggDayPrice> createState() => _EggDayPriceState();
}

class _EggDayPriceState extends State<EggDayPrice> {
  final TextEditingController priceContoller = TextEditingController();
  DateTime operationDate = DateTime.now();

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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        title: const Text(
          "Prix du jour",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        backgroundColor: Color(0xFF145da0),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OperationsFilter(
                      clientsOptions: null,
                      clientGetter: null,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: deviceSize.height * 0.26,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(border: Border.all(color: const Color(0xFF145da0)), borderRadius: BorderRadius.circular(4)),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: priceContoller,
                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Prix unitaire (DH)'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 6),
                      DatePickerItem(
                        children: <Widget>[
                          const Text(
                            "Date",
                            style: TextStyle(fontSize: 15),
                          ),
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
                      SizedBox(height: 20),
                      SizedBox(
                        width: 130,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            "Enregistrer",
                            style: TextStyle(color: Colors.white),
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
              ),
              SizedBox(height: 15),
              Container(
                height: deviceSize.height * 0.6,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    children: [
                      for (int i = 0; i <= 10; i++) DayPriceListItem(),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayPriceListItem extends StatelessWidget {
  const DayPriceListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 6),
        height: 30,
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        )),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("1.20 DH"),
            Text("12/12/2023")
          ],
        ));
  }
}
