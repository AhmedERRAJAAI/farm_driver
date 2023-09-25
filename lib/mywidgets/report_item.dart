import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/sites_bats_provider.dart';
import 'package:provider/provider.dart';
import './chip_widget.dart';

class ReportItem extends StatefulWidget {
  final double height;
  final double width;
  final TableData oneReport;
  final int lotId;
  ReportItem({
    required this.height,
    required this.width,
    required this.oneReport,
    required this.lotId,
  });

  @override
  State<ReportItem> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  List initRepData = [];
  late BottomSheetTable daysData;
  bool daysLoading = false;
  bool failedToFetchDays = false;

  @override
  void initState() {
    initRepData = List.from(widget.oneReport.params);
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  Future<void> fetchData(BuildContext context, age, id, lotId) async {
    setState(() {
      daysLoading = true;
    });
    try {
      Provider.of<SitesBatsProvider>(context, listen: false).fetchDaysReports(lotId, age, id).then((_) {
        setState(() {
          daysData = Provider.of<SitesBatsProvider>(context, listen: false).paramDays;
          daysLoading = false;
          failedToFetchDays = false;
          _showModalBottomSheet(context, daysData);
        });
      });
    } catch (e) {
      setState(() {
        daysLoading = false;
        failedToFetchDays = true;
      });
    }
  }

  void _showModalBottomSheet(context, daysData) {
    List head = daysData.header;
    List body = daysData.body;
    List dates = daysData.dates;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var dt = 0; dt < dates.length; dt++) Text('${dates[dt]}')
                    ],
                  ),
                  Center(
                    child: Text("${daysData.name}"),
                  ),
                  DataTable(
                    columnSpacing: 26,
                    dataRowMaxHeight: 35,
                    dataRowMinHeight: 20,
                    columns: <DataColumn>[
                      for (var i = 0; i < head.length; i++)
                        DataColumn(
                          label: Text(
                            head[i],
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                    ],
                    rows: <DataRow>[
                      for (var row = 0; row < body.length; row++)
                        DataRow(
                          cells: <DataCell>[
                            for (var cell = 0; cell < body[row].length; cell++) DataCell(Text('${body[row][cell]}')),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void sortListByEcartAndColor(List inputList, Function colorSorter, bool asc) {
    inputList.sort((a, b) {
      double ecartA = a['ecart'];
      double ecartB = b['ecart'];
      int colorOrderA = colorSorter(a['color']);
      int colorOrderB = colorSorter(b['color']);

      // First, compare by color order
      if (colorOrderA != colorOrderB && asc) {
        return colorOrderA.compareTo(colorOrderB);
      } else if (colorOrderA != colorOrderB && !asc) {
        return colorOrderB.compareTo(colorOrderA);
      }

      // // If colors are the same, then compare by ecart
      return ecartB.compareTo(ecartA);
    });

    setState(() {
      paramsData = inputList;
    });
  }

  int _getColorOrder(String color) {
    switch (color) {
      case 'red':
        return 1;
      case 'orange':
        return 2;
      case 'green':
        return 3;
      default:
        return 4; // Handle any other colors if needed
    }
  }

  int _getReversedColorOrder(String color) {
    switch (color) {
      case 'green':
        return 3;
      case 'orange':
        return 2;
      case 'red':
        return 1;
      default:
        return 4; // Handle any other colors if needed
    }
  }

  void setDefaultOrder() {
    setState(() {
      initRepData = List.from(widget.oneReport.params);
    });
  }

  bool? isSortedAsc;
  List paramsData = [];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    paramsData = initRepData;
    final double tableFontSize = deviceSize.width * 0.035;
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                width: deviceSize.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text('Age: ${widget.oneReport.calendar['age']}'),
                      // labelPadding: EdgeInsets.zero,
                      backgroundColor: Colors.green.shade100,
                    ),
                    Chip(
                      backgroundColor: Colors.orange.shade100,
                      label: Text(
                        'EP: ${widget.oneReport.edp}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Chip(
                      backgroundColor: Colors.blue.shade100,
                      label: Text(
                        'ED: ${widget.oneReport.ep}',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Chip(
                      label: Text('Sem civil: ${widget.oneReport.calendar['semCivil']}/${widget.oneReport.calendar['year']}'),
                      labelPadding: EdgeInsets.zero,
                      backgroundColor: Colors.deepOrange.shade100,
                    ),
                  ],
                ),
              ),
              DataTable(
                columnSpacing: 55,
                dataRowMaxHeight: 36,
                dataRowMinHeight: 30,
                columns: <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      flex: 2,
                      child: Center(
                        child: Row(
                          children: [
                            const Text(
                              'Paramétre  ',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                            ),
                            daysLoading
                                ? failedToFetchDays
                                    ? const SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: Icon(
                                          Icons.sms_failed,
                                          color: Colors.red,
                                        ))
                                    : const SizedBox(width: 10, height: 10, child: CircularProgressIndicator())
                                : const Text('')
                          ],
                        ),
                      ),
                    ),
                  ),
                  const DataColumn(
                    label: Row(
                      children: [
                        Text(
                          'Réel',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  DataColumn(
                    onSort: (columnIndex, ascending) {
                      if (isSortedAsc == null) {
                        sortListByEcartAndColor(paramsData, _getColorOrder, true);
                        isSortedAsc = true;
                      } else if (isSortedAsc == true) {
                        sortListByEcartAndColor(paramsData, _getReversedColorOrder, false);
                        isSortedAsc = false;
                      } else {
                        setDefaultOrder();
                        isSortedAsc = null;
                      }
                    },
                    label: Chip(
                      labelPadding: EdgeInsets.zero,
                      padding: EdgeInsets.all(3),
                      backgroundColor: isSortedAsc == null
                          ? Colors.blue.shade50
                          : isSortedAsc == false
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      label: Row(
                        children: [
                          Text(
                            'Écart',
                            style: TextStyle(
                                color: isSortedAsc == null
                                    ? Colors.blue
                                    : isSortedAsc == false
                                        ? Colors.green.shade800
                                        : Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          isSortedAsc == null
                              ? const Icon(
                                  Icons.filter_list,
                                  color: Colors.blue,
                                  size: 16,
                                )
                              : isSortedAsc == false
                                  ? Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green.shade800,
                                      size: 16,
                                    )
                                  : const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                      size: 16,
                                    )
                        ],
                      ),
                    ),
                  ),
                  // const DataColumn(
                  //   label: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Text(
                  //         'Guide',
                  //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
                rows: <DataRow>[
                  ...paramsData.map((param) {
                    return DataRow(
                      onLongPress: () {
                        fetchData(context, widget.oneReport.calendar['age'], param['id'], widget.lotId);
                      },
                      cells: <DataCell>[
                        DataCell(Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${param['name']}",
                              overflow: TextOverflow.ellipsis,
                            ))),
                        DataCell(FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${param['reel']}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                param['unity'] ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: tableFontSize * 0.9, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                              ),
                            ],
                          ),
                        )),
                        // DataCell(Center(child: Text("${param['ecart']}"))),
                        DataCell(
                          Align(
                            alignment: Alignment.centerLeft,
                            child: EcartChip(
                              colorName: param['color'] ?? '',
                              directionIndex: param['isUp'] ?? 1,
                              ecart: param['ecart'] ?? 0,
                            ),
                          ),
                        ),
                        // DataCell(Align(alignment: Alignment.centerRight, child: Text("${param['guide']}"))),
                      ],
                    );
                  }).toList()
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: deviceSize.width,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.green, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 100.0,
                  child: DataTable(
                    columnSpacing: 20,
                    dataRowMaxHeight: 33,
                    dataRowMinHeight: 20,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Row(
                          children: [
                            Icon(MdiIcons.barley, color: Colors.green),
                            Icon(MdiIcons.water, color: Colors.blue.shade300),
                          ],
                        ),
                      ),
                      const DataColumn(
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Alt/sujet',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            Text(
                              '(g)',
                              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      const DataColumn(
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'eau/sujet',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            Text(
                              '(ml)',
                              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      const DataColumn(
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Ratio',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            Text(
                              '(ml/g)',
                              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('conso/jour')),
                          DataCell(Text('${widget.oneReport.consumption['aps'] ?? '-'}')),
                          DataCell(Text('${widget.oneReport.consumption['eps'] ?? '-'}')),
                          DataCell(Text('${widget.oneReport.consumption['ratio'] ?? '-'}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: deviceSize.width,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color.fromARGB(255, 203, 105, 69), // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 100.0,
                  child: DataTable(
                    columnSpacing: 20,
                    dataRowMaxHeight: 33,
                    dataRowMinHeight: 20,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Icon(Icons.sync, color: Color.fromARGB(255, 203, 105, 69)),
                      ),
                      DataColumn(label: Text("par semaine")),
                      DataColumn(label: Text('Cumulée')),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text(
                            'indice de conversion',
                            style: TextStyle(fontSize: 12),
                          )),
                          DataCell(Text('${widget.oneReport.indiceConver['ic_sem'] ?? '-'}')),
                          DataCell(Text('${widget.oneReport.indiceConver['ic_cuml'] ?? '-'}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: deviceSize.width,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.blue, // Border color
                      width: 1.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Border radius
                  ),
                  height: 120.0, // Change the height when expanded
                  child: DataTable(
                    columnSpacing: 20,
                    dataRowMaxHeight: 28,
                    dataRowMinHeight: 20,
                    columns: <DataColumn>[
                      DataColumn(
                          label: AnimatedContainer(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
                          BoxShadow(
                            color: Colors.yellow.shade400.withOpacity(0.5), // Color of the shadow
                            spreadRadius: 5, // Spread radius
                            blurRadius: 10, // Blur radius
                            offset: const Offset(0, -6), // Offset of the shadow
                          ),
                        ]),
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.emoji_objects,
                          color: Colors.yellow.shade700,
                        ),
                      )),
                      const DataColumn(
                        label: Text(
                          'Allumage',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Extinction',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Durée',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Intensité',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Lumiere')),
                          DataCell(Text('${widget.oneReport.lumiere['starts_at'] == 'None' ? '-' : widget.oneReport.lumiere['starts_at']}')),
                          DataCell(Text('${widget.oneReport.lumiere['ends_at'] == 'None' ? '-' : widget.oneReport.lumiere['ends_at']}')),
                          DataCell(Text('${widget.oneReport.lumiere['period'] == 'None' ? '-' : widget.oneReport.lumiere['period']}')),
                          DataCell(Text('${widget.oneReport.lumiere['intensité'] ?? '-'}')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Flash')),
                          DataCell(Text('${widget.oneReport.flash['starts_at'] == 'None' ? '-' : widget.oneReport.flash['starts_at']}')),
                          DataCell(Text('${widget.oneReport.flash['ends_at'] == 'None' ? '-' : widget.oneReport.flash['ends_at']}')),
                          DataCell(Text('${widget.oneReport.flash['period'] == 'None' ? 'Néant' : widget.oneReport.flash['period']}')),
                          const DataCell(Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
