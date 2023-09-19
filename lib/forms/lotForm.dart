import 'package:flutter/material.dart';
import './production/select_sites.dart';
import '../screens/calendar_screen.dart';
import 'package:provider/provider.dart';
import '../providers/sites_bats_provider.dart';

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
    print('TRiigerd');
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchActiveGuides()
          .then((_) {
        setState(() {
          guides =
              Provider.of<SitesBatsProvider>(context, listen: false).getGuides;
          print(guides);
        });
      });
    } catch (e) {
      setState(() {});
    }
  }

  void placeholder(value) {}

  String? birthdate;
  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        birthdate = formatDate('$value');
      });
    });
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

  bool isWeekly = false;

  // DATA GATHERING
  final TextEditingController lotCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    sites = Provider.of<SitesBatsProvider>(context).sitesData;
    bats = Provider.of<SitesBatsProvider>(context).lotsData;
    guides = Provider.of<SitesBatsProvider>(context).getGuides;
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
              key: lotFormKey,
              child: Column(
                children: [
                  SelectSites(
                      selectName: 'site',
                      sites: sites,
                      fetch: fetchLots,
                      selectedVal: placeholder),
                  SelectSites(
                      selectName: 'bâtiment',
                      sites: bats,
                      fetch: fetchGuides,
                      selectedVal: placeholder),
                  SelectSites(
                      selectName: 'guide',
                      sites: guides,
                      fetch: placeholder,
                      selectedVal: placeholder),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TextFormField(
                      controller: lotCodeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field cannot be empty';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(7))),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        labelText: 'Nombre de mortalité',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    height: 50,
                    width: deviceSize.width,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                                color: Colors.grey,
                                width: 1.0), // Border color and width
                          ),
                        ),
                        onPressed: () {
                          _presentDatePicker();
                        },
                        child: Text(
                          "Date naissance: ${birthdate == null ? '../../.....' : birthdate}",
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    height: 50,
                    width: deviceSize.width,
                    child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                                color: Colors.grey,
                                width: 1.0), // Border color and width
                          ),
                        ),
                        onPressed: () {
                          _presentDatePicker();
                        },
                        child: Text(
                          "Date transfert: ${birthdate == null ? '../../.....' : birthdate}",
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
                          Text('Par jour'),
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
                      onPressed: () {},
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ajouter  ",
                            style: TextStyle(color: Colors.green),
                          ),
                          Icon(
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
