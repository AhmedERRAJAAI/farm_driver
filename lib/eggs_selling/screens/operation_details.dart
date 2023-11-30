import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';

class OperationDetailsScreen extends StatefulWidget {
  const OperationDetailsScreen({super.key});
  static const routeName = "operation-details/";

  @override
  State<OperationDetailsScreen> createState() => _OperationDetailsScreenState();
}

class _OperationDetailsScreenState extends State<OperationDetailsScreen> {
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
    final clientObj = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchMouvments(count: 100, isEntree: false).then((_) {
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
    final clientObj = ModalRoute.of(context)!.settings.arguments as Map;
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
          child: Column(children: [
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
                Text("AHMED ERRAJAAI", style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text("Normaux", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("1200000", style: TextStyle(fontWeight: FontWeight.bold)),
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
                      "Prix (MAD)",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                Chip(
                    label: Row(
                  children: [
                    Text("PU= "),
                    Text("1.20")
                  ],
                )),
                Text("189276", style: TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            // ===============

            OperationListItem(title: "Source", value: "TIFLET (T1)", titleICon: MdiIcons.sourceBranch, listColor: Colors.yellow.shade800),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            OperationListItem(title: "Stock initial", value: "40000", titleICon: MdiIcons.warehouse, listColor: Colors.yellow.shade800),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            OperationListItem(title: "Stock final", value: "1200", titleICon: MdiIcons.warehouse, listColor: Colors.yellow.shade800),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            OperationListItem(title: "Date de livraison", value: "27/10/2023, 12:30", titleICon: MdiIcons.clipboardTextClock, listColor: Colors.green.shade800),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            OperationListItem(title: "Immatriculation", value: "2344099-ا", titleICon: MdiIcons.truckCargoContainer, listColor: Colors.green.shade800),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0), child: Divider()),
            SizedBox(
              height: 20,
            ),
            // Center(
            //   child: Container(
            //       height: 55,
            //       width: deviceSize.width * 0.45,
            //       decoration: BoxDecoration(
            //         // border: Border.all(width: 1, color: Colors.purple.shade300),
            //         color: Colors.orange.shade600,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: Icon(
            //         Icons.ios_share,
            //         color: Colors.white,
            //         size: 23,
            //       )),
            // )
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
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
