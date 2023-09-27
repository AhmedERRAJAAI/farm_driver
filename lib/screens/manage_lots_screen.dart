import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/settings_apps_provider.dart';

class ManageLotsScreen extends StatefulWidget {
  const ManageLotsScreen({super.key});
  static const routeName = "manage-lots-list/";

  @override
  State<ManageLotsScreen> createState() => _ManageLotsScreenState();
}

class _ManageLotsScreenState extends State<ManageLotsScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  bool deleted = false;
  bool reforme = false;
  List lotsData = [];
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    lotsData = Provider.of<SettingsAppsProvider>(context, listen: false).getAllLots;
    if (_isInit) {
      fetchAllLots();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchAllLots() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SettingsAppsProvider>(context, listen: false).fetchAllUserlots().then((_) {
        setState(() {
          lotsData = Provider.of<SettingsAppsProvider>(context, listen: false).getAllLots;
          failedToFetch = false;
          isLoading = false;
        });
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  Future<void> deleteLot(lotId) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SettingsAppsProvider>(context, listen: false).fetchAllUserlots().then((_) {
        setState(() {
          lotsData = Provider.of<SettingsAppsProvider>(context, listen: false).getAllLots;
          failedToFetch = false;
          isLoading = false;
          deleted = true;
        });
      });
    } catch (e) {
      setState(() {
        deleted = false;
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  Future<void> startStopReform(lotid) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SettingsAppsProvider>(context, listen: false).fetchAllUserlots().then((_) {
        setState(() {
          lotsData = Provider.of<SettingsAppsProvider>(context, listen: false).getAllLots;
          failedToFetch = false;
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  void showSnacks(lotid, String successMsg, String errorMsg) async {
    await deleteLot(lotid).then((_) {
      if (deleted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(successMsg),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('OK'))
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 12),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(errorMsg),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('OK'))
              ],
            ),
          ),
        );
      }
    });
  }

  void showReformSnacks(lotid, String successMsg, String errorMsg) async {
    await startStopReform(lotid).then((_) {
      if (deleted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(successMsg),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('OK'))
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 12),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(errorMsg),
                TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                    child: const Text('OK'))
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    lotsData = Provider.of<SettingsAppsProvider>(context).getAllLots;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              margin: const EdgeInsets.only(bottom: 5),
              color: Colors.blue.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mes lots actifs",
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      Icon(MdiIcons.sitemapOutline, size: 73, color: Theme.of(context).primaryColor),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: deviceSize.height * 0.74,
              padding: const EdgeInsets.only(right: 3, left: 3),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : failedToFetch
                      ? Center(
                          child: FittedBox(
                            child: Column(
                              children: [
                                Text(
                                  'Failed to fetch',
                                  style: TextStyle(color: Colors.orange[900], fontSize: 16),
                                ),
                                TextButton(
                                    onPressed: () {
                                      fetchAllLots();
                                    },
                                    child: const Text("Actualiser"))
                              ],
                            ),
                          ),
                        )
                      : lotsData.isEmpty
                          ? Center(
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.sentiment_dissatisfied,
                                      size: 28,
                                      color: Colors.orange[600],
                                    ),
                                    Text(
                                      'Aucun lot actif trouvé',
                                      style: TextStyle(color: Colors.orange[900], fontSize: 16),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: AnimateList(
                                  interval: 50.ms,
                                  effects: [
                                    FadeEffect(
                                      duration: 100.ms,
                                    )
                                  ],
                                  children: lotsData.map(
                                    (lot) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        margin: const EdgeInsets.symmetric(vertical: 5),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueGrey, width: 0.5),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 17,
                                                color: Colors.green.shade700,
                                              ),
                                              Text(
                                                " ${lot.siteName}",
                                                overflow: TextOverflow.fade,
                                                style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                margin: const EdgeInsets.only(left: 5, right: 15),
                                                decoration: BoxDecoration(
                                                  color: Colors.amber.shade700,
                                                  borderRadius: BorderRadius.circular(60),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${lot.batimentName}",
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${lot.lotCode}",
                                                    style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "Age: ${lot.age}",
                                                    style: TextStyle(color: Colors.blueGrey.shade800, fontWeight: FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "ED: ${lot.edp}",
                                                    style: TextStyle(color: Colors.blueGrey.shade800),
                                                  ),
                                                  Text(
                                                    "EP: ${lot.ep ?? '-'}",
                                                    style: TextStyle(color: Colors.blueGrey.shade800),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: lot.deletable
                                                      ? Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (ctx) => AlertDialog(
                                                                      title: const Text(
                                                                        "Confimation",
                                                                        style: TextStyle(fontSize: 17, fontStyle: FontStyle.normal),
                                                                      ),
                                                                      content: Text("Etes-vous sûr que vous voulez supprimer ${lot.lotCode}"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(ctx).pop();
                                                                            },
                                                                            child: const Text("Annuler")),
                                                                        TextButton(
                                                                            onPressed: () {
                                                                              showSnacks(lot.lotId, "réussie", "erreur, vérifiez la connexion Internet et réessayez");
                                                                              Navigator.of(ctx).pop();
                                                                            },
                                                                            child: const Text("Supprimer", style: TextStyle(color: Colors.red))),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                icon: const Icon(
                                                                  Icons.delete,
                                                                  size: 40,
                                                                  color: Colors.redAccent,
                                                                )),
                                                            const Text("Supprimer")
                                                          ],
                                                        )
                                                      : Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            IconButton(
                                                                onPressed: () {
                                                                  showDialog(
                                                                    context: context,
                                                                    builder: (ctx) => AlertDialog(
                                                                      title: const Text(
                                                                        "Confimation",
                                                                        style: TextStyle(fontSize: 17, fontStyle: FontStyle.normal),
                                                                      ),
                                                                      content: Text("Etes-vous sûr que vous voulez réformer ${lot.lotCode}"),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(ctx).pop();
                                                                            },
                                                                            child: const Text("Annuler")),
                                                                        TextButton(
                                                                            onPressed: () {
                                                                              showReformSnacks(lot.lotId, lot.isReforming ? "La réforme est suspendu" : "La réforme a commencé", "Erreur, vérifiez la connexion Internet et réessayez");
                                                                              Navigator.of(ctx).pop();
                                                                            },
                                                                            child: const Text(
                                                                              "OK",
                                                                              style: TextStyle(color: Colors.red),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                icon: const Icon(
                                                                  Icons.play_circle,
                                                                  size: 40,
                                                                  color: Colors.redAccent,
                                                                )),
                                                            Text("Réforme")
                                                          ],
                                                        ),
                                                ),
                                              )
                                            ],
                                          )
                                        ]),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
