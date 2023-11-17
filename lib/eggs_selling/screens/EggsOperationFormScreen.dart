import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/drop_down_select.dart';
import '../widgets/ios_date_picker.dart';
import './eggs_records_screen.dart';

class EggOperationForm extends StatefulWidget {
  static const routeName = 'operations-types/';
  const EggOperationForm({super.key});

  @override
  State<EggOperationForm> createState() => _EggOperationFormState();
}

class _EggOperationFormState extends State<EggOperationForm> {
  int isEntree = 0;
  Color selectedColor = Colors.blue;
  void toggleForms(int index) {
    setState(() {
      isEntree = index;
      if (index == 0) {
        selectedColor = Colors.blue;
      } else {
        selectedColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: isEntree == 1
            ? Text(
                "Entrée",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              )
            : Text(
                "Sortie",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
        backgroundColor: selectedColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EggMouvementRecords.routeName);
              },
              icon: Icon(
                Icons.read_more,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: isEntree == 1 ? EntreeMovement() : SortieMovement(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_up),
            label: 'Sortie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down),
            label: 'Entree',
          ),
        ],
        currentIndex: isEntree,
        selectedItemColor: selectedColor,
        onTap: toggleForms,
      ),
    );
  }
}

class EntreeMovement extends StatefulWidget {
  final int? id;
  const EntreeMovement({super.key, this.id});

  @override
  State<EntreeMovement> createState() => _EntreeMovementState();
}

class _EntreeMovementState extends State<EntreeMovement> {
  final TextEditingController quantityController = TextEditingController();

  List<SelectOption> classOptions = [
    SelectOption(id: 0, value: "Normaux"),
    SelectOption(id: 1, value: "Double jaune"),
    SelectOption(id: 2, value: "Blancs"),
    SelectOption(id: 4, value: "Cassés"),
    SelectOption(id: 5, value: "Félés"),
    SelectOption(id: 6, value: "Congelés (kg)"),
    SelectOption(id: 7, value: "Éliminés"),
    SelectOption(id: 8, value: "Sale"),
  ];
  List<SelectOption> batimentList = [
    SelectOption(id: 0, value: "T1"),
    SelectOption(id: 1, value: "T2"),
    SelectOption(id: 2, value: "T3"),
    SelectOption(id: 4, value: "T4"),
    SelectOption(id: 5, value: "T5"),
    SelectOption(id: 6, value: "T6"),
    SelectOption(id: 7, value: "T7"),
    SelectOption(id: 8, value: "T8"),
    SelectOption(id: 8, value: "T9"),
  ];

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

  int operId = 0;
  void operGetter(value) {
    setState(() {
      operId = value;
    });
  }

  void clientGetter(value) {}

