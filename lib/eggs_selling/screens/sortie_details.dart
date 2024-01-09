import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';
import '../constants.dart';

class SortieDetailsScreen extends StatefulWidget {
  const SortieDetailsScreen({super.key});
  static const routeName = "operation-details/";

  @override
  State<SortieDetailsScreen> createState() => _SortieDetailsScreenState();
}

class _SortieDetailsScreenState extends State<SortieDetailsScreen> {
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
      getMouvementDetails(30);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getMouvementDetails(period) async {
    final operId = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchSortieDetails(id: operId["operation_id"]).then((_) {
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
    final operation = Provider.of<MouvementProvider>(context).operation;
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
          "Operation details",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (selectedVal) {},
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Télécharger PDF"),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: isLoading
              ? SizedBox(
                  height: deviceSize.height,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : requestFailed
                  ? SizedBox(
                      height: deviceSize.height,
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.refresh),
                        ),
                      ),
                    )
                  : Column(children: [
                      SizedBox(
                        height: 30,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(
                            children: [
                              Chip(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.symmetric(horizontal: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  label: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 17,
                                  )),
                              Text(
                                "Destinataire",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Text(operation!.client, style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
                      //  ===============
                      SizedBox(
                        height: 30,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(
                            children: [
                              Chip(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.symmetric(horizontal: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  label: Icon(
                                    MdiIcons.dotsGrid,
                                    color: Colors.white,
                                    size: 17,
                                  )),
                              Text(
                                "Quantité (oeuf)",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Text("${operation.qty}", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
                      //  ===============
                      SizedBox(
                        height: 30,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(
                            children: [
                              Chip(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.symmetric(horizontal: 7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  label: Icon(
                                    Icons.category,
                                    color: Colors.white,
                                    size: 17,
                                  )),
                              Text(
                                "Class",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Text(classOptions.where((element) => element.id == operation.eggClass).last.value, style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
                      // ===============
                      SizedBox(
                        height: 30,
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Row(
                            children: [
                              Chip(
                                  padding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.symmetric(horizontal: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  label: Icon(
                                    MdiIcons.cash,
                                    color: Colors.white,
                                    size: 20,
                                  )),
                              Text(
                                "Prix unitaire (DH)",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Text("${operation.pu} DH", style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
                      // ===============

                      OperationListItem(title: "Source", value: "${operation.batSource}", titleICon: MdiIcons.sourceBranch, listColor: Colors.yellow.shade800),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),

                      OperationListItem(title: "Date de livraison", value: "${operation.livDate}, ${operation.livTime}", titleICon: MdiIcons.clipboardTextClock, listColor: Colors.green.shade800),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),

                      OperationListItem(
                        title: "Immatriculation",
                        value: operation.immNbr != null ? "${operation.immNbr}-${immLetters[operation.immletter ?? 0]}-${operation.immCity}" : "-",
                        titleICon: MdiIcons.truckCargoContainer,
                        listColor: Colors.green.shade800,
                      ),

                      SizedBox(height: 15),
                      Text("Transporteur"),
                      OperationListItem(title: "Nom & Prenom", value: operation.driverfName != null ? "${operation.driverfName} ${operation.driverlName}" : "-", titleICon: Icons.person, listColor: Colors.green.shade800),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),

                      OperationListItem(title: "CIN du chauffeur", value: "${operation.driverCin}", titleICon: Icons.fact_check, listColor: Colors.green.shade800),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
                    ]),
        ),
      ),
    );
  }
}

class OperationListItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData titleICon;
  final Color listColor;
  const OperationListItem({
    super.key,
    required this.title,
    required this.value,
    required this.titleICon,
    required this.listColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Chip(
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                backgroundColor: listColor,
                label: Icon(
                  titleICon as IconData?,
                  // MdiIcons.cash,
                  color: Colors.white,
                  size: 20,
                )),
            Text(
              title,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.clip,
        ),
      ]),
    );
  }
}
