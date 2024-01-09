import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';
import '../constants.dart';
import '../widgets/dates_filter.dart';

class EggMouvementRecords extends StatefulWidget {
  const EggMouvementRecords({super.key});
  static const routeName = "egg-mouv-records";

  @override
  State<EggMouvementRecords> createState() => _EggMouvementRecordsState();
}

class _EggMouvementRecordsState extends State<EggMouvementRecords> {
  int recordsNbr = 100;
  bool isEntree = false;
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
      getSortiesEntrees(recordsNbr, isEntree);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getSortiesEntrees(int count, bool isEntree) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchMouvments(count: count, isEntree: isEntree).then((_) {
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

  int selectedPage = 0;

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
      getSortiesEntrees(recordsNbr, isEntree);
    });
  }

  @override
  Widget build(BuildContext context) {
    List mouvments = Provider.of<MouvementProvider>(context).mouvements;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        backgroundColor: selectedPage == 0 ? Colors.blue : Colors.green,
        title: const Text(
          "Enregistrements sorties/entrées",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
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
          //             submitter: getSortiesEntrees,
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
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(children: [
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: CupertinoSegmentedControl(
              padding: EdgeInsets.zero,
              children: {
                0: Text('sorties'),
                1: Text('entrées'),
              },
              groupValue: selectedPage,
              selectedColor: selectedPage == 0 ? Colors.blue : Colors.green,
              borderColor: selectedPage == 0 ? Colors.blue : Colors.green,
              onValueChanged: (value) {
                setState(() {
                  selectedPage = value;
                  if (selectedPage == 0) {
                    isEntree = false;
                    mouvments.clear;
                    getSortiesEntrees(recordsNbr, isEntree);
                    mouvments = Provider.of<MouvementProvider>(context, listen: false).mouvements;
                  } else {
                    isEntree = true;
                    mouvments.clear;
                    getSortiesEntrees(recordsNbr, isEntree);
                    mouvments = Provider.of<MouvementProvider>(context, listen: false).mouvements;
                  }
                });
              },
            ),
          ),
          SizedBox(height: 15),
          isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
              : mouvments.isEmpty
                  ? SizedBox(
                      child: Column(children: [
                        SizedBox(height: 20),
                        Text("Pas de données"),
                        TextButton(
                          onPressed: () {
                            getSortiesEntrees(recordsNbr, isEntree);
                          },
                          child: Text("Actualiser"),
                        )
                      ]),
                    )
                  : SizedBox(
                      height: deviceSize.height * 0.8,
                      child: ListView.builder(
                          itemCount: mouvments.length,
                          itemBuilder: ((context, i) {
                            return RecordListItem(
                              themeColor: selectedPage == 0 ? Colors.blue.shade100 : Colors.green.shade200,
                              client: mouvments[i].client,
                              date: mouvments[i].date,
                              id: mouvments[i].id,
                              isEntree: selectedPage == 0 ? false : true,
                              qty: mouvments[i].qty,
                              type: mouvments[i].outType,
                            );
                          })),
                    )
        ]),
      ),
    );
  }
}

class RecordListItem extends StatelessWidget {
  final Color themeColor;
  final String? client;
  final int id;
  final String date;
  final int qty;
  final int type;
  final bool isEntree;
  const RecordListItem({
    super.key,
    required this.id,
    required this.client,
    required this.date,
    required this.qty,
    required this.type,
    required this.isEntree,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isEntree) return;
        Navigator.of(context).pushNamed(
          "operation-details/",
          arguments: {
            'operation_id': id
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: themeColor, width: 1.5), borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              client ?? operationOptions[type].value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              date,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$qty",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
