import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';
import '../widgets/drop_down_select.dart';
import '../widgets/ios_date_picker.dart';
import './eggs_records_screen.dart';
import '../constants.dart';
import '../widgets/errorAlert.dart';

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
          onPressed: () => Navigator.of(context).pushNamed("egg-dashboard/"),
        ),
        title: isEntree == 1
            ? const Text(
                "Entrée",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              )
            : const Text(
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
  final entreeForm = GlobalKey<FormState>();
  bool isLoading = false;
  bool requestFailed = false;
  bool _isInit = true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getClients();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchFormClients().then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
        errorAlert("Echéc de récupérer les bâtiments", "vérifiez la connexion Internet et réessayez");
      });
    }
  }

  void errorAlert(String title, String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.normal,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Réessayer',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            onPressed: () {
              getClients();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

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

  final TextEditingController quantityController = TextEditingController();
  DateTime operationDate = DateTime.now();
  int? batimentId;
  int? eggClass;
  void batGetter(value) {
    setState(() {
      batimentId = value;
    });
  }

  void classGetter(value) {
    setState(() {
      eggClass = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<SelectOption> batsOptions = [];
    final mouvement = Provider.of<MouvementProvider>(context);
    for (var bat in mouvement.batiments) {
      batsOptions.add(
        SelectOption(
          id: bat.id,
          value: bat.name.toUpperCase(),
        ),
      );
    }
    return Container(
      height: widget.id == null ? null : 500,
      padding: widget.id == null ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: entreeForm,
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
                    "$operationDate".substring(0, 16),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champs requis";
                  }
                  return null;
                },
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
            isLoading
                ? LinearProgressIndicator(
                    minHeight: 50,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade400,
                    backgroundColor: Colors.grey.shade200,
                  )
                : OperationSelect(
                    inputsOptions: batsOptions,
                    name: "Batiment",
                    getter: batGetter,
                    borderColor: Colors.green,
                  ),
            SizedBox(height: 6),
            SizedBox(
              width: 170,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                  if (batimentId == null || eggClass == null) {
                    alertMsg("Champs requis:", "Bâatiment, Classe des oeufs", context);
                  }
                  if (entreeForm.currentState!.validate()) {
                    mouvement.sendEntreeData({
                      "date": "$operationDate",
                      "qty": quantityController.text,
                      "eggsClass": eggClass,
                      "batiment": batimentId,
                    });
                  }
                },
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
  final sortieForm = GlobalKey<FormState>();
  bool isLoading = false;
  bool requestFailed = false;
  bool _isInit = true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getClients();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchFormClients().then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
        errorAlert("Echéc de récupérer les clients et les bâtiments", "vérifiez la connexion Internet et réessayez");
      });
    }
  }

  int selectedLetter = 0;

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

  final TextEditingController remarqueController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController immNbrController = TextEditingController();
  final TextEditingController immLetterController = TextEditingController();
  final TextEditingController immCityController = TextEditingController();
  final TextEditingController driverfNameController = TextEditingController();
  final TextEditingController driverlNameController = TextEditingController();
  final TextEditingController driverCinController = TextEditingController();
  DateTime operationDate = DateTime.now();
  int? operId;
  int? clientId;
  int? classId;
  int? batimentId;

  void operGetter(value) {
    setState(() {
      operId = value;
    });
  }

  void clientGetter(value) {
    setState(() {
      clientId = value;
    });
  }

  void classGetter(value) {
    setState(() {
      classId = value;
    });
  }

  void batimentGetter(value) {
    setState(() {
      batimentId = value;
    });
  }

  void errorAlert(String title, String text) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontStyle: FontStyle.normal,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Réessayer',
              style: TextStyle(fontSize: 14, color: Colors.orange),
            ),
            onPressed: () {
              getClients();
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SelectOption> clientsOptions = [];
    List<SelectOption> batsOptions = [];
    final mouvement = Provider.of<MouvementProvider>(context);
    for (var client in mouvement.formClients) {
      clientsOptions.add(
        SelectOption(
          id: client.id,
          value: "${client.firstName} ${client.lastName}".toUpperCase(),
        ),
      );
    }
    for (var bat in mouvement.batiments) {
      batsOptions.add(
        SelectOption(
          id: bat.id,
          value: bat.name.toUpperCase(),
        ),
      );
    }
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: widget.id == null ? null : 550,
      padding: widget.id == null ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: sortieForm,
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
                    "$operationDate".substring(0, 16),
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
              name: "Opération",
              getter: operGetter,
              borderColor: Colors.blue,
            ),
            SizedBox(height: 6),
            isLoading
                ? LinearProgressIndicator(
                    minHeight: 50,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade400,
                    backgroundColor: Colors.grey.shade200,
                  )
                : OperationSelect(
                    inputsOptions: batsOptions,
                    name: "Bâtiment",
                    getter: batimentGetter,
                    borderColor: Colors.blue,
                  ),
            SizedBox(height: 6),
            isLoading
                ? LinearProgressIndicator(
                    minHeight: 50,
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade400,
                    backgroundColor: Colors.grey.shade200,
                  )
                : operId == 0
                    ? OperationSelect(
                        inputsOptions: clientsOptions,
                        name: "Client",
                        getter: clientGetter,
                        borderColor: Colors.blue,
                      )
                    : SizedBox(
                        height: 50,
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: remarqueController,
                          decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Remarque'),
                          keyboardType: TextInputType.text,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champs requis";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 6),
            OperationSelect(
              inputsOptions: classOptions,
              name: "Classe",
              getter: classGetter,
              borderColor: Colors.blue,
            ),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: unitPriceController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'P.U. (DH)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champs requis";
                  }
                  return null;
                },
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
                      controller: immNbrController,
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
                      controller: immCityController,
                      decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Ville'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Align(alignment: Alignment.centerLeft, child: Text("Transporteur")),
            SizedBox(height: 3),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: deviceSize.width * 0.3,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: driverlNameController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Nom'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.3,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: driverfNameController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Prenom'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: deviceSize.width * 0.3,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: driverCinController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'CIN'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 170,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                  if (batimentId == null || classId == null || clientId == null || operId == null) {
                    alertMsg("Champs requis:", "Bâtiment, Classe des oeufs, Client, Operation", context);
                  }
                  if (sortieForm.currentState!.validate()) {
                    mouvement.sendSortieData(
                      {
                        "date": "$operationDate",
                        "outType": operId,
                        "eggsQty": quantityController.text,
                        "remarque": remarqueController.text.isEmpty ? "" : remarqueController.text,
                        "pu": unitPriceController.text,
                        "immNbr": immNbrController.text,
                        "immLetter": selectedLetter,
                        "immCity": immCityController.text,
                        "batiment": batimentId,
                        "eggsClass": classId,
                        "transfName": driverfNameController.text,
                        "translName": driverlNameController.text,
                        "transCin": driverCinController.text,
                        "client": clientId,
                      },
                    );
                  }
                  ;
                },
                child: Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
