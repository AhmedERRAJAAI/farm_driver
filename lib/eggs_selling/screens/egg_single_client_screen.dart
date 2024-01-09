import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import '../widgets/dates_filter.dart';
import '../widgets/drop_down_select.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../widgets/errorAlert.dart';

class EggClientDetailScreen extends StatefulWidget {
  const EggClientDetailScreen({super.key});
  static const routeName = "egg-client-details";

  @override
  State<EggClientDetailScreen> createState() => _EggClientDetailScreenState();
}

class _EggClientDetailScreenState extends State<EggClientDetailScreen> {
  int selectedPage = 0;

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
      getClients(100);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getClients(count) async {
    final clientObj = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<PaymentProvider>(context, listen: false).fetchClientInOuts(count: count, client: clientObj['id']).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
        alertMsg("Echéc de recupérer les données", "vérifiez la connexion Internet et réessayez", context);
      });
    }
  }

  void forwardPayment(File? selectedImage, data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<PaymentProvider>(context, listen: false).sendPaymentData(selectedImage, data).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
        getClients(100);
        Navigator.of(context).pop();
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
        alertMsg("Echéc d'envoyer les données de cette paiement", "vérifiez la connexion Internet et réessayez", context);
      });
    }
  }

  String? filterFisrtDate;
  String? filterLastDate;
  void filterFirstDateGetter(String date) {
    setState(() {
      filterFisrtDate = date;
    });
  }

  void filterLastDateGetter(String date) {
    setState(() {
      filterLastDate = date;
    });
  }

  void clearFilter() {
    setState(() {
      filterFisrtDate = null;
      filterLastDate = null;
      getClients(100);
    });
  }

  List<Transaction> instTrans = [];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final clientObj = ModalRoute.of(context)!.settings.arguments as Map;
    final transactionInst = Provider.of<PaymentProvider>(context);
    List<Transaction> transactions = transactionInst.clientTransactions;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        backgroundColor: const Color(0xFF145da0),
        title: Text(
          "${clientObj['name']}",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OperationsFilter(
                      clientsOptions: null,
                      clientGetter: null,
                      clearFilter: clearFilter,
                      firstDateGetter: filterFirstDateGetter,
                      lastDateGetter: filterLastDateGetter,
                      submitter: getClients,
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
      body: SingleChildScrollView(
        child: requestFailed
            ? Center(
                child: Column(children: [
                  Text("Echec de charger les données"),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      getClients(100);
                    },
                    child: Text("Actualiser"),
                  )
                ]),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(children: [
                  SizedBox(height: 5),
                  isLoading
                      ? SizedBox(
                          width: double.infinity,
                          child: LinearProgressIndicator(
                            minHeight: deviceSize.height * 0.11,
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blue.shade400,
                            backgroundColor: Colors.blue.shade200,
                          ),
                        )
                      : Container(
                          height: deviceSize.height * 0.11,
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
                                "Solde  :  ${transactionInst.solde} Dh",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: transactionInst.solde >= 0 ? Colors.green : Colors.deepOrange),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 5),
                  Container(
                    height: deviceSize.height * 0.05,
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
                          if (value == 0) {
                            transactions = transactionInst.clientTransactions;
                          } else if (value == 1) {
                            transactions = transactionInst.clientTransactions.where((trans) => trans.isPayed == null).toList();
                            instTrans = transactions;
                          }
                          if (value == 2) {
                            transactions = transactionInst.clientTransactions.where((trans) => trans.isPayed != null).toList();
                            instTrans = transactions;
                          }
                          selectedPage = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.83,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: selectedPage == 0 ? transactions.length : instTrans.length,
                        itemBuilder: ((context, i) {
                          return PaymentListItem(
                            isPayment: selectedPage == 0 ? true : false,
                            clientId: clientObj['id'],
                            clientTrans: selectedPage == 0 ? transactions[i] : instTrans[i],
                          );
                        })),
                  )
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
                  child: AddPayment(clientId: clientObj['id'], submitter: forwardPayment),
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PaymentListItem extends StatelessWidget {
  final int clientId;
  final Transaction clientTrans;
  final bool isPayment;
  const PaymentListItem({super.key, required this.clientId, required this.clientTrans, required this.isPayment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (clientTrans.img_url == null) return;
        networkImgDisplay(clientTrans.img_url ?? "", context);
      },
      child: Container(
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
              Expanded(child: Text(clientTrans.date)),
              Text(
                clientTrans.isPayed == null ? "-${clientTrans.amount}" : "+${clientTrans.amount}",
                style: TextStyle(fontWeight: FontWeight.bold, color: clientTrans.isPayed == null ? Colors.deepOrange : Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddPayment extends StatefulWidget {
  final int? id;
  final int clientId;
  final Function submitter;
  const AddPayment({super.key, this.id, required this.clientId, required this.submitter});

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  File? _selectedImage;
  Future _pickImage() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImg == null) {
      return;
    }
    setState(() {
      _selectedImage = File(returnedImg.path);
    });
  }

  Future _takeImage() async {
    final returnedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImg == null) {
      return;
    }
    setState(() {
      _selectedImage = File(returnedImg.path);
    });
  }

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

  final TextEditingController amountContoller = TextEditingController();
  bool isPayed = true;
  int? payMode;
  List<SelectOption> paymentMethod = [
    SelectOption(id: 0, value: "Éspéce"),
    SelectOption(id: 1, value: "Chéque"),
    SelectOption(id: 2, value: "Traite bancaire"),
    SelectOption(id: 3, value: "Versement déplacé"),
    SelectOption(id: 4, value: "Virement"),
  ];
  void payMethodGetter(int value) {
    setState(() {
      payMode = value;
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.blue;
  }

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
                "Nouveau paiement",
                style: TextStyle(color: const Color(0xFF145da0), fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: operationDate,
                      maximumDate: DateTime.now(),
                      mode: CupertinoDatePickerMode.dateAndTime,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => operationDate = newDate);
                      },
                    ),
                  ),
                  child: Text(
                    "$operationDate",
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                height: 50,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: amountContoller,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Montant encaissé'),
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
                inputsOptions: paymentMethod,
                name: "Mode de paiement",
                getter: payMethodGetter,
                borderColor: Colors.blue,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      isPayed = !isPayed;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Payé"),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: isPayed,
                        onChanged: (bool? value) {
                          setState(() {
                            isPayed = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              (payMode == 1 || payMode == 2)
                  ? SizedBox(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Importer des images"),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _pickImage();
                                },
                                child: Icon(
                                  Icons.publish,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _takeImage();
                                },
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.amber)),
                          height: 100,
                          width: double.infinity,
                          child: Center(
                            child: _selectedImage != null
                                ? GestureDetector(
                                    onTap: () {
                                      imageViewModal(_selectedImage, context);
                                    },
                                    child: Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                : Text("selectioner une image"),
                          ),
                        )
                      ],
                    ))
                  : SizedBox(),
              SizedBox(height: 20),
              SizedBox(
                width: 130,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {
                    widget.submitter(
                      _selectedImage,
                      {
                        "date": operationDate.toString(),
                        "amount": amountContoller.text,
                        "client": widget.clientId,
                        "payMode": payMode,
                        "isPayed": isPayed,
                      },
                    );
                  },
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
    );
  }
}
