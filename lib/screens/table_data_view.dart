import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/table_charts_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import '../mywidgets/chip_widget.dart';
import './charts_screen.dart';
import './age_details_screen.dart';

class TableDataView extends StatefulWidget {
  static const routeName = "table-data-screen/";
  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

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

  void fetchSites(lotId, sAge, lAge) async {
    setState(() {
      isLoading = true;
    });
    try {
      final lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    tableData = Provider.of<TableAndChartsProvider>(context, listen: false).getTableData;
    lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (_isInit && tableData.isEmpty) {
      fetchSites(lotData['lotId'], lotData['fage'], lotData['lage']);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void showChartSnack(String msg, route, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        content: Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: [
            Icon(
              MdiIcons.chartAreaspline,
              color: Colors.white,
            ),
            Text(msg),
          ],
        ),
        action: SnackBarAction(
            label: 'Aller',
            onPressed: () {
              widget.goToPage(context, route);
            },
            textColor: color,
            backgroundColor: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.of(context).pop(),
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
                              fetchSites(lotData['lotId'], lotData['fage'], lotData['lage']);
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
                      dataTextStyle: TextStyle(color: Colors.black, fontSize: 15.5),

                      minWidth: 2550,
                      columns: [
                        DataColumn2(
                          fixedWidth: 60,
                          label: Center(
                            child: Text(
                              'Age',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Age en semaine",
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: Text(
                            'Lumiére',
                            style: TextStyle(color: Colors.white),
                          ),
                          tooltip: "Durée de lumiére",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Eclairage", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: Text(
                            'Flash',
                            style: TextStyle(color: Colors.white),
                          ),
                          tooltip: "Durée de flash",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Eclairage", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              'Poids corporel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Poids corporel (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Poids corporel", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              ' Homogéniété',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Homogéniété",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Homogéniété", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 86,
                          label: Center(
                            child: Text(
                              'Intensité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          tooltip: "Intensité (Lux)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Eclairage", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              'Mortalité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Mortalité par semaine (%)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Mortalité", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              'Σ Mortalité',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Mortalité par semaine (%)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Mortalité", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 90,
                          label: FittedBox(
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
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 80,
                          label: Center(
                            child: Text(
                              'Eau (ml)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Eau par sujet/jour",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 100,
                          label: Center(
                            child: Text(
                              'Σ Aliment (T)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Alimet distribué",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          // fixedWidth: 90,
                          label: Center(
                            child: Text(
                              'APS (g)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Aliment par sujet/jour",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 63,
                          label: Text(
                            'Ratio',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Ratio de Eau/Aliment (ml/g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              'Σ APS (kg)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Aliment cumulé par PD",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Consommation", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Center(
                            child: Text(
                              'Ponte (oeuf)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'œufs pondus",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 160,
                          label: Center(
                            child: Text(
                              '    Ponte (%)',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Pourcentage de ponte",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            'Nombre d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'oeuf par PP / sem",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            'Σ Nombre d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Nombre d'oeuf par PD cumulée",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Production", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 160,
                          label: Text(
                            'Aliment/oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Pourcentage de variation de ponte",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Aliment/oeuf", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            'Poids d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Poids moyen d'oeuf (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Poids moyen d'oeuf", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            'Masse d\'oeuf',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Masse d'oeuf par PP/sem (g)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Masse d'oeuf", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          label: Text(
                            "Σ Masse d'oeuf",
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Masse d'oeuf par PD cumulée (kg)",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Masse d'oeuf", ChartsScreen.routeName, Colors.green);
                          },
                        ),
                        DataColumn2(
                          fixedWidth: 130,
                          label: Text(
                            'Indice de conversion',
                            style: TextStyle(color: Colors.white),
                          ),
                          size: ColumnSize.S,
                          tooltip: "Indice de conversion",
                          onSort: (columnIndex, ascending) {
                            showChartSnack("Indice de convertion", ChartsScreen.routeName, Colors.green);
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
                                DataCell(onTap: () {
                                  showChartSnack('Voir details de ${tableData[i].age}', AgeDetailsScreen.routeName, Colors.blue.shade800);
                                },
                                    Center(
                                        child: Text(
                                      '${tableData[i].age}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                                    ))),
                                DataCell(Center(child: Text("${tableData[i].light}"))),
                                DataCell(Center(child: Text("${tableData[i].flash}"))),
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
                                DataCell(Text("${tableData[i].intensite} ${tableData[i].isLux ? 'lux' : '%'}")),
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
                                          style: TextStyle(fontWeight: FontWeight.normal),
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
