import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';

class EggStockScreen extends StatefulWidget {
  const EggStockScreen({super.key});
  static const routeName = "egg-stock-screen/";

  @override
  State<EggStockScreen> createState() => _EggStockScreenState();
}

class _EggStockScreenState extends State<EggStockScreen> {
  DateTime stockDate = DateTime.now();

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
      getStockStatus();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getStockStatus() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<StockProvider>(context, listen: false).fetchStockData().then((_) {
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
    final deviceSize = MediaQuery.of(context).size;
    final stocks = Provider.of<StockProvider>(context).stocks;
    final globalStock = stocks.where((element) => element.bat == null).last;
    final batsStock = stocks.where((element) => element.bat != null);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "STOCK",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? requestFailed
              ? Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextButton(
                            onPressed: () {
                              getStockStatus();
                            },
                            child: Text("Tap to refresh"))),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(6),
                        minHeight: deviceSize.height * 0.23,
                      ),
                    ),
                  ],
                )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      // height: deviceSize.height * 0.23,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                MdiIcons.weatherNight,
                                color: Colors.blue.shade800,
                                size: 22,
                              ),
                              Text(
                                "${globalStock.total}",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                              ),
                            ]),
                            SizedBox(height: 30),
                            StockClassList(globalStock: globalStock),
                          ],
                        ),
                      ),
                    ),
                    Column(
                        children: batsStock.map((batStock) {
                      return StockByBat(stock: batStock);
                    }).toList()),
                    SizedBox(height: 10)
                  ],
                ),
              ),
            ),
    );
  }
}

class StockClassList extends StatelessWidget {
  final Stock globalStock;
  const StockClassList({super.key, required this.globalStock});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Normaux",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.normaux}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Double jaune",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.dj}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Congelés",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.congeles}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Cassés",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.casse}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Blancs",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.blancs}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Fêlés",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.feles}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Sale",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("${globalStock.sale}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class StockByBat extends StatefulWidget {
  final Stock stock;
  const StockByBat({super.key, required this.stock});

  @override
  State<StockByBat> createState() => _StockByBatState();
}

class _StockByBatState extends State<StockByBat> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.stock.bat ?? "",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.settings,
                          size: 20,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Normaux",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.normaux}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Double jaune",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.dj}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Congelés (Kg)",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.congeles}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Cassés",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.casse}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Blancs",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.blancs}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Fêlés",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.feles}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Sale",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("${widget.stock.sale}", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
