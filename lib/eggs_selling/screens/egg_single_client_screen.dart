import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/dates_filter.dart';
import '../widgets/drop_down_select.dart';
import 'package:image_picker/image_picker.dart';

class EggClientDetailScreen extends StatefulWidget {
  const EggClientDetailScreen({super.key});
  static const routeName = "egg-client-details";

  @override
  State<EggClientDetailScreen> createState() => _EggClientDetailScreenState();
}

class _EggClientDetailScreenState extends State<EggClientDetailScreen> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        backgroundColor: const Color(0xFF145da0),
        title: const Text(
          "LEMGHARI",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // showModalBottomSheet(
              //     context: context,
              //     builder: (context) {
              //       return OperationsFilter(
              //         clientsOptions: null,
              //         clientGetter: null,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            Container(
              height: 70,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: const Color(0xFF145da0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Solde = paiement - ventes",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "solde: 1200000".toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF145da0)),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: CupertinoSegmentedControl(
                padding: EdgeInsets.zero,
                children: {
                  0: Text('Transactions'),
                  1: Text('Ventes'),
                  2: Text('Encaissements'),
                },
                groupValue: selectedPage,
                onValueChanged: (value) {
                  setState(() {
                    selectedPage = value as int;
                  });
                },
              ),
            ),
            for (int i = 0; i <= 20; i++) PaymentListItem(isIn: i % 2 == 0 ? true : false),
            SizedBox(height: 90),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: AddPayment(),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final bool isIn;
  const PaymentListItem({super.key, required this.isIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text("27/10/2023")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isIn
                    ? Text(
                        "+120 000",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightGreen),
                      )
                    : Text(
                        "-120 000",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                SizedBox(
                  width: 20,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: AddPayment(id: 9),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddPayment extends StatefulWidget {
  final int? id;
  const AddPayment({super.key, this.id});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
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

  List<SelectOption> paymentMethod = [
    SelectOption(id: 0, value: "Chéque"),
    SelectOption(id: 1, value: "Chéque"),
    SelectOption(id: 2, value: "Traite bancaire"),
    SelectOption(id: 3, value: "Versement déplacé"),
    SelectOption(id: 4, value: "Virement"),
  ];

  void payMethodGetter() {}

  // File? image;
  // Future pickImage() async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     setState(() => this.image = imageTemp);
  //   } catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }
  bool img = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 6),
              Text(
                widget.id == null ? "Nouveau payment" : "Modifier 23/12/2023 payment",
                style: TextStyle(color: const Color(0xFF145da0), fontSize: 16),
              ),
              SizedBox(height: 15),
              OutlinedButton(
                onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: operationDate,
                    mode: CupertinoDatePickerMode.dateAndTime,
                    use24hFormat: true,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() => operationDate = newDate);
                    },
                  ),
                ),
                child: Text(
                  "$operationDate".substring(0, 16),
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 15.0,
                  ),
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                height: 50,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  // controller: quantityController,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Montant encaissé'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 6),
              OperationSelect(
                inputsOptions: paymentMethod,
                name: "Mode de paiement",
                getter: payMethodGetter,
                borderColor: Colors.blue,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      img = !img;
                    });
                  },
                  child: Text("IMAGE")),
              SizedBox(
                height: 100,
                width: 300,
                child: img
                    ? Image(
                        image: AssetImage('assets/images/cheque.jpg'),
                      )
                    : Text("selectioner une image"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
