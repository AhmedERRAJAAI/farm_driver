import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sites_bats_provider.dart';
import '../screens/calendar_screen.dart';
import './production/select_sites.dart';
import './production/viability_post.dart';
import './production/production_post.dart';
import './production/conso_post.dart';
import './production/ambiance_post.dart';
import './production/constat_post.dart';

// SET INIT VALUE FOR THE INPUTS

class ProductionFrom extends StatefulWidget {
  const ProductionFrom({super.key});
  static const routeName = 'production-form/';

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  State<ProductionFrom> createState() => _ProductionFromState();
}

class _ProductionFromState extends State<ProductionFrom> {
  final prodFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isInit = true;
  bool failedToFetch = false;
  bool bastAreLoading = false;
  bool failedToFetchBats = false;
  bool prefilledAreLoading = false;
  bool failedToFetchPrefilled = false;
  bool repDataIsReady = false;

  @override
  void initState() {
    // isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchSites();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List sites = [];
  List bats = [];
  PrefilledProd preData =
      PrefilledProd(date: '-', closed: false, lotCode: '-', lastRepData: {
    'formule': '',
    'lumiere_alum': '00:00',
    'lumiere_extin': '00:00',
    'lightDuration': '00:00',
    'flash_alum': '00:00',
    'flash_extin': '00:00',
    'flashDuration': '00:00',
    'intensite': '',
    'intensIsLux': false,
    'coloration': 70,
    'qty_coquille': 3
  });

  void fetchSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchSites()
          .then((_) {
        setState(() {
          sites =
              Provider.of<SitesBatsProvider>(context, listen: false).sitesData;
          isLoading = false;
          failedToFetch = false;
        });
        fetchLots(sites[0].id);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  void fetchLots(site) async {
    setState(() {
      repDataIsReady = false;
      bastAreLoading = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchLots(site)
          .then((_) {
        setState(() {
          bats =
              Provider.of<SitesBatsProvider>(context, listen: false).lotsData;
          bastAreLoading = false;
          failedToFetchBats = false;
        });
        fetchPrefilled(bats[0].id);
      });
    } catch (e) {
      setState(() {
        bastAreLoading = false;
        failedToFetchBats = true;
      });
    }
  }

  void fetchPrefilled(batId) async {
    setState(() {
      prefilledAreLoading = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchPrefilledProdForm(batId)
          .then((_) {
        setState(() {
          prefilledAreLoading = false;
          failedToFetchPrefilled = false;
          preData = Provider.of<SitesBatsProvider>(context, listen: false)
              .prefilledCreateData;
          repDataIsReady = true;
          consoFormuleController.text = preData.lastRepData['formule'] ?? '';
        });
      });
    } catch (e) {
      setState(() {
        prefilledAreLoading = false;
        failedToFetchPrefilled = true;
      });
    }
  }

  // // DATA GATHERING SECTION
  late int selectedBat;
  String lightOn = '';
  String lightOff = '';
  String flashOn = '';
  String flashOff = '';
  String lightDuration = '';
  String flashDuration = '';
  double intensite = 0;
  bool intensIsLux = false;
  double tempExtMax = 0.0;
  double tempExtMin = 0.0;
  double tempIntMin = 0.0;
  double tempIntMax = 0.0;
  String observs = '';
  int eggColor = 0;
  int eggCoquille = 0;

  void lightOnGetter(TimeOfDay value) {
    lightOn = "${value.hour}h: ${value.minute}m";
  }

  void lightOffGetter(TimeOfDay value) {
    lightOff = "${value.hour}h: ${value.minute}m";
  }

  void flashOnGetter(TimeOfDay value) {
    flashOn = "${value.hour}h: ${value.minute}m";
  }

  void flashOffGetter(TimeOfDay value) {
    flashOff = "${value.hour}h: ${value.minute}m";
  }

  void lightDurGetter(TimeOfDay value) {
    lightDuration = "${value.hour}h: ${value.minute}m";
  }

  void flashDurGetter(TimeOfDay value) {
    flashDuration = "${value.hour}h: ${value.minute}m";
  }

  void intensiteGetter(double value) {
    intensite = value;
  }

  void intensiteUnitGetter(bool value) {
    intensIsLux = value;
  }

  void tempExtMaxGetter(double value) {
    tempExtMax = value;
  }

  void tempExtMinGetter(double value) {
    tempExtMin = value;
  }

  void tempIntMaxGetter(double value) {
    tempIntMax = value;
  }

  void tempIntMinGetter(double value) {
    tempIntMin = value;
  }

  void eggColorGetter(int value) {
    eggColor = value;
  }

  void eggCoquilleGetter(value) {
    eggCoquille = value;
  }

  void observsGetter(List value) {
    String res = '';
    for (int i = 0; i < value.length; i++) {
      res = "${value[i]['value']}/§£•/${value[i]['urg']}|@|$res";
    }
    observs = res;
  }

  void batGetter(value) {
    selectedBat = value;
  }

  void siteGetter(value) {}

  final TextEditingController mortController = TextEditingController();
  final TextEditingController sujetElimController = TextEditingController();
  final TextEditingController prodNormController = TextEditingController();
  final TextEditingController pmoController = TextEditingController();
  final TextEditingController prodDjController = TextEditingController();
  final TextEditingController prodBlancController = TextEditingController();
  final TextEditingController prodCasseController = TextEditingController();
  final TextEditingController prodFelesController = TextEditingController();
  final TextEditingController prodElimnController = TextEditingController();
  final TextEditingController consoAltController = TextEditingController();
  final TextEditingController consoEauController = TextEditingController();
  final TextEditingController consoFormuleController = TextEditingController();
  final TextEditingController poidsVifController = TextEditingController();
  final TextEditingController homogController = TextEditingController();

  Map repData = {};

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    sites = Provider.of<SitesBatsProvider>(context).sitesData;
    bats = Provider.of<SitesBatsProvider>(context).lotsData;
    bats = bats.where((obj) => obj.prod == true).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF145da0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.goToPage(context, CalendarScreen.routeName);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 24,
            ),
            color: const Color(0xFF145da0),
          ),
          const SizedBox(width: 10),
          PopupMenuButton(
            onSelected: (selectedVal) {},
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Ajouter un site"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text(
                    "Ajouter un lot"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
              )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
          child: Form(
              key: prodFormKey,
              child: Column(
                children: [
                  isLoading
                      ? SelectLoader(
                          deviceWidth: deviceSize.width,
                        )
                      : failedToFetch
                          ? AnimatedContainer(
                              width: deviceSize.width * 1,
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Border color
                                  width: 1.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(children: [
                                const Text("Failed to fetch sites"),
                                TextButton(
                                    onPressed: () {
                                      fetchSites();
                                    },
                                    child: Text("Refresh"))
                              ]),
                            )
                          : SelectSites(
                            selectName: 'site',
                              sites: sites,
                              fetch: fetchLots,
                              selectedVal: batGetter),
                  bastAreLoading
                      ? failedToFetchBats
                          ? Container(
                              width: deviceSize.width * 1,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Border color
                                  width: 1.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(children: [
                                const Text("Failed to fetch bats"),
                                TextButton(
                                    onPressed: () {
                                      fetchLots(sites[0].id);
                                    },
                                    child: const Text("Refresh"))
                              ]),
                            )
                          : SelectLoader(
                              deviceWidth: deviceSize.width,
                            )
                      : SelectSites(
                        selectName: 'bâtiment',
                          sites: bats,
                          fetch: fetchPrefilled,
                          selectedVal: siteGetter),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      margin: const EdgeInsets.only(bottom: 6),
                      height: 65,
                      width: deviceSize.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: deviceSize.width * 0.4,
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Date rapport: ',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      Text(
                                        preData.date,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: SizedBox(
                                    width: deviceSize.width * 0.4,
                                    child: Row(
                                      children: [
                                        const Text('Code lot: ',
                                            style: TextStyle(fontSize: 13)),
                                        Text(
                                          preData.lotCode,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (preData.closed)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red.shade300),
                                child: const Text(
                                  "remarque: report can't be filled now",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                          ]),
                    ),
                  ),
                  ViabilityPost(
                    closed: preData.closed,
                    mortController: mortController,
                    sujetElimController: sujetElimController,
                    postColor: Colors.deepPurple.shade400,
                  ),
                  ProductionPost(
                      closed: preData.closed,
                      prodNormController: prodNormController,
                      prodDjController: prodDjController,
                      prodBlancController: prodBlancController,
                      prodCasseController: prodCasseController,
                      prodFelesController: prodFelesController,
                      prodElimnController: prodElimnController,
                      pmoController: pmoController,
                      postColor: Color.fromARGB(255, 216, 100, 58)),
                  ConsoPost(
                      closed: preData.closed,
                      consoAltController: consoAltController,
                      consoEauController: consoEauController,
                      consoFormuleController: consoFormuleController,
                      postColor: Colors.green.shade700),
                  AmbiancePost(
                    ready: repDataIsReady,
                    prevData: preData.lastRepData,
                    closed: preData.closed,
                    tempExtMaxGetter: tempExtMaxGetter,
                    tempExtMinGetter: tempExtMinGetter,
                    tempIntMaxGetter: tempIntMaxGetter,
                    tempIntMinGetter: tempIntMinGetter,
                    intensiteGetter: intensiteGetter,
                    intensiteUnit: intensiteUnitGetter,
                    lOnGetter: lightOnGetter,
                    lOffGetter: lightOffGetter,
                    liDurGetter: lightDurGetter,
                    fOffGetter: flashOffGetter,
                    fOnGetter: flashOnGetter,
                    flDurGetter: flashDurGetter,
                    poidsVifController: poidsVifController,
                    homogController: homogController,
                    postColor: Colors.blue.shade300,
                  ),
                  ConstatPost(
                    closed: preData.closed,
                    postColor: Colors.yellow.shade700,
                    colorGetter: eggColorGetter,
                    coquilleGetter: eggCoquilleGetter,
                    observsGetter: observsGetter,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    width: deviceSize.width * 0.9,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 2,
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Envoyer  "),
                          Transform.rotate(
                            angle: -90 * 3.14159265359 / 180,
                            child: const Icon(
                              Icons.send,
                              size: 19,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (prodFormKey.currentState!.validate()) {
                          repData["prod_normal"] =
                              prodNormController.text.isEmpty
                                  ? 0
                                  : prodNormController.text;
                          repData["prod_dj"] = prodDjController.text.isEmpty
                              ? 0
                              : prodDjController.text;
                          repData["prod_blanc"] =
                              prodBlancController.text.isEmpty
                                  ? 0
                                  : prodBlancController.text;
                          repData["prod_casse"] =
                              prodCasseController.text.isEmpty
                                  ? 0
                                  : prodCasseController.text;
                          repData["prod_feles"] =
                              prodFelesController.text.isEmpty
                                  ? 0
                                  : prodFelesController.text;
                          repData["prod_elimne"] =
                              prodElimnController.text.isEmpty
                                  ? 0
                                  : prodElimnController.text;
                          repData["mort"] = mortController.text.isEmpty
                              ? 0
                              : mortController.text;
                          repData["hensEliminated"] =
                              sujetElimController.text.isEmpty
                                  ? 0
                                  : sujetElimController.text;
                          repData["alimentDist"] =
                              consoAltController.text.isEmpty
                                  ? 0
                                  : consoAltController.text;
                          repData["eauDist"] = consoEauController.text.isEmpty
                              ? 0
                              : consoEauController.text;
                          repData["formule"] =
                              consoFormuleController.text.isEmpty
                                  ? ""
                                  : consoFormuleController.text;
                          repData["pmo"] = pmoController.text.isEmpty
                              ? 0
                              : pmoController.text;
                          repData["poidVif"] = poidsVifController.text;
                          repData["homog"] = homogController.text.isEmpty
                              ? 0
                              : homogController.text;
                          repData["lightOn"] = lightOn;
                          repData["lightOff"] = lightOff;
                          repData["flashOn"] = flashOn;
                          repData["flashOff"] = flashOff;
                          repData["lightDuration"] = lightDuration;
                          repData["flashDuration"] = flashDuration;
                          repData["intensite"] = intensite;
                          repData["intensIsLux"] = intensIsLux;
                          repData["temperatureMin"] = tempIntMin;
                          repData["temperatureMax"] = tempIntMax;
                          repData["temperatureMinExt"] = tempExtMin;
                          repData["temperatureMaxExt"] = tempExtMax;
                          repData["coloration"] = eggColor;
                          repData["observ"] = observs;
                          repData["qty_shell"] = eggCoquille;
                          repData["batiment"] = selectedBat;
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Validation des données',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.grey.shade800)),
                              content: EnteredDataDisplay(data: repData),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Retour',
                                    style: TextStyle(
                                        color: Colors.amber.shade800,
                                        fontSize: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Confirmer',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  onPressed: () {
                                    // SEND DATA
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                        ;
                      },
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class EnteredDataDisplay extends StatelessWidget {
  final Map data;
  EnteredDataDisplay({required this.data});

  @override
  Widget build(BuildContext context) {
    print(data);
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Oeufs normaux: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_normal']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Oeufs Double jaune: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_dj']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Oeufs Blancs: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_blanc']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Oeufs cassés: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_casse']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Oeufs félés: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_feles']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Oeufs triés: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['prod_elimne']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'sujets mort: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['mort']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'sujets triés:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['hensEliminated']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Aliment distribué:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['alimentDist']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Eau distribué:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['eauDist']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Formule en place:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['formule']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Eau distribué:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['eauDist']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Poids moyen d\'oeuf:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['pmo']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Poids corporel: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['poidVif']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Homogéniété: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['homog']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Lumiere: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['lightDuration']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Flash: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['flashDuration']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Intensité: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['intensite']} ${data['intensIsLux'] ? 'Lux' : '%'}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Température min interne: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['temperatureMin']} °C")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Température max interne: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['temperatureMax']} °C")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Température min externe: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['temperatureMinExt']} °C")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Température max externe: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['temperatureMaxExt']} °C")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Coloration: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['coloration']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
        Row(
          children: [
            Text(
              'Coquille: ',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),
            Text("${data['qty_shell']}")
          ],
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
          height: 3,
        ),
      ],
    );
  }
}

class SelectLoader extends StatelessWidget {
  final double deviceWidth;
  SelectLoader({required this.deviceWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 6),
      height: 65,
      width: deviceWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}