
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../providers/mouvements_provider.dart';
import '../../widgets/drop_down_select.dart';
import '../../widgets/ios_date_picker.dart';
import '../../constants.dart';
import '../../widgets/errorAlert.dart';


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
      padding: widget.id == null ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: entreeForm,
        child: Column(
          children: [
            DatePickerItem(
              children: <Widget>[
                const Text("date d'opération"),
                CupertinoButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      cancelText: 'Annuler',
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2100),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      locale: const Locale("fr"),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child ?? const Text(''),
                        );
                      },
                    ).then((value) {
                      setState(() => operationDate = value ?? DateTime.now());
                    });
                  },
                  child: Text(
                    "${operationDate.day}/${operationDate.month}/${operationDate.year}",
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
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 3),
                        content: const Text('Données envoyées'),
                      ),
                    );
                    entreeForm.currentState!.reset();
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


