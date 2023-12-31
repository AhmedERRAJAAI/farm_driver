import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/table_charts_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import '../mywidgets/chip_widget.dart';
import 'table_charts_screen.dart';
import './age_details_screen.dart';
import '../charts/charts_provider.dart';
// import 'package:flutter/services.dart';

class TableDataView extends StatefulWidget {
  static const routeName = "table-data-screen/";

  const TableDataView({super.key});

  @override
  State<TableDataView> createState() => _TableDataViewState();
}

class _TableDataViewState extends State<TableDataView> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  Map lotData = {};
  List tableData = [];

  void fetchLtableData(lotId, sAge, lAge) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<TableAndChartsProvider>(context, listen: false).fetchLargeTableData(lotId, sAge, lAge).then((_) {
        setState(() {
          tableData = Provider.of<TableAndChartsProvider>(context, listen: false).getTableData;
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  bool fetchingGuide = false;
  bool failedToFetchGuide = false;
  Future<void> fetchGuideData(int lotId, int paramId) async {
    setState(() {
      fetchingGuide = true;
    });
    try {
      await Provider.of<TableAndChartsProvider>(context, listen: false).fetchGuide(lotId, paramId).then((_) {
        setState(() {
          fetchingGuide = false;
          failedToFetchGuide = false;
        });
      });
    } catch (e) {
      setState(() {
        fetchingGuide = false;
        failedToFetchGuide = true;
      });
    }
  }

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    tableData = Provider.of<TableAndChartsProvider>(context, listen: false).getTableData;
    lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (_isInit && tableData.isEmpty) {
      fetchLtableData(lotData['lotId'], lotData['fage'], lotData['lage']);
    } else if (lotData['lotId'] != tableData[0].lotId) {
      fetchLtableData(lotData['lotId'], lotData['fage'], lotData['lage']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> lightChartsDataSetter(List data) async {
    List<LightFlash> dataHolder = [];
    for (var row in data) {
      dataHolder.add(
        LightFlash(
          age: row.age,
          light: convertTimeToDouble(row.light['period']),
          flash: convertTimeToDouble(row.flash['period']),
          intensite: row.intensite,
        ),
      );
    }
    ChartsDataLocalProvider().setFlashLight = dataHolder;
  }

  Future<void> pvHomogDataSetter(List data) async {
    GuidesData guide = Provider.of<TableAndChartsProvider>(context, listen: false).getGuide;
    List<PvHomog> dataHolder = [];
    for (var row in guide.params) {
      dataHolder.add(
        PvHomog(
          age: row['G_age'],
          pvReel: null,
          pvGuide: row['G_poidVif'],
          homogReel: null,
          homogGuide: row['G_homog'],
        ),
      );
    }
    for (int i = 0; i < dataHolder.length && i < data.length; i++) {
      dataHolder[i].pvReel = data[i].poidVif['reel'];
      dataHolder[i].homogReel = data[i].homog['reel'];
    }
    ChartsDataLocalProvider().setPvHomog = dataHolder;
  }

  Future<void> mortalityDataSetter(List data) async {
    GuidesData guide = Provider.of<TableAndChartsProvider>(context, listen: false).getGuide;
    List<Mortality> dataHolder = [];
    for (var row in guide.params) {
      dataHolder.add(
        Mortality(
          age: row['G_age'],
          sem_reel: null,
          sem_guide: row['G_mortSem'],
          cuml_reel: null,
          cuml_guide: row['G_mortCumlPD'],
        ),
      );
    }
    for (int i = 0; i < dataHolder.length && i < data.length; i++) {
      dataHolder[i].sem_reel = data[i].mortSem['reel'];
      dataHolder[i].cuml_reel = data[i].mortCuml['reel'];
    }
    print(dataHolder);
    ChartsDataLocalProvider().setMortality = dataHolder;
  }

  void showChartSnack(String msg, Color color, int paramId) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            Icon(
              MdiIcons.chartAreaspline,
              color: Colors.white,
            ),
            Text('  $msg', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        action: SnackBarAction(
            label: 'Go',
            onPressed: () async {
              switch (paramId) {
                case 1:
                  await lightChartsDataSetter(tableData).then((_) {
                    Navigator.of(context).pushNamed(ChartsScreen.routeName, arguments: {
                      "chartId": paramId
                    });
                  });
                  break;
                case 2:
                  await fetchGuideData(lotData['lotId'], 2).then((_) {
                    pvHomogDataSetter(tableData);
                    Navigator.of(context).pushNamed(ChartsScreen.routeName, arguments: {
                      "chartId": paramId
                    });
                  });
                  break;
                case 3:
                  await fetchGuideData(lotData['lotId'], 3).then((_) {
                    mortalityDataSetter(tableData);
                    Navigator.of(context).pushNamed(ChartsScreen.routeName, arguments: {
                      "chartId": paramId
                    });
                  });
                  break;
                case 4:
                  await fetchGuideData(lotData['lotId'], 3).then((_) {
                    mortalityDataSetter(tableData);
                    Navigator.of(context).pushNamed(ChartsScreen.routeName, arguments: {
                      "chartId": 33
                    });
                  });
                  break;
                default:
              }
            },
            textColor: color,
            backgroundColor: Colors.white),
      ),
    );
  }

  void showDetailsSnack(String msg, route, Color color, LtableData data) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        content: Row(
          children: [
            const Icon(
              Icons.zoom_in,
              color: Colors.white,
            ),
            Text(
              msg,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        action: SnackBarAction(
            label: 'Go',
            onPressed: () {
              Navigator.of(context).pushNamed(AgeDetailsScreen.routeName, arguments: {
                'lotId': lotData['lotId'],
                'lotCode': lotData['lotCode'],
                'batiment': lotData['batiment'],
                'weekReport': data
              });
            },
            textColor: color,
            backgroundColor: Colors.white),
      ),
    );
  }

  // List<Map<String, dynamic>> newList = tableData.map((map) {
  //   return {
  //     "age": map["age"],
  //     "light": map["light"],
  //     "flash": map["flash"],
  //   };
  // }).toList();

  double convertTimeToDouble(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length == 2) {
      int hours = int.tryParse(parts[0]) ?? 0;
      int minutes = int.tryParse(parts[1]) ?? 0;

      double result = hours.toDouble() + (minutes.toDouble() / 60.0);
      return result;
    } else {
      throw FormatException('Invalid time format: $timeString');
    }
  }

  @override
  Widget build(BuildContext context) {
    lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pop();
            },
          ),
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${lotData['lotCode']} (${lotData['batiment']})',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                fetchLtableData(lotData['lotId'], lotData['fage'], lotData['lage']);
              },
              icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.zero,
          child: isLoading
              ? const LinearProgressIndicator()
              : failedToFetch
                  ? Center(
                      child: Column(
                      children: [
                        const Text('Failed to fetch'),
                        TextButton(
                            onPressed: () {
                              fetchLtableData(lotData['lotId'], lotData['fage'], lotData['lage']);
                            },
                            child: const Text("Refresh"))
                      ],
                    ))
                  : DataTable2(
                      dataRowColor: MaterialStateColor.resolveWith((states) {
                        return Colors.white;
                      }),
                      border: TableBorder(verticalInside: BorderSide(width: 1, color: Colors.grey.shade400), right: BorderSide(width: 1, color: Colors.grey.shade400)),
                      columnSpacing: 10,
                      horizontalMargin: 0,
                      fixedLeftColumns: 1,
                      headingRowDecoration: BoxDecoration(color: Colors.blue.shade800),
                      headingRowHeight: 45,
                      dataRowHeight: 30,
                      isHorizontalScrollBarVisible: true,
                      isVerticalScrollBarVisible: true,
                      dataTextStyle: const TextStyle(color: Colors.black, fontSize: 15.5),
                      fixedColumnsColor: Colors.amber.shade700,

                      minWidth: 2550,
                      columns: [
                        DataColumn2(
                          fixedWidth: 60,
                          label: Center(
                            child: Row(
                              children: [
                                const Text(
                                  '  Age ',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 10, height: 10, child: fetchingGuide ? CircularProgressIndicator(color: Colors.white) : null),
                              ],
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Age en semaine",
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: const Text(
                            'Lumiére',
                            style: TextStyle(color: Colors.white),
                          ),
                          tooltip: "Durée de lumiére",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Éclairage", Colors.amber, 1);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: const Text(
                            'Flash',
                            style: TextStyle(color: Colors.white),
                          ),
                          tooltip: "Durée de flash",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Eclairage", Colors.amber, 1);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 86,
                          label: const Center(
                            child: Text(
                              'Intensité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          tooltip: "Intensité (Lux)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Eclairage", Colors.amber, 1);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              'Poids corporel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Poids corporel (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Poids corporel", Colors.green, 2);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              ' Homogéniété',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Homogéniété",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Homogéniété", Colors.green, 2);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              'Mortalité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Mortalité par semaine (%)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Mortalité", Colors.green, 3);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              'Σ Mortalité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Mortalité par semaine (%)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Mortalité", Colors.green, 3);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 90,
                          label: const FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Σ Eau (m',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '3',
                                  style: TextStyle(color: Colors.white, fontSize: 8),
                                ),
                                Text(
                                  ')',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Eau consommé",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 4);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: const Center(
                            child: Text(
                              'Eau (ml)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Eau par sujet/jour",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 5);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 100,
                          label: const Center(
                            child: Text(
                              'Σ Aliment (T)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Alimet distribué",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 4);
                          },
                        ),
                        DataColumn2(
                          // fixedWidth: 90,
                          label: const Center(
                            child: Text(
                              'APS (g)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Aliment par sujet/jour",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 5);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 63,
                          label: const Text(
                            'Ratio',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Ratio de Eau/Aliment (ml/g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 5);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              'Σ APS (kg)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Aliment cumulé par PD",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", Colors.green, 6);
                          },
                        ),
                        DataColumn2(
                          label: const Center(
                            child: Text(
                              'Ponte (oeuf)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'œufs pondus",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", Colors.green, 7);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 160,
                          label: const Center(
                            child: Text(
                              '    Ponte (%)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Pourcentage de ponte",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", Colors.green, 7);
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            'Nombre d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'oeuf par PP / sem",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            'Σ Nombre d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'oeuf par PD cumulée",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 160,
                          label: const Text(
                            'Aliment/oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Pourcentage de variation de ponte",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Aliment/oeuf", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            'Poids d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Poids moyen d'oeuf (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Poids moyen d'oeuf", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            'Masse d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Masse d'oeuf par PP/sem (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Masse d'oeuf", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          label: const Text(
                            "Σ Masse d'oeuf",
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Masse d'oeuf par PD cumulée (kg)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Masse d'oeuf", Colors.green, 8);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 130,
                          label: const Text(
                            'Indice de conversion',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Indice de conversion",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Indice de convertion", Colors.green, 8);
                          },
                        ),
                      ],
                      rows: <DataRow>[
                        for (int i = 0; i <= tableData.length - 1; i++)
                          DataRow(
                              color: MaterialStateColor.resolveWith((states) {
                                return i % 2 != 0 ? const Color.fromARGB(255, 240, 240, 240) : Colors.white;
                              }),
                              cells: [
                                DataCell(
                                  onTap: () {
                                    showDetailsSnack(
                                      ' Voir details, Age:  ${tableData[i].age}',
                                      AgeDetailsScreen.routeName,
                                      Colors.amber.shade700,
                                      tableData[i],
                                    );
                                  },
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${tableData[i].age} ',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        const Icon(
                                          Icons.expand_more,
                                          size: 18,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Center(child: Text("${tableData[i].light['period']}"))),
                                DataCell(Center(child: Text("${tableData[i].flash['period']}"))),
                                DataCell(Text("${tableData[i].intensite} ${tableData[i].isLux ? 'lux' : '%'}")),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].poidVif['reel'].round()}'),
                                        EcartChip(
                                          colorName: tableData[i].poidVif['color'],
                                          directionIndex: tableData[i].poidVif['isUp'],
                                          ecart: tableData[i].poidVif['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].homog['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].homog['color']}',
                                          directionIndex: tableData[i].homog['isUp'],
                                          ecart: tableData[i].homog['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].mortSem['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].mortSem['color']}',
                                          directionIndex: tableData[i].mortSem['isUp'],
                                          ecart: tableData[i].mortSem['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].mortCuml['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].mortCuml['color']}',
                                          directionIndex: tableData[i].mortCuml['isUp'],
                                          ecart: tableData[i].mortCuml['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Text("${tableData[i].eauDistCuml}")),
                                DataCell(Text("${tableData[i].eps}")),
                                DataCell(Text("${tableData[i].altDistCuml}")),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].aps['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].aps['color']}',
                                          directionIndex: tableData[i].aps['isUp'],
                                          ecart: tableData[i].aps['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Text(
                                      "${tableData[i].ratio['reel']}",
                                      style: TextStyle(
                                          color: tableData[i].ratio['color'] == 'green'
                                              ? Colors.green.shade800
                                              : tableData[i].ratio['color'] == 'red'
                                                  ? Colors.red.shade800
                                                  : Colors.amber.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].altCumlPd['reel']}'),
                                        EcartChip(
                                          colorName: tableData[i].altCumlPd['color'],
                                          directionIndex: tableData[i].altCumlPd['isUp'],
                                          ecart: tableData[i].altCumlPd['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Center(child: Text("${tableData[i].nbrPonte}"))),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${tableData[i].ponteVar['reel'] > 0 ? '+' '${tableData[i].ponteVar['reel']}' : tableData[i].ponteVar['reel']}",
                                          style: TextStyle(color: tableData[i].ponteVar['color'] ? Colors.green.shade900 : Colors.red.shade400, fontSize: 11),
                                        ),
                                        Text(
                                          ' ${tableData[i].ponteCent['reel']}',
                                          style: const TextStyle(fontWeight: FontWeight.normal),
                                        ),
                                        EcartChip(
                                          colorName: '${tableData[i].ponteCent['color']}',
                                          directionIndex: tableData[i].ponteCent['isUp'],
                                          ecart: tableData[i].ponteCent['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].nopppSem['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].nopppSem['color']}',
                                          directionIndex: tableData[i].nopppSem['isUp'],
                                          ecart: tableData[i].nopppSem['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].noppdCuml['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].noppdCuml['color']}',
                                          directionIndex: tableData[i].noppdCuml['isUp'],
                                          ecart: tableData[i].noppdCuml['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FittedBox(child: Text('${tableData[i].altOeufSem['reel']}')),
                                        FittedBox(
                                          child: EcartChip(
                                            colorName: '${tableData[i].altOeufSem['color']}',
                                            directionIndex: tableData[i].altOeufSem['isUp'],
                                            ecart: tableData[i].altOeufSem['ecart'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].pmo['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].pmo['color']}',
                                          directionIndex: tableData[i].pmo['isUp'],
                                          ecart: tableData[i].pmo['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].massOeufSem['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].massOeufSem['color']}',
                                          directionIndex: tableData[i].massOeufSem['isUp'],
                                          ecart: tableData[i].massOeufSem['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].massOeufCuml['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].massOeufCuml['color']}',
                                          directionIndex: tableData[i].massOeufCuml['isUp'],
                                          ecart: tableData[i].massOeufCuml['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${tableData[i].ic['reel']}'),
                                        EcartChip(
                                          colorName: '${tableData[i].ic['color']}',
                                          directionIndex: tableData[i].ic['isUp'],
                                          ecart: tableData[i].ic['ecart'],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                      ],
                      // rows: List<DataRow>.generate(
                      //   100,
                      //   (index) => DataRow(
                      //     cells: [
                      //       DataCell(Text('A' * (10 - index % 10))),
                      //       DataCell(Text('B' * (10 - (index + 5) % 10))),
                      //       DataCell(Text('C' * (15 - (index + 5) % 10))),
                      //       DataCell(Text('D' * (15 - (index + 10) % 10))),
                      //       DataCell(Text(((index + 0.1) * 25.4).toString()))
                      //     ],
                      //   ),
                      // ),
                    ),
        ));
    // });
  }
}
