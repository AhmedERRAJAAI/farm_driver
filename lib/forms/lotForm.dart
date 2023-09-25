import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'production/selects.dart';
import '../screens/calendar_screen.dart';
import '../providers/sites_bats_provider.dart';
import 'helpers/Signal_problem.dart';

class LotForm extends StatefulWidget {
  const LotForm({super.key});
  static const routeName = 'lot-form/';
  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  State<LotForm> createState() => _LotFormState();
}

class _LotFormState extends State<LotForm> {
  final lotFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isInit = true;
  bool failedToFetch = false;
  bool bastAreLoading = false;
  bool failedToFetchBats = false;
  bool prefilledAreLoading = false;
  List sites = [];
  List bats = [];
  List guides = [];

  bool creatingLot = false;
  bool created = false;
  bool msgDisplayed = true;

  // Future<void> displayMsg(int seconds) async {
  //   await Future.delayed(Duration(seconds: seconds));
  //   setState(() {
  //     msgDisplayed = false;
  //   });
  //   // ignore: use_build_context_synchronously
  //   widget.goToPage(context, CalendarScreen.routeName);
  // }

  Future<void> createLot(BuildContext context, data) async {
    setState(() {
      creatingLot = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false).createLot(data).then((_) {
        setState(() {
          creatingLot = false;
          created = true;
        });
      });
    } catch (e) {
      setState(() {
        creatingLot = false;
        created = false;
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
    if (_isInit) {
      fetchSites();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false).fetchSites().then((_) {
        setState(() {
          sites = Provider.of<SitesBatsProvider>(context, listen: false).sitesData;
          isLoading = false;
          failedToFetch = false;
        });
        fetchAllBats(sites[0].id);
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  void fetchAllBats(site) async {
    setState(() {
      bastAreLoading = true;
    });
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false).fetchAllBats(site).then((_) {
        setState(() {
          bats = Provider.of<SitesBatsProvider>(context, listen: false).batsGetter;
          bastAreLoading = false;
          failedToFetchBats = false;
        });
        fetchGuides(0);
      });
    } catch (e) {
      setState(() {
        bastAreLoading = false;
        failedToFetchBats = true;
      });
    }
  }

  void fetchGuides(_) async {
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false).fetchActiveGuides().then((_) {
        setState(() {
          guides = Provider.of<SitesBatsProvider>(context, listen: false).getGuides;
        });
      });
    } catch (e) {
      setState(() {});
    }
  }

  void placeholder(value) {}

  String birthdate = '';
  String transfertDate = '';
  bool dateError = false;

  void _presentBirthDateDatePicker() {
    showDatePicker(context: context, initialDate: DateTime.parse(birthdate != '' ? birthdate : '${DateTime.now()}'), firstDate: DateTime(2022), lastDate: DateTime.now()).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        if (transfertDate.isNotEmpty) {
          final trsftDate = DateTime.parse(transfertDate);
          final bthDate = DateTime.parse(formatDateTime(value));
          if (bthDate.isBefore(trsftDate) || bthDate.isAtSameMomentAs(trsftDate)) {
            birthdate = formatDateTime(value);
            dateError = false;
          } else {
            birthdate = formatDateTime(value);
            dateError = true;
          }
        } else {
          birthdate = formatDateTime(value);
        }
      });
    });
  }

  void _presentTransfertDatePicker() {
    showDatePicker(context: context, initialDate: DateTime.parse(transfertDate != '' ? transfertDate : '${DateTime.now()}'), firstDate: DateTime(2022), lastDate: DateTime.now()).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        dateError = false;
        if (birthdate.isNotEmpty) {
          final bthDate = DateTime.parse(birthdate);
          final trsftDate = DateTime.parse(formatDateTime(value));
          if (bthDate.isBefore(trsftDate) || bthDate.isAtSameMomentAs(trsftDate)) {
            transfertDate = formatDateTime(value);
            dateError = false;
          } else {
            transfertDate = formatDateTime(value);
            dateError = true;
          }
        } else {
          transfertDate = formatDateTime(value);
        }
      });
    });
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  String formatDate(String inputDate) {
    if (inputDate == '') {
      return '';
    }
    DateTime dateTime = DateTime.parse(inputDate);
    String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year.toString()}";
    return formattedDate;
  }

  bool compareDates(String date1, String date2) {
    final dateTime1 = DateTime.parse(date1);
    final dateTime2 = DateTime.parse(date2);
    return dateTime1.isBefore(dateTime2) || dateTime1.isAtSameMomentAs(dateTime2);
  }

  bool isWeekly = false;
  bool gotErrors = false;

  // DATA GATHERING
  final TextEditingController lotCodeController = TextEditingController();
  final TextEditingController effectifDpController = TextEditingController();
  late int selectedBat;
  late int selectedGuide;
  void batGetter(value) {
    selectedBat = value;
  }

  void guideGetter(value) {
    selectedGuide = value;
  }

  Map lotData = {};

  void creatingMsgsHandler(lotData) async {
    await createLot(context, lotData).then((_) {
      if (created) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('lot envoyé'),
                TextButton(onPressed: () {}, child: const Text('Voir'))
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
                const Text("ERROR: echec d'envoyer les données"),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Aide', style: TextStyle(fontSize: 17, fontStyle: FontStyle.normal, color: Colors.grey.shade800)),
                          content: const SignlaProblem(),
                        ),
                      );
                    },
                    child: const Text('Plus'))
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
    sites = Provider.of<SitesBatsProvider>(context).sitesData;
    bats = Provider.of<SitesBatsProvider>(context).batsGetter;
    bats = bats.where((obj) => obj.isEmpty == true).toList();
    guides = Provider.of<SitesBatsProvider>(context).getGuides;
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Creation de lot",
            style: TextStyle(color: Colors.blue, fontStyle: FontStyle.normal, fontSize: 18),
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
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
                  child: Text("Ajouter un lot"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
                )
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
            child: Form(
              key: lotFormKey,
              child: Column(
                children: [
                  InitFormSelect(selectName: 'site', inputsOptions: sites, fetch: fetchAllBats, themeColor: Colors.blue, selectedVal: placeholder),
                  InitFormSelect(selectName: 'bâtiment', inputsOptions: bats, fetch: fetchGuides, themeColor: Colors.blue, selectedVal: batGetter),
                  InitFormSelect(selectName: 'guide', inputsOptions: guides, fetch: placeholder, themeColor: Colors.blue, selectedVal: guideGetter),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextFormField(
                      controller: lotCodeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champs requis';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        labelText: 'Code lot',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextFormField(
                      controller: effectifDpController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champs requis';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        labelText: 'Effectif logée',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    height: 50,
                    width: deviceSize.width,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: dateError ? Colors.red : Colors.grey, width: 1.0), // Border color and width
                          ),
                        ),
                        onPressed: () {
                          _presentBirthDateDatePicker();
                        },
                        child: Text(
                          "Date naissance: $birthdate",
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    height: 50,
                    width: deviceSize.width,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(color: dateError ? Colors.red : Colors.grey, width: 1.0), // Border color and width
                          ),
                        ),
                        onPressed: () {
                          _presentTransfertDatePicker();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Date transfert: $transfertDate",
                            ),
                            if (dateError)
                              const FittedBox(
                                child: Text(
                                  "date de transfert est aprés date de naissance",
                                  style: TextStyle(color: Colors.red, fontSize: 10),
                                ),
                              ),
                          ],
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    margin: const EdgeInsets.only(bottom: 6),
                    // height: 50,
                    width: deviceSize.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(children: [
                      const Text('Remplissage'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Par jour'),
                          Switch(
                            value: isWeekly,
                            activeColor: Colors.orangeAccent.shade700,
                            inactiveThumbColor: Colors.blue,
                            onChanged: (bool value) {
                              setState(() {
                                isWeekly = !isWeekly;
                              });
                            },
                          ),
                          const Text('Par semaine'),
                        ],
                      )
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 30),
                    width: deviceSize.width * 0.9,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        if (!lotFormKey.currentState!.validate()) {
                          return;
                        }
                        if (birthdate.isEmpty || transfertDate.isEmpty) {
                          setState(() {
                            dateError = true;
                          });
                          return;
                        }
                        lotData = {
                          "batiment": selectedBat,
                          "guide": selectedGuide,
                          "hebdoFill": isWeekly,
                          "code": lotCodeController.text,
                          "effectifDP": effectifDpController.text,
                          "birthDate": birthdate,
                          "transferDate": transfertDate,
                        };
                        if (dateError) {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(title: const Text('ERROR', style: TextStyle(fontSize: 17, fontStyle: FontStyle.normal, color: Colors.red)), actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Retour',
                                  style: TextStyle(color: Colors.amber.shade800, fontSize: 14),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ]),
                          );
                        }
                        creatingMsgsHandler(lotData);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          width: 2,
                          color: Colors.green,
                        ),
                        padding: EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            creatingLot ? "Creation en cours   " : "Ajouter  ",
                            style: TextStyle(color: Colors.green),
                          ),
                          creatingLot
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.green),
                                )
                              : const Icon(
                                  Icons.add,
                                  size: 19,
                                  color: Colors.green,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
