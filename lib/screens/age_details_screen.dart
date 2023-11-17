import 'package:flutter/material.dart';
import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../providers/sites_bats_provider.dart';
import '../providers/table_charts_provider.dart';
import 'package:provider/provider.dart';
import '../mywidgets/chip_widget.dart';
import '../services/notification_services.dart';
import 'package:url_launcher/url_launcher.dart';
import './pdf_viewer_screen.dart';

class AgeDetailsScreen extends StatefulWidget {
  static const routeName = "age-details";

  const AgeDetailsScreen({super.key});

  @override
  State<AgeDetailsScreen> createState() => _AgeDetailsScreenState();
}

class _AgeDetailsScreenState extends State<AgeDetailsScreen> {
  late BottomSheetTable daysData;
  bool daysLoading = false;
  bool failedToFetchDays = false;
  Map<int, Color> observUrgColors = {
    0: Colors.red,
    1: Colors.orange,
    2: Colors.green,
    3: Colors.blue,
  };
  @override
  void initState() {
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

  bool pdfLoading = false;
  bool failedPdf = false;
  Future<void> fetchWeekPdf(BuildContext context, age, lotId) async {
    setState(() {
      pdfLoading = true;
    });
    try {
      Provider.of<TableAndChartsProvider>(context, listen: false).downloadPDF("Rapport_age_$age", lotId, age).then((_) {
        NotificationService().showNotification(title: "Downloaded", body: "Telechargement fini");
        Navigator.of(context).pushNamed(PdfViewerScreen.routeName);
        // openPDF("/storage/emulated/0/Download/rapport_age_$age.pdf");
        setState(() {
          pdfLoading = false;
          failedPdf = false;
        });
      });
    } catch (e) {
      setState(() {
        pdfLoading = false;
        failedPdf = true;
      });
    }
  }

  void openPDF(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      print("yessss");
      if (await launchUrl(Uri.parse(filePath))) {
        await launchUrl(Uri.parse(filePath));
      } else {
        print("Cant be opened");
      }
    } else {
      print("does not exists");
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
                            style: const TextStyle(fontSize: 13),
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

  DataRow buildDataRow(
    BuildContext context,
    String name,
    String unity,
    double? variation,
    double mortCumlReel,
    String mortCumlColor,
    int mortCumlIsUp,
    double mortCumlEcart,
    int paramId,
    int age,
    int lotId,
    Function fetchData,
  ) {
    return DataRow(
      onLongPress: () {
        fetchData(context, age, paramId, lotId);
      },
      cells: <DataCell>[
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                variation == null
                    ? const Text("")
                    : Text(
                        "${variation > 0 ? '+${variation.toStringAsFixed(1)}' : variation} ",
                        style: TextStyle(
                          fontSize: 10,
                          color: variation >= 0 ? Colors.green.shade700 : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                Text(
                  "$mortCumlReel",
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  unity,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerLeft,
            child: EcartChip(
              colorName: mortCumlColor,
              directionIndex: mortCumlIsUp,
              ecart: mortCumlEcart,
            ),
          ),
        ),
      ],
    );
  }

  bool? isSortedAsc;
  late LtableData paramsData;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final repData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    paramsData = repData['weekReport'];
    // final double tableFontSize = deviceSize.width * 0.035;
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
              '${repData['batiment']} (${repData['lotCode']})',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            onSelected: (selectedVal) {
              switch (selectedVal) {
                case 0:
                  fetchWeekPdf(context, paramsData.age, repData['lotId']);
                  break;
                case 1:
                  // Navigator.of(context).pushNamed(PdfViewerScreen.routeName);
                  NotificationService().showNotification(title: "Hellooo", body: "Hellooo Agaaaaain");
                  break;
                default:
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Telecharger PDF"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Trigger notif"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
              )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                pdfLoading ? LinearProgressIndicator() : SizedBox(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  width: deviceSize.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('Age: ${paramsData.age}'),
                        // labelPadding: EdgeInsets.zero,
                        backgroundColor: Colors.green.shade100,
                      ),
                      Chip(
                        backgroundColor: Colors.orange.shade100,
                        label: Text(
                          'EP: ${paramsData.ed}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      Chip(
                        backgroundColor: Colors.blue.shade100,
                        label: Text(
                          'ED: ${paramsData.ep}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                      Chip(
                        label: FittedBox(
                            child: Text(
                          'Sem civil: ${paramsData.semCivil}/${paramsData.year}',
                          style: const TextStyle(fontSize: 10),
                        )),
                        labelPadding: EdgeInsets.zero,
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                    ],
                  ),
                ),
                DataTable(
                  columnSpacing: 30,
                  dataRowMinHeight: 20,
                  dataRowMaxHeight: 35,
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
                      label: Text(
                        'Réel',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Ecart',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    buildDataRow(
                      context,
                      'Mortalité',
                      '%',
                      null,
                      paramsData.mortSem['reel'],
                      paramsData.mortSem['color'] ?? '',
                      paramsData.mortSem['isUp'] ?? 1,
                      paramsData.mortSem['ecart'] ?? 0,
                      paramsData.mortSem['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Mortalité cumulée',
                      '%',
                      null,
                      paramsData.mortCuml['reel'],
                      paramsData.mortCuml['color'] ?? '',
                      paramsData.mortCuml['isUp'] ?? 1,
                      paramsData.mortCuml['ecart'] ?? 0,
                      paramsData.mortCuml['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Poids corporel',
                      'g',
                      null,
                      paramsData.poidVif['reel'],
                      paramsData.poidVif['color'] ?? '',
                      paramsData.poidVif['isUp'] ?? 1,
                      paramsData.poidVif['ecart'] ?? 0,
                      paramsData.poidVif['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Homogéniété',
                      '%',
                      null,
                      paramsData.homog['reel'],
                      paramsData.homog['color'] ?? '',
                      paramsData.homog['isUp'] ?? 1,
                      paramsData.homog['ecart'] ?? 0,
                      paramsData.homog['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Ponte',
                      '%',
                      paramsData.ponteVar['reel'],
                      paramsData.ponteCent['reel'],
                      paramsData.ponteCent['color'] ?? '',
                      paramsData.ponteCent['isUp'] ?? 1,
                      paramsData.ponteCent['ecart'] ?? 0,
                      paramsData.ponteCent['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'NOPPP',
                      '',
                      null,
                      paramsData.nopppSem['reel'],
                      paramsData.nopppSem['color'] ?? '',
                      paramsData.nopppSem['isUp'] ?? 1,
                      paramsData.nopppSem['ecart'] ?? 0,
                      paramsData.nopppSem['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'NOPPD',
                      '',
                      null,
                      paramsData.noppdSem['reel'],
                      paramsData.noppdSem['color'] ?? '',
                      paramsData.noppdSem['isUp'] ?? 1,
                      paramsData.noppdSem['ecart'] ?? 0,
                      paramsData.noppdSem['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Σ NOPPP',
                      '',
                      null,
                      paramsData.nopppCuml['reel'],
                      paramsData.nopppCuml['color'] ?? '',
                      paramsData.nopppCuml['isUp'] ?? 1,
                      paramsData.nopppCuml['ecart'] ?? 0,
                      paramsData.nopppCuml['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Σ NOPPD',
                      '',
                      null,
                      paramsData.noppdCuml['reel'],
                      paramsData.noppdCuml['color'] ?? '',
                      paramsData.noppdCuml['isUp'] ?? 1,
                      paramsData.noppdCuml['ecart'] ?? 0,
                      paramsData.noppdCuml['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'PMO',
                      'g',
                      null,
                      paramsData.pmo['reel'],
                      paramsData.pmo['color'] ?? '',
                      paramsData.pmo['isUp'] ?? 1,
                      paramsData.pmo['ecart'] ?? 0,
                      paramsData.pmo['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'MOPPP',
                      'g',
                      null,
                      paramsData.massOeufSem['reel'],
                      paramsData.massOeufSem['color'] ?? '',
                      paramsData.massOeufSem['isUp'] ?? 1,
                      paramsData.massOeufSem['ecart'] ?? 0,
                      paramsData.massOeufSem['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Σ MOPPD',
                      'kg',
                      null,
                      paramsData.massOeufCuml['reel'],
                      paramsData.massOeufCuml['color'] ?? '',
                      paramsData.massOeufCuml['isUp'] ?? 1,
                      paramsData.massOeufCuml['ecart'] ?? 0,
                      paramsData.massOeufCuml['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'APS',
                      'g',
                      null,
                      paramsData.aps['reel'],
                      paramsData.aps['color'] ?? '',
                      paramsData.aps['isUp'] ?? 1,
                      paramsData.aps['ecart'] ?? 0,
                      paramsData.aps['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
                    buildDataRow(
                      context,
                      'Σ APS',
                      'kg',
                      null,
                      paramsData.altCumlPd['reel'],
                      paramsData.altCumlPd['color'] ?? '',
                      paramsData.altCumlPd['isUp'] ?? 1,
                      paramsData.altCumlPd['ecart'] ?? 0,
                      paramsData.altCumlPd['id'] ?? 0,
                      paramsData.age,
                      repData['lotId'],
                      fetchData,
                    ),
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
                            DataCell(Text('${paramsData.aps['reel'] ?? '-'}')),
                            DataCell(Text('${paramsData.eps}')),
                            DataCell(
                              Chip(
                                padding: const EdgeInsets.all(0),
                                backgroundColor: paramsData.ratio['color'] == 'red' ? Colors.red.shade100 : Colors.green.shade100,
                                label: Text('${paramsData.ratio['reel'] ?? '-'}'),
                              ),
                            ),
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
                      columnSpacing: 10,
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
                              'indice de convers',
                              style: TextStyle(fontSize: 12),
                            )),
                            DataCell(Row(
                              children: [
                                Text('${paramsData.icSem['reel'] ?? '-'}'),
                                EcartChip(colorName: paramsData.icSem['color'], ecart: paramsData.icSem['ecart'], directionIndex: paramsData.icSem['isUp'])
                              ],
                            )),
                            DataCell(Row(
                              children: [
                                Text('${paramsData.ic['reel'] ?? '-'}'),
                                EcartChip(colorName: paramsData.ic['color'], ecart: paramsData.ic['ecart'], directionIndex: paramsData.ic['isUp'])
                              ],
                            )),
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
                            DataCell(Text('${paramsData.light['starts_at'] == 'None' ? '-' : paramsData.light['starts_at']}')),
                            DataCell(Text('${paramsData.light['ends_at'] == 'None' ? '-' : paramsData.light['ends_at']}')),
                            DataCell(Text('${paramsData.light['period'] == 'None' ? '-' : paramsData.light['period']}')),
                            DataCell(Text('${paramsData.intensite} ${paramsData.isLux ? 'lux' : '%'}')),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            const DataCell(Text('Flash')),
                            DataCell(Text('${paramsData.flash['starts_at'] == 'None' ? '-' : paramsData.flash['starts_at']}')),
                            DataCell(Text('${paramsData.flash['ends_at'] == 'None' ? '-' : paramsData.flash['ends_at']}')),
                            DataCell(Text('${paramsData.flash['period'] == 'None' ? 'Néant' : paramsData.flash['period']}')),
                            const DataCell(Text('')),
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
                        color: Colors.amber, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0), // Border radius
                    ),
                    height: 160.0, // Change the height when expanded
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 10,
                        dataRowMaxHeight: 115,
                        dataRowMinHeight: 30,
                        columns: <DataColumn>[
                          for (int i = 0; i <= paramsData.coloration.length - 1; i++)
                            DataColumn(
                              label: Center(
                                child: Text(
                                  '      ${paramsData.coloration[i]['date']}',
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
                        ],
                        rows: <DataRow>[
                          DataRow(
                            cells: <DataCell>[
                              for (int i = 0; i <= paramsData.coloration.length - 1; i++)
                                DataCell(
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image(
                                              image: AssetImage('assets/images/${paramsData.coloration[i]['color'] ?? 'none'}.png'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text('${paramsData.coloration[i]['color'] ?? '-'}'),
                                          ),
                                          SizedBox(
                                            height: 40,
                                            width: 100,
                                            child: RatingBar(
                                              itemSize: 15,
                                              minRating: 0,
                                              maxRating: 5,
                                              initialRating: double.parse('${paramsData.coquille[i]['color'] ?? 0}'),
                                              allowHalfRating: false,
                                              ratingWidget: RatingWidget(
                                                full: const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                half: const Icon(
                                                  Icons.star_border,
                                                  color: Colors.grey,
                                                ),
                                                empty: const Icon(
                                                  Icons.star_border,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              onRatingUpdate: (_) {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                    // padding: const EdgeInsets.symmetric(horizontal: 2),
                    width: deviceSize.width,
                    margin: const EdgeInsets.only(bottom: 40, left: 6, right: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.blueGrey, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(4.0), // Border radius
                    ),
                    height: 300.0, // Change the height when expanded
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            color: Colors.blueGrey,
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(child: Text("Contenu", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                SizedBox(
                                  width: 30,
                                  child: Text("urg", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          for (int i = 0; i <= paramsData.observs.length - 1; i++)
                            Container(
                              padding: EdgeInsets.only(top: 6, bottom: 6),
                              decoration: BoxDecoration(border: Border.all(width: 0.4, color: Colors.black)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.blueGrey, width: 0.5))),
                                    width: 50,
                                    child: Text(" ${paramsData.observs[i]['date']}"),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.blueGrey, width: 0.5))),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (int j = 0; j < paramsData.observs[i]['content'].length; j++) Text(" -${paramsData.observs[i]['content'][j]['text']}"),
                                      ],
                                    ),
                                  )),
                                  SizedBox(
                                    width: 30,
                                    child: Column(
                                      children: [
                                        for (int j = 0; j < paramsData.observs[i]['content'].length; j++)
                                          Icon(
                                            Icons.adjust,
                                            size: 15,
                                            color: observUrgColors[int.parse("${paramsData.observs[i]['content'][j]['urg'] ?? 3}")],
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