  void classGetter(value) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.id == null ? null : 500,
      padding: widget.id == null ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        child: Column(
          children: [
            DatePickerItem(
              children: <Widget>[
                const Text("date d'opération"),
                CupertinoButton(
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
                    '${operationDate.day}/${operationDate.month}/${operationDate.year} - ${operationDate.hour}:${operationDate.minute}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: quantityController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Quantité'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 6),
            OperationSelect(
              inputsOptions: classOptions,
              name: "Class",
              getter: classGetter,
              borderColor: Colors.green,
            ),
            SizedBox(height: 6),
            OperationSelect(
              inputsOptions: batimentList,
              name: "Batiment",
              getter: classGetter,
              borderColor: Colors.green,
            ),
            SizedBox(height: 6),
            SizedBox(
              width: 170,
              height: 45,
              child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Enregistrer",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green,
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.green.shade200,
                      width: 2.0,
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

class SortieMovement extends StatefulWidget {
  final int? id;
  const SortieMovement({super.key, this.id});

  @override
  State<SortieMovement> createState() => _SortieMovementState();
}

class _SortieMovementState extends State<SortieMovement> {
  final TextEditingController quantityController = TextEditingController();

  List<SelectOption> operationOptions = [
    SelectOption(id: 0, value: "Vente"),
    SelectOption(id: 2, value: "Gratuit"),
    SelectOption(id: 3, value: "Accident"),
    SelectOption(id: 4, value: "Change"),
  ];
  List<SelectOption> classOptions = [
    SelectOption(id: 0, value: "Normaux"),
    SelectOption(id: 1, value: "Double jaune"),
    SelectOption(id: 2, value: "Blancs"),
    SelectOption(id: 4, value: "Cassés"),
    SelectOption(id: 5, value: "Félés"),
    SelectOption(id: 6, value: "Congelés (Kg)"),
    SelectOption(id: 7, value: "Éliminés"),
    SelectOption(id: 8, value: "Sale"),
  ];
  List<SelectOption> clientsOptions = [
    SelectOption(id: 0, value: "Client1"),
    SelectOption(id: 1, value: "Client2"),
  ];

  List<String> immLetters = <String>[
    'أ',
    'ب',
    'ج',
    'د',
    'ه',
    'و',
    'ز',
    'ح',
    'ط',
    'ي',
    'ك',
    'ل',
    'م',
    'ن',
    'س',
    'ع',
    'ف',
    'ص',
    'ق',
    'ر',
    'ش',
    'ت',
    'ث',
    'خ',
    'ذ',
    'ض',
    'ظ',
    'غ',
  ];
  int selectedLetter = 0;

  DateTime operationDate = DateTime.now();
  DateTime operationTime = DateTime.now();
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

  int operId = 0;
  void operGetter(value) {
    setState(() {
      operId = value;
    });
  }

  void clientGetter(value) {}

  void classGetter(value) {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: widget.id == null ? null : 550,
      padding: widget.id == null ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        child: Column(
          children: [
            DatePickerItem(
              children: <Widget>[
                const Text("date d'opération"),
                CupertinoButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      maximumDate: DateTime.now(),
                      initialDateTime: operationDate,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => operationDate = newDate);
                      },
                    ),
                  ),
                  child: Text(
                    '${operationDate.day}/${operationDate.month}/${operationDate.year} - ${operationDate.hour}:${operationDate.minute}',
                    style: const TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            OperationSelect(
              inputsOptions: operationOptions,
              name: "Opérations",
              getter: operGetter,
              borderColor: Colors.blue,
            ),
            SizedBox(height: 6),
            operId == 0
                ? OperationSelect(
                    inputsOptions: clientsOptions,
                    name: "Clients",
                    getter: clientGetter,
                    borderColor: Colors.blue,
                  )
                : SizedBox(
                    height: 50,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: quantityController,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Remarque'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: quantityController,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Quantité'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 6),
            OperationSelect(
              inputsOptions: classOptions,
              name: "Class",
              getter: classGetter,
              borderColor: Colors.blue,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'P.U. (DH)'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 8),
            Align(alignment: Alignment.centerLeft, child: Text("Immatriculation")),
            SizedBox(height: 3),
            SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.4,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: quantityController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Immatricule'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: deviceSize.width * 0.2,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () => _showDialog(
                      CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32,
                        // This sets the initial item.
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedLetter,
                        ),
                        // This is called when selected item is changed.
                        onSelectedItemChanged: (int selectedItem) {
                          setState(() {
                            selectedLetter = selectedItem;
                          });
                        },
                        children: List<Widget>.generate(immLetters.length, (int index) {
                          return Center(child: Text(immLetters[index]));
                        }),
                      ),
                    ),
                    // This displays the selected fruit name.
                    child: Text(
                      immLetters[selectedLetter],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: deviceSize.width * 0.2,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: quantityController,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Ville'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            )),
            SizedBox(height: 10),
            SizedBox(
              width: 170,
              height: 45,
              child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Enregistrer",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue,
                  ),
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide(
                      color: Colors.blue.shade200,
                      width: 2.0,
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
