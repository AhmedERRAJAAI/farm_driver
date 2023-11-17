import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EggStockScreen extends StatefulWidget {
  const EggStockScreen({super.key});
  static const routeName = "egg-stock-screen/";

  @override
  State<EggStockScreen> createState() => _EggStockScreenState();
}

class _EggStockScreenState extends State<EggStockScreen> {
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

  DateTime stockDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Text(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 200,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(
                                  MdiIcons.weatherSunny,
                                  color: Colors.yellow.shade700,
                                  size: 25,
                                ),
                                Text(
                                  "120993849",
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow.shade700),
                                ),
                              ]),
                              Row(children: [
                                Icon(
                                  MdiIcons.weatherNight,
                                  color: Colors.blue.shade800,
                                  size: 22,
                                ),
                                Text(
                                  "120993849",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                ),
                              ]),
                            ],
                          ),
                          FittedBox(
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange,
                              ),
                              child: Center(
                                child: TextButton(
                                  onPressed: () => _showDialog(
                                    CupertinoDatePicker(
                                      initialDateTime: stockDate,
                                      mode: CupertinoDatePickerMode.date,
                                      use24hFormat: true,
                                      onDateTimeChanged: (DateTime newDate) {
                                        setState(() => stockDate = newDate);
                                      },
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${stockDate.day}/${stockDate.month}/${stockDate.year}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        backgroundColor: Colors.orange,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      StockClassList(),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  StockByBat(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StockClassList extends StatelessWidget {
  const StockClassList({super.key});

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
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Double jaune",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Congelés",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
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
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Blancs",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Fêlés",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class StockByBat extends StatefulWidget {
  const StockByBat({super.key});

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
                      "T1",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: ModifyStock(),
                                );
                              });
                        },
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
                      Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Double jaune",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Congelés (Kg)",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("12", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
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
                      Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Blancs",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Fêlés",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                      ),
                      Text("120000", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14))
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class ModifyStock extends StatefulWidget {
  const ModifyStock({super.key});

  @override
  State<ModifyStock> createState() => _ModifyStockState();
}

class _ModifyStockState extends State<ModifyStock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            child: Column(
          children: [
            // const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Annuler"),
                ),
                Text(
                  "Corriger stock (T1)",
                  style: TextStyle(color: Color(0xFF145da0), fontSize: 16, decoration: TextDecoration.underline),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Effectuer"),
                ),
              ],
            ),
            // const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Normaux'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Cassés'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Double jaune'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Congelés (Kg)'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Blancs'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Fêlés'),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
