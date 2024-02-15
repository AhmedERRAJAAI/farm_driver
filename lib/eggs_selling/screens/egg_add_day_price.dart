import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import '../providers/daily_price_provider.dart';

import '../widgets/ios_date_picker.dart';

class EggDayPrice extends StatefulWidget {
  const EggDayPrice({super.key});
  static const routeName = "egg-day-price/";

  @override
  State<EggDayPrice> createState() => _EggDayPriceState();
}

class _EggDayPriceState extends State<EggDayPrice> {
  String? filterFisrtDate;
  String? filterLastDate;
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
      getDaysPrices();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getDaysPrices() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EggPrice>(context, listen: false).fetchDailyPrices(100, filterFisrtDate, filterLastDate).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
          filterFisrtDate = null;
          filterLastDate = null;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
      });
    }
  }

  void forwardDailyPrice(double price, DateTime date) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EggPrice>(context, listen: false).sendDailyPrice(price, date).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
        // errorAlert("Echéc de récupérer les clients et les bâtiments", "vérifiez la connexion Internet et réessayez");
      });
    }
  }

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
    });
    getDaysPrices();
  }

  @override
  Widget build(BuildContext context) {
    final dailyPrice = Provider.of<EggPrice>(context);
    final dailyPriceRecords = dailyPrice.daysPrices;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamed("/"),
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
        backgroundColor: const Color(0xFF145da0),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     showModalBottomSheet(
          //         context: context,
          //         builder: (context) {
          //           return OperationsFilter(
          //             clientsOptions: null,
          //             clientGetter: null,
          //             clearFilter: clearFilter,
          //             firstDateGetter: filterFirstDateGetter,
          //             lastDateGetter: filterLastDateGetter,
          //             submitter: getDaysPrices,
          //           );
          //         });
          //   },
          //   icon: const Icon(
          //     Icons.tune,
          //     size: 24,
          //   ),
          //   color: Colors.white,
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: deviceSize.height * 0.26,
                padding: const EdgeInsets.all(4),
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
                          decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Prix unitaire (DH)'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                                  setState(() {
                                    operationDate = newDate;
                                  });
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
                          onPressed: () {
                            forwardDailyPrice(double.parse(priceContoller.text), operationDate);
                            priceContoller.clear();
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
              isLoading ? LinearProgressIndicator() : SizedBox(),
              SizedBox(height: 15),
              Container(
                height: deviceSize.height * 0.6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: ListView.builder(
                    itemCount: dailyPriceRecords.length,
                    itemBuilder: ((context, i) => DayPriceListItem(
                          id: dailyPriceRecords[i].id,
                          price: dailyPriceRecords[i].price,
                          date: dailyPriceRecords[i].date,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DayPriceListItem extends StatefulWidget {
  final double price;
  final DateTime? date;
  final int id;
  const DayPriceListItem({super.key, required this.price, required this.date, required this.id});

  @override
  State<DayPriceListItem> createState() => _DayPriceListItemState();
}

class _DayPriceListItemState extends State<DayPriceListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ModifyDailyPrice(
                    operDate: widget.date ?? DateTime.now(),
                    price: widget.price,
                    id: widget.id,
                  ));
            });
      },
      child: Container(
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
              Text("${widget.price}"),
              Text("${widget.date?.day}/${widget.date?.month}/${widget.date?.year}")
            ],
          )),
    );
  }
}

class ModifyDailyPrice extends StatefulWidget {
  final double price;
  final DateTime operDate;
  final int id;
  const ModifyDailyPrice({super.key, required this.price, required this.operDate, required this.id});

  @override
  State<ModifyDailyPrice> createState() => _ModifyDailyPriceState();
}

class _ModifyDailyPriceState extends State<ModifyDailyPrice> {
  bool isLoading = false;
  bool requestFailed = false;
  double priceHolder = 0;

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

  void modifyDailyPrice(double price, DateTime date, int id) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EggPrice>(context, listen: false).modifyDailyPrice(price, date, id).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController priceContoller = TextEditingController(text: "${widget.price}");
    DateTime operationDate = widget.operDate;
    return Padding(
      padding: EdgeInsets.only(left: 6, right: 6, top: 12),
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: priceContoller,
                // initialValue: "${widget.price}",
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
                      initialDateTime: widget.operDate,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          operationDate = newDate;
                        });
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () {
                      modifyDailyPrice(double.parse(priceContoller.text), operationDate, widget.id);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Modifié"),
                          backgroundColor: Colors.lightGreen,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      "Modifier",
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
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 120,
                  height: 35,
                  child: OutlinedButton(
                    onPressed: () {
                      Provider.of<EggPrice>(context, listen: false).deleteDailyPrice(widget.id);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Supprimé"),
                          backgroundColor: Colors.lightGreen,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 85, 0),
                      ),
                      side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(
                          color: Colors.orange.shade800,
                          width: 1.0,
                        ),
                      ),
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
