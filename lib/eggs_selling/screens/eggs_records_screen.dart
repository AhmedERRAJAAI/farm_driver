import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'egg_mouvement_form_screen.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';
import '../constants.dart';
import '../widgets/errorAlert.dart';
import '../widgets/dates_filter.dart';

class EggMouvementRecords extends StatefulWidget {
  const EggMouvementRecords({super.key});
  static const routeName = "egg-mouv-records";

  @override
  State<EggMouvementRecords> createState() => _EggMouvementRecordsState();
}

class _EggMouvementRecordsState extends State<EggMouvementRecords> {
  int recordsNbr = 40;
  bool isEntree = true;
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
      getSorties(recordsNbr, false);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getSorties(int count, bool isEntree) async {
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

  @override
  Widget build(BuildContext context) {
    List mouvments = Provider.of<MouvementProvider>(context).sorties;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        backgroundColor: const Color(0xFF145da0),
        title: const Text(
          "Enregistrements sorties/entrées",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // showModalBottomSheet(
              //     context: context,
              //     builder: (context) {
              //       return OperationsFilter(

              //         clientsOptions: null,
              //         clientGetter: null,
              //       );
              //     });
            },
            icon: const Icon(
              Icons.tune,
              size: 24,
            ),
            color: Colors.white,
          ),
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
              onValueChanged: (value) {
                setState(() {
                  selectedPage = value;
                  if (selectedPage == 0) {
                    isEntree = false;
                    mouvments.clear;
                    getSorties(recordsNbr, false);
                    mouvments = Provider.of<MouvementProvider>(context).sorties;
                  } else {
                    isEntree = true;
                    mouvments.clear;
                    getSorties(recordsNbr, true);
                    mouvments = Provider.of<MouvementProvider>(context).sorties;
                  }
                });
              },
            ),
          ),
          isLoading
              ? LinearProgressIndicator()
              : mouvments.isEmpty
                  ? SizedBox(
                      child: Column(children: [
                        SizedBox(height: 20),
                        Text("Pas de données"),
                        TextButton(
                          onPressed: () {
                            getSorties(recordsNbr, isEntree);
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Text(client ?? operationOptions[type].value),
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
                SizedBox(
                  width: 20,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: isEntree ? SortieMovement(id: 9) : EntreeMovement(id: 9),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.green.shade700,
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
