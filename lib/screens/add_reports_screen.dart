import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import '../providers/sites_bats_provider.dart';
import '../screens/calendar_screen.dart';
import '../forms/poussForm.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});
  static const routeName = 'add-report/';
  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _reportFormKey = GlobalKey<FormState>();

  bool _containsPouss = false;
  bool _pouss = false;
  bool _sitesEmpty = false;
  bool _viaIsExpanded = false;
  bool _constatIsExpanded = false;
  bool _ambianceIsExpanded = false;
  bool _prodIsExpanded = false;
  bool _consoIsExpanded = false;
  Map<int, Color> observUrgColors = {
    0: Colors.red,
    1: Colors.orange,
    2: Colors.green,
    3: Colors.blue,
  };
  int urgIndex = 3;
  int nbrOfObservs = 1;
  bool reportIsValid = false;

  List<Map> observs = [];

  bool _isInit = true;
  bool batsAreLoading = false;
  bool sendingReport = false;
  bool fetchFailed = false;

  Future<void> fetchBats(BuildContext context, int siteId) async {
    setState(() {
      batsAreLoading = true;
    });
    await Provider.of<SitesBatsProvider>(context, listen: false)
        .fetchLots(siteId)
        .then((_) {
      setState(() {
        batsAreLoading = false;
      });
    });
  }

  Future<void> saveReport(BuildContext context, report) async {
    setState(() {
      sendingReport = true;
    });
    await Provider.of<SitesBatsProvider>(context, listen: false)
        .sendReport(report)
        .then((_) {
      setState(() {
        sendingReport = false;
      });
    });
  }

  TimeOfDay calculateTimeDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final int startMinutes = startTime.hour * 60 + startTime.minute;
    final int endMinutes = endTime.hour * 60 + endTime.minute;
    late TimeOfDay duration;

    if (startMinutes < endMinutes) {
      final int durationMinutes = endMinutes - startMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else if (startMinutes > endMinutes) {
      final int durationMinutes = (24 * 60 - startMinutes) + endMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else {
      duration = TimeOfDay(hour: 0, minute: 0);
      // Same time, duration is 0.
    }
    return duration;
  }

  @override
  void initState() {
    batsAreLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final sites = Provider.of<SitesBatsProvider>(context).sitesData;
    if (sites.isEmpty) {
      _sitesEmpty = true;
      return;
    }
    if (_isInit) {
      setState(() {
        batsAreLoading = true;
      });
      Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchLots(sites[0].id)
          .then((_) {
        setState(() {
          batsAreLoading = false;
        });
      });
      Provider.of<SitesBatsProvider>(context, listen: false).fetchSites();

      if (sites[0].pouss) {
        setState(() {
          _containsPouss = true;
        });
      } else {
        setState(() {
          _containsPouss = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refetchSites(BuildContext context) async {
    await Provider.of<SitesBatsProvider>(context, listen: false).fetchSites();
    final tempSites = Provider.of<SitesBatsProvider>(context).sitesData;
    if (tempSites.isNotEmpty) {
      setState(() {
        _sitesEmpty = false;
      });
    }
  }

  String observMaker(List<Map> obsrs) {
    String res = '';
    for (int i = 0; i < obsrs.length; i++) {
      res = "${obsrs[i]['value']}/§£•/${obsrs[i]['urg']}|@|$res";
    }
    return res;
  }

// CONTROLLERS -------------------
  TimeOfDay lightOn = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay lightOff = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay lightDuration = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashOn = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashOff = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashDuration = TimeOfDay(hour: 00, minute: 00);
  double intensite = 0;

  final List<int> _coloration = [70, 80, 90, 100, 110];
  final List<int> _coquille = [1, 2, 3, 4, 5];

  double _tempMin = 0.0;
  double _tempMax = 0.0;
  double _tempExMin = 0.0;
  double _tempExMax = 0.0;

  int? selectedColoration = 70;
  int? selectedCoquille = 1;

  String observation = '';
  final TextEditingController _mortController = TextEditingController();
  final TextEditingController _sujetElimController = TextEditingController();
  final TextEditingController _prodNormController = TextEditingController();
  final TextEditingController _pmoController = TextEditingController();
  final TextEditingController _prodDjController = TextEditingController();
  final TextEditingController _prodBlancController = TextEditingController();
  final TextEditingController _prodCasseController = TextEditingController();
  final TextEditingController _prodFelesController = TextEditingController();
  final TextEditingController _prodElimnController = TextEditingController();
  final TextEditingController _consoAltController = TextEditingController();
  final TextEditingController _consoEauController = TextEditingController();
  final TextEditingController _consoFormuleController = TextEditingController();
  final TextEditingController _poidsVifController = TextEditingController();
  final TextEditingController _homogController = TextEditingController();
  final TextEditingController _tempObserv = TextEditingController();

  Map repData = {};

  void _onItemTapped(int index) {
    setState(() {
      _pouss = !_pouss;
    });
  }

  void isTherePouss(List sites, siteId) {
    for (int i = 0; i < sites.length; i++) {
      if (sites[i].id == siteId) {
        if (sites[i].pouss == true) {
          setState(() {
            _containsPouss = true;
          });
        } else {
          setState(() {
            _containsPouss = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sites = Provider.of<SitesBatsProvider>(context).sitesData;
    List allbats = Provider.of<SitesBatsProvider>(context).lotsData;
    List bats = allbats.where((obj) => obj.prod == true).toList();
    List pousBats = allbats.where((obj) => obj.prod == false).toList();
    String selectedSite = _sitesEmpty ? '' : sites[0].id.toString();
    String selectedBatiment = bats.isEmpty ? '' : bats[0].id.toString();

    final deviceSize = MediaQuery.of(context).size;
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
      
      
      body: _sitesEmpty
          ? Center(
              child: Column(
                children: [
                  const Text('No sites found'),
                  TextButton(
                    child: Text('refresh'),
                    onPressed: () {
                      _refetchSites;
                    },
                  )
                ],
              ),
            )
          : _pouss
              ? SingleChildScrollView(
                  child: PoussForm(
                  poussBats: pousBats,
                ))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
                    child: Form(
                      key: _reportFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              value: selectedSite,
                              items: sites.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option.id.toString(),
                                  child: Text(option.name.toString()),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedSite = newValue ?? '';
                                  fetchBats(context, int.parse(selectedSite));
                                });
                                isTherePouss(sites, int.parse(newValue ?? ''));
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'sélectionner un site',
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedBatiment.toString(),
                              items: bats.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option.id.toString(),
                                  child: Text(
                                      '(${option.batName}) ${option.code}'),
                                );
                              }).toList(),
                              onChanged: batsAreLoading
                                  ? null
                                  : (newValue) {
                                      setState(() {
                                        selectedBatiment = '$newValue';
                                      });
                                    },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'sélectionner un lot',
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            margin: EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: _viaIsExpanded
                                  ? Colors.white
                                  : Colors.deepPurple.shade400,
                              border: Border.all(
                                color:
                                    Colors.deepPurple.shade400, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            duration: const Duration(milliseconds: 300),
                            height: _viaIsExpanded
                                ? 180.0
                                : 80.0, // Change the height when expanded
                            child: _viaIsExpanded
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Viabilité',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .deepPurple.shade400,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.stream,
                                                    color: _viaIsExpanded
                                                        ? Colors
                                                            .deepPurple.shade400
                                                        : Colors.white,
                                                  )
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _viaIsExpanded =
                                                        !_viaIsExpanded;
                                                  });
                                                },
                                                child: Transform.rotate(
                                                  angle: _viaIsExpanded
                                                      ? 180 *
                                                          (3.14159265359 / 180)
                                                      : 0,
                                                  child: Icon(
                                                    Icons.expand_more,
                                                    color: Colors
                                                        .deepPurple.shade400,
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        Container(
                                          height: deviceSize.height * 0.05,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: TextFormField(
                                              controller: _mortController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Field cannot be empty';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                border:
                                                    const OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors
                                                          .deepPurple.shade400),
                                                ),
                                                labelText:
                                                    'Nombre de mortalité',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        Container(
                                          height: deviceSize.height * 0.05,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: TextFormField(
                                              controller: _sujetElimController,
                                              decoration: const InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 6),
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    width: 1,
                                                  ),
                                                ),
                                                // fillColor: Colors.red,
                                                labelText: 'Sujets éliminées',
                                                // labelStyle: TextStyle(color: Colors.red),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Viabilité',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: _viaIsExpanded
                                                        ? Colors
                                                            .deepPurple.shade400
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.stream,
                                                  color: _viaIsExpanded
                                                      ? Colors
                                                          .deepPurple.shade400
                                                      : Colors.white,
                                                )
                                              ],
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _viaIsExpanded =
                                                      !_viaIsExpanded;
                                                });
                                              },
                                              child: Transform.rotate(
                                                angle: _viaIsExpanded
                                                    ? 180 *
                                                        (3.14159265359 / 180)
                                                    : 0,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: _viaIsExpanded
                                                      ? Colors
                                                          .deepPurple.shade400
                                                      : Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          AnimatedContainer(
                            margin: EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: _prodIsExpanded
                                  ? Colors.white
                                  : const Color(0xFFB95E0E),
                              border: Border.all(
                                color: const Color(0xFFB95E0E), // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            duration: const Duration(milliseconds: 300),
                            height: _prodIsExpanded
                                ? 290.0
                                : 80.0, // Change the height when expanded
                            child: _prodIsExpanded
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Production',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _prodIsExpanded
                                                          ? const Color(
                                                              0xFFB95E0E)
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.egg,
                                                    color: _prodIsExpanded
                                                        ? const Color(
                                                            0xFFB95E0E)
                                                        : Colors.white,
                                                  )
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _prodIsExpanded =
                                                        !_prodIsExpanded;
                                                  });
                                                },
                                                child: Transform.rotate(
                                                  angle: _prodIsExpanded
                                                      ? 180 *
                                                          (3.14159265359 / 180)
                                                      : 0,
                                                  child: const Icon(
                                                    Icons.expand_more,
                                                    color: Color(0xFFB95E0E),
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: Center(
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            _prodNormController,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Normaux'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: TextFormField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller:
                                                          _prodDjController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Double jaunes'),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: Center(
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            _prodBlancController,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Blancs'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: TextFormField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller:
                                                          _prodCasseController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Cassés'),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: Center(
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            _prodFelesController,
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    'Félés'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: TextFormField(
                                                      controller:
                                                          _prodElimnController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Éliminées'),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                height:
                                                    deviceSize.height * 0.06,
                                                child: Center(
                                                  child: TextFormField(
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    controller: _pmoController,
                                                    decoration: const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "poids moyen d'oeuf"),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Production',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: _prodIsExpanded
                                                        ? const Color(
                                                            0xFFB95E0E)
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.egg,
                                                  color: _prodIsExpanded
                                                      ? const Color(0xFFB95E0E)
                                                      : Colors.white,
                                                )
                                              ],
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _prodIsExpanded =
                                                      !_prodIsExpanded;
                                                });
                                              },
                                              child: Transform.rotate(
                                                angle: _prodIsExpanded
                                                    ? 180 *
                                                        (3.14159265359 / 180)
                                                    : 0,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: _prodIsExpanded
                                                      ? const Color(0xFFB95E0E)
                                                      : Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          AnimatedContainer(
                            margin: EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: _consoIsExpanded
                                  ? Colors.white
                                  : Colors.green.shade700,
                              border: Border.all(
                                color: Colors.green.shade700, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            duration: const Duration(milliseconds: 300),
                            height: _consoIsExpanded
                                ? 200.0
                                : 80.0, // Change the height when expanded
                            child: _consoIsExpanded
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Consommation',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.green.shade700,
                                                    ),
                                                  ),
                                                  Icon(
                                                    MdiIcons.barley,
                                                    color: _consoIsExpanded
                                                        ? Colors.white
                                                        : Colors.green.shade700,
                                                  )
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _consoIsExpanded =
                                                        !_consoIsExpanded;
                                                  });
                                                },
                                                child: Transform.rotate(
                                                  angle: _consoIsExpanded
                                                      ? 180 *
                                                          (3.14159265359 / 180)
                                                      : 0,
                                                  child: Icon(
                                                    Icons.expand_more,
                                                    color:
                                                        Colors.green.shade700,
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 6.0),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: Center(
                                                      child: TextFormField(
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        controller:
                                                            _consoAltController,
                                                        decoration: const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Aliment (kg)'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.06,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: TextFormField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      controller:
                                                          _consoEauController,
                                                      decoration:
                                                          const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              labelText:
                                                                  'Eau (litre)'),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              SizedBox(
                                                height:
                                                    deviceSize.height * 0.06,
                                                // width: deviceSize.width * 0.43,
                                                child: Center(
                                                  child: TextFormField(
                                                    controller:
                                                        _consoFormuleController,
                                                    decoration: const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            'Formule en place'),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Consommation',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: _consoIsExpanded
                                                        ? Colors.green.shade700
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  MdiIcons.barley,
                                                  color: _consoIsExpanded
                                                      ? Colors.green.shade700
                                                      : Colors.white,
                                                )
                                              ],
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _consoIsExpanded =
                                                      !_consoIsExpanded;
                                                });
                                              },
                                              child: Transform.rotate(
                                                angle: _consoIsExpanded
                                                    ? 180 *
                                                        (3.14159265359 / 180)
                                                    : 0,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: _consoIsExpanded
                                                      ? Colors.green.shade700
                                                      : Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          AnimatedContainer(
                            margin: EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: _ambianceIsExpanded
                                  ? Colors.white
                                  : Colors.blue.shade300,
                              border: Border.all(
                                color: Colors.blue.shade300, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            duration: const Duration(milliseconds: 300),
                            height: _ambianceIsExpanded
                                ? 400.0
                                : 80.0, // Change the height when expanded
                            child: _ambianceIsExpanded
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Ambiance',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.blue.shade300,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.sentiment_satisfied,
                                                    color: _ambianceIsExpanded
                                                        ? Colors.blue.shade300
                                                        : Colors.white,
                                                  )
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _ambianceIsExpanded =
                                                        !_ambianceIsExpanded;
                                                  });
                                                },
                                                child: Transform.rotate(
                                                  angle: _ambianceIsExpanded
                                                      ? 180 *
                                                          (3.14159265359 / 180)
                                                      : 0,
                                                  child: Icon(
                                                    Icons.expand_more,
                                                    color:
                                                        Colors.green.shade700,
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.4,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        TimeOfDay? newTime =
                                                            await showTimePicker(
                                                          context: context,
                                                          cancelText: 'Annuler',
                                                          initialTime:
                                                              lightDuration,
                                                          initialEntryMode:
                                                              TimePickerEntryMode
                                                                  .inputOnly,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      alwaysUse24HourFormat:
                                                                          true),
                                                              child: child ??
                                                                  Text(''),
                                                            );
                                                          },
                                                        );
                                                        if (newTime == null)
                                                          return;
                                                        setState(() {
                                                          lightOn = TimeOfDay(
                                                              hour: 00,
                                                              minute: 00);
                                                          lightOff = TimeOfDay(
                                                              hour: 00,
                                                              minute: 00);
                                                          lightDuration =
                                                              newTime;
                                                        });
                                                      },
                                                      child: FittedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            const Text(
                                                                'Lumiére'),
                                                            const Icon(Icons
                                                                .timelapse_sharp),
                                                            Text(
                                                                "${lightDuration.hour}h: ${lightDuration.minute}m")
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.2,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        TimeOfDay? newTime =
                                                            await showTimePicker(
                                                          cancelText: 'Annuler',
                                                          context: context,
                                                          initialTime: lightOn,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      alwaysUse24HourFormat:
                                                                          true),
                                                              child: child ??
                                                                  Text(''),
                                                            );
                                                          },
                                                        );
                                                        if (newTime == null)
                                                          return;
                                                        setState(() {
                                                          lightOn = newTime;
                                                          lightDuration =
                                                              calculateTimeDuration(
                                                                  lightOn,
                                                                  lightOff);
                                                        });
                                                      },
                                                      child: FittedBox(
                                                        child: Text(
                                                            'ON: ${lightOn.hour}:${lightOn.minute}'),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.2,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        TimeOfDay? newTime =
                                                            await showTimePicker(
                                                          cancelText: 'Annuler',
                                                          context: context,
                                                          initialTime: lightOff,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      alwaysUse24HourFormat:
                                                                          true),
                                                              child: child ??
                                                                  Text(''),
                                                            );
                                                          },
                                                        );
                                                        if (newTime == null)
                                                          return;

                                                        setState(() {
                                                          lightOff = newTime;
                                                          lightDuration =
                                                              calculateTimeDuration(
                                                                  lightOn,
                                                                  lightOff);
                                                        });
                                                      },
                                                      child: FittedBox(
                                                        child: Text(
                                                            'OFF: ${lightOff.hour}:${lightOff.minute}'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.4,
                                                    child: OutlinedButton(
                                                        onPressed: () async {
                                                          TimeOfDay? newTime =
                                                              await showTimePicker(
                                                            context: context,
                                                            cancelText:
                                                                'Annuler',
                                                            initialTime:
                                                                flashDuration,
                                                            initialEntryMode:
                                                                TimePickerEntryMode
                                                                    .inputOnly,
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget?
                                                                        child) {
                                                              return MediaQuery(
                                                                data: MediaQuery.of(
                                                                        context)
                                                                    .copyWith(
                                                                        alwaysUse24HourFormat:
                                                                            true),
                                                                child: child ??
                                                                    Text(''),
                                                              );
                                                            },
                                                          );
                                                          if (newTime == null)
                                                            return;
                                                          setState(() {
                                                            flashOn = TimeOfDay(
                                                                hour: 00,
                                                                minute: 00);
                                                            flashOff =
                                                                TimeOfDay(
                                                                    hour: 00,
                                                                    minute: 00);
                                                            flashDuration =
                                                                newTime;
                                                          });
                                                        },
                                                        child: FittedBox(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              const Text(
                                                                  'Flash'),
                                                              const Icon(Icons
                                                                  .timelapse_sharp),
                                                              Text(
                                                                  "${flashDuration.hour}h: ${flashDuration.minute}m")
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.2,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        TimeOfDay? newTime =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: flashOn,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      alwaysUse24HourFormat:
                                                                          true),
                                                              child: child ??
                                                                  Text(''),
                                                            );
                                                          },
                                                        );
                                                        if (newTime == null)
                                                          return;
                                                        setState(() {
                                                          flashOn = newTime;
                                                          flashDuration =
                                                              calculateTimeDuration(
                                                                  flashOn,
                                                                  flashOff);
                                                        });
                                                      },
                                                      child: FittedBox(
                                                        child: Text(
                                                            'ON: ${flashOn.hour}:${flashOn.minute}'),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.2,
                                                    child: OutlinedButton(
                                                      onPressed: () async {
                                                        TimeOfDay? newTime =
                                                            await showTimePicker(
                                                          context: context,
                                                          initialTime: flashOff,
                                                          builder: (BuildContext
                                                                  context,
                                                              Widget? child) {
                                                            return MediaQuery(
                                                              data: MediaQuery.of(
                                                                      context)
                                                                  .copyWith(
                                                                      alwaysUse24HourFormat:
                                                                          true),
                                                              child: child ??
                                                                  Text(''),
                                                            );
                                                          },
                                                        );
                                                        if (newTime == null)
                                                          return;
                                                        setState(() {
                                                          flashOff = newTime;
                                                          flashDuration =
                                                              calculateTimeDuration(
                                                                  flashOn,
                                                                  flashOff);
                                                        });
                                                      },
                                                      child: FittedBox(
                                                        child: Text(
                                                            'OFF: ${flashOff.hour}:${flashOff.minute}'),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const FittedBox(
                                                      child: Text('Intensité')),
                                                  Expanded(
                                                    child: SizedBox(
                                                      height:
                                                          deviceSize.height *
                                                              0.05,
                                                      child: Center(
                                                        child: Slider.adaptive(
                                                          activeColor: Colors
                                                              .yellow.shade700,
                                                          value: intensite,
                                                          max: 100,
                                                          min: 0,
                                                          divisions: 20,
                                                          label: intensite
                                                              .round()
                                                              .toString(),
                                                          onChanged:
                                                              (double value) {
                                                            setState(() {
                                                              intensite = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  FittedBox(
                                                      child: Text(
                                                    intensite
                                                        .toStringAsFixed(0),
                                                  )),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.46,
                                                    child: Center(
                                                      child: TextFormField(
                                                        controller:
                                                            _poidsVifController,
                                                        decoration: const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            6,
                                                                        vertical:
                                                                            0),
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Poids corporel'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return '';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: deviceSize.height *
                                                        0.05,
                                                    width:
                                                        deviceSize.width * 0.44,
                                                    child: Center(
                                                      child: TextFormField(
                                                        controller:
                                                            _homogController,
                                                        decoration: const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            6,
                                                                        vertical:
                                                                            0),
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                'Homogéniété'),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'cant be empty';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 7),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      width: deviceSize.width *
                                                          0.46,
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                              'Temperature intérieur'),
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder:
                                                                      ((ctx) =>
                                                                          NumberPickerDialog(
                                                                            initialValue:
                                                                                _tempMin, // Pass initial value
                                                                            onChanged:
                                                                                (value) {
                                                                              // Update _coloration when the value changes
                                                                              setState(() {
                                                                                _tempMin = value;
                                                                              });
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                              child: FittedBox(
                                                                child: Text(
                                                                    'Min $_tempMin'),
                                                              )),
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder:
                                                                      ((ctx) =>
                                                                          NumberPickerDialog(
                                                                            initialValue:
                                                                                _tempMax, // Pass initial value
                                                                            onChanged:
                                                                                (value) {
                                                                              // Update _coloration when the value changes
                                                                              setState(() {
                                                                                _tempMax = value;
                                                                              });
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                              child: FittedBox(
                                                                child: Text(
                                                                    'Max $_tempMax'),
                                                              )),
                                                        ],
                                                      )),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      width: deviceSize.width *
                                                          0.46,
                                                      child: Column(
                                                        children: [
                                                          const Text(
                                                              'Temperature extérieure'),
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder:
                                                                      ((ctx) =>
                                                                          NumberPickerDialog(
                                                                            initialValue:
                                                                                _tempExMin, // Pass initial value
                                                                            onChanged:
                                                                                (value) {
                                                                              // Update _coloration when the value changes
                                                                              setState(() {
                                                                                _tempExMin = value;
                                                                              });
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                              child: FittedBox(
                                                                child: Text(
                                                                    'Min $_tempExMin'),
                                                              )),
                                                          OutlinedButton(
                                                              onPressed: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder:
                                                                      ((ctx) =>
                                                                          NumberPickerDialog(
                                                                            initialValue:
                                                                                _tempExMax, // Pass initial value
                                                                            onChanged:
                                                                                (value) {
                                                                              // Update _coloration when the value changes
                                                                              setState(() {
                                                                                _tempExMax = value;
                                                                              });
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                              child: FittedBox(
                                                                child: Text(
                                                                    'Max $_tempExMax'),
                                                              )),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Ambiance',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: _ambianceIsExpanded
                                                        ? Colors.blue.shade300
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.sentiment_satisfied,
                                                  color: _ambianceIsExpanded
                                                      ? Colors.blue.shade300
                                                      : Colors.white,
                                                )
                                              ],
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _ambianceIsExpanded =
                                                      !_ambianceIsExpanded;
                                                });
                                              },
                                              child: Transform.rotate(
                                                angle: _ambianceIsExpanded
                                                    ? 180 *
                                                        (3.14159265359 / 180)
                                                    : 0,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: _ambianceIsExpanded
                                                      ? Colors.blue.shade300
                                                      : Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          AnimatedContainer(
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: _constatIsExpanded
                                  ? Colors.white
                                  : Colors.yellow.shade700,
                              border: Border.all(
                                color: Colors.yellow.shade700, // Border color
                                width: 1.0, // Border width
                              ),
                              borderRadius:
                                  BorderRadius.circular(8.0), // Border radius
                            ),
                            duration: const Duration(milliseconds: 300),
                            height: _constatIsExpanded
                                ? 240.0
                                : 80.0, // Change the height when expanded
                            child: _constatIsExpanded
                                ? SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Constats',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .yellow.shade700,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.visibility,
                                                    color: _constatIsExpanded
                                                        ? Colors.yellow.shade700
                                                        : Colors.white,
                                                  )
                                                ],
                                              ),
                                              OutlinedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _constatIsExpanded =
                                                        !_constatIsExpanded;
                                                  });
                                                },
                                                child: Transform.rotate(
                                                  angle: _constatIsExpanded
                                                      ? 180 *
                                                          (3.14159265359 / 180)
                                                      : 0,
                                                  child: Icon(
                                                    Icons.expand_more,
                                                    color:
                                                        Colors.yellow.shade700,
                                                    size: 26,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: deviceSize.width * 0.43,
                                              padding: EdgeInsets.only(left: 6),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors
                                                      .grey, // Border color
                                                  width: 1.0, // Border width
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0), // Border radius
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                dropdownColor: Colors.white,
                                                value:
                                                    _coloration[0].toString(),
                                                items:
                                                    _coloration.map((option) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: option.toString(),
                                                    child:
                                                        Text(option.toString()),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedColoration =
                                                        int.parse('$newValue');
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText:
                                                      "Coloration d'oeuf",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: deviceSize.width * 0.43,
                                              padding: EdgeInsets.only(left: 6),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors
                                                      .grey, // Border color
                                                  width: 1.0, // Border width
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0), // Border radius
                                              ),
                                              child: DropdownButtonFormField<
                                                  String>(
                                                dropdownColor: Colors.white,
                                                value: _coquille[0].toString(),
                                                items: _coquille.map((option) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: option.toString(),
                                                    child: Row(children: [
                                                      for (int i = 0;
                                                          i < option;
                                                          i++)
                                                        const Icon(Icons.star,
                                                            color: Colors.blue,
                                                            size: 15),
                                                    ]),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedCoquille =
                                                        int.parse('$newValue');
                                                  });
                                                },
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  labelText:
                                                      "Qualité de coquille",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          // height: deviceSize.height * 0.05,
                                          margin: EdgeInsets.only(top: 10),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width:
                                                      deviceSize.width * 0.65,
                                                  child: TextFormField(
                                                    controller: _tempObserv,
                                                    decoration: const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        0),
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Observation"),
                                                    keyboardType:
                                                        TextInputType.text,
                                                  ),
                                                ),
                                                Container(
                                                  height: 38,
                                                  width: 38,
                                                  decoration: BoxDecoration(
                                                    color: observUrgColors[
                                                            urgIndex] ??
                                                        Colors.blue,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: observUrgColors[
                                                              urgIndex] ??
                                                          Colors.blue,
                                                      width:
                                                          2.0, // Set the border width
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        urgIndex = urgIndex + 1;
                                                        if (urgIndex > 3) {
                                                          urgIndex = 0;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    if (_tempObserv
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        observs.add({
                                                          'urg': urgIndex,
                                                          'value':
                                                              _tempObserv.text
                                                        });
                                                        _tempObserv.text = '';
                                                      });
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    size: 32,
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                            children: observs.map((obsrv) {
                                          return Container(
                                              padding: EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: observUrgColors[
                                                              obsrv['urg']] ??
                                                          Colors.blue),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 2),
                                              width: deviceSize.width * 0.9,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        deviceSize.width * 0.7,
                                                    child: Text(
                                                        '${obsrv['value']}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            overflow:
                                                                TextOverflow
                                                                    .clip)),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          observs.removeWhere(
                                                              (ele) =>
                                                                  ele['value'] ==
                                                                  obsrv[
                                                                      'value']);
                                                        });
                                                      },
                                                      icon: Icon(
                                                          Icons.remove_circle,
                                                          color: Colors.red,
                                                          size: 23))
                                                ],
                                              ));
                                        }).toList())
                                      ],
                                    ),
                                  )
                                : Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Constats',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: _constatIsExpanded
                                                        ? Colors.yellow.shade700
                                                        : Colors.white,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.visibility,
                                                  color: _constatIsExpanded
                                                      ? Colors.yellow.shade700
                                                      : Colors.white,
                                                )
                                              ],
                                            ),
                                            OutlinedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _constatIsExpanded =
                                                      !_constatIsExpanded;
                                                });
                                              },
                                              child: Transform.rotate(
                                                angle: _constatIsExpanded
                                                    ? 180 *
                                                        (3.14159265359 / 180)
                                                    : 0,
                                                child: Icon(
                                                  Icons.expand_more,
                                                  color: _constatIsExpanded
                                                      ? Colors.yellow.shade700
                                                      : Colors.white,
                                                  size: 26,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              Container(
                                width: deviceSize.width,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: deviceSize.width * 0.8,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade300,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            observation = observMaker(observs);
                                          });
                                          saveReport(context, repData);
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                duration:
                                                    const Duration(seconds: 4),
                                                content: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                        'Processing Data'),
                                                    sendingReport
                                                        ? const CircularProgressIndicator()
                                                        : const Text('Done')
                                                  ],
                                                )),
                                          );
                                        },
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'envoyer',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                              SizedBox(width: 6),
                                              Icon(Icons.ios_share,
                                                  color: Colors.white, size: 20)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade300,
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(5),
                                            topRight: Radius.circular(5),
                                          ),
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                reportIsValid = false;
                                              });
                                            },
                                            child: const Center(
                                                child: Text("Anuller",
                                                    style: TextStyle(
                                                        color: Colors.white)))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: reportIsValid ? 0 : deviceSize.width,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF3F3F3),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(5)),
                                child: FittedBox(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      if (_reportFormKey.currentState!
                                          .validate()) {
                                        repData["prod_normal"] =
                                            _prodNormController.text;
                                        repData["prod_dj"] =
                                            _prodDjController.text;
                                        repData["prod_blanc"] =
                                            _prodBlancController.text;
                                        repData["prod_casse"] =
                                            _prodCasseController.text;
                                        repData["prod_feles"] =
                                            _prodFelesController.text;
                                        repData["prod_elimne"] =
                                            _prodElimnController.text;
                                        repData["mort"] = _mortController.text;
                                        repData["hensEliminated"] =
                                            _sujetElimController.text;
                                        repData["alimentDist"] =
                                            _consoAltController.text;
                                        repData["eauDist"] =
                                            _consoEauController.text;
                                        repData["formule"] =
                                            _consoFormuleController.text;
                                        repData["pmo"] = _pmoController.text;
                                        repData["poidVif"] =
                                            _poidsVifController.text;
                                        repData["homog"] =
                                            _homogController.text;
                                        repData["lightOn"] =
                                            "${lightOn.hour}:${lightOn.minute}";
                                        repData["lightOff"] =
                                            "${lightOff.hour}:${lightOff.minute}";
                                        repData["flashOn"] =
                                            "${flashOn.hour}:${flashOn.minute}";
                                        repData["flashOff"] =
                                            "${flashOff.hour}:${flashOff.minute}";
                                        repData["lightDuration"] =
                                            "${lightDuration.hour}:${lightDuration.minute}";
                                        repData["flashDuration"] =
                                            "${flashDuration.hour}:${flashDuration.minute}";
                                        repData["intensite"] = intensite;
                                        repData["temperatureMin"] = _tempMin;
                                        repData["temperatureMax"] = _tempMax;
                                        repData["temperatureMinExt"] =
                                            _tempExMin;
                                        repData["temperatureMaxExt"] =
                                            _tempExMax;
                                        repData["coloration"] =
                                            selectedColoration;
                                        repData["observ"] = observation;
                                        repData["qty_shell"] = selectedCoquille;
                                        repData["batiment"] = selectedBatiment;

                                        setState(() {
                                          reportIsValid = true;
                                        });
                                      }
                                    },
                                    child: const Text('Envoyer les données ?',
                                        style: TextStyle(fontSize: 11)),
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
      bottomNavigationBar: _containsPouss
          ? NavigationBar(
              height: deviceSize.height * 0.08,
              backgroundColor: Colors.white,
              elevation: 10,
              destinations: const <Widget>[
                NavigationDestination(
                  icon: Icon(Icons.egg),
                  label: 'Production',
                ),
                NavigationDestination(
                  icon: Icon(Icons.workspaces),
                  label: 'Poussiniere',
                ),
              ],
              selectedIndex: _pouss ? 1 : 0,
              indicatorColor: Colors.amber[800],
              onDestinationSelected: _onItemTapped,
            )
          : null,
    );
  }
}

class NumberPickerDialog extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;

  NumberPickerDialog({required this.initialValue, required this.onChanged});

  @override
  _NumberPickerDialogState createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  double _coloration = 0.0;

  @override
  void initState() {
    super.initState();
    _coloration = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: DecimalNumberPicker(
        haptics: true,
        axis: Axis.horizontal,
        value: _coloration,
        minValue: -20,
        maxValue: 60,
        decimalPlaces: 1,
        textStyle: TextStyle(color: Colors.blue),
        onChanged: (value) {
          setState(() {
            _coloration = value;
          });
          widget.onChanged(value); // Notify the parent about the change
        },
      ),
    );
  }
}
