import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import '../mywidgets/dashboard_button.dart';

import './calendar_screen.dart';
import './before_add_screen.dart';
import 'apps_screen.dart';
import '../mywidgets/side_drawer.dart';
import '../mywidgets/badge_widget.dart';
import '../mywidgets/sites_slider.dart';
import '../mywidgets/charts_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  goToCharts(BuildContext ctx) {
    // Navigator.of(ctx).pushNamed(ChartsScreen.routeName);
  }

  appsPage(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(AppsScreen.routeName);
  }

  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;
  List sliderData = [];

  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchSliderData();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchSliderData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<DashboardProvider>(context, listen: false).fetchSliderData().then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  Future<void> _refreshPage(BuildContext context) async {
    fetchSliderData();
  }

  @override
  Widget build(BuildContext context) {
    sliderData = Provider.of<DashboardProvider>(context).slidesData;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              goToPage(context, CalendarScreen.routeName);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 24,
            ),
            color: const Color(0xFF145da0),
          ),
          const SizedBox(width: 10),
          BadgeWidget(
            count: 2,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.blue,
                        height: 500,
                        child: const Text("hello"),
                      );
                    });
              },
              icon: const Icon(
                Icons.notifications,
                size: 24,
              ),
              color: const Color(0xFF145da0),
            ),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      body: RefreshIndicator(
          onRefresh: () => _refreshPage(context),
          child: SingleChildScrollView(
            child: SafeArea(
              bottom: false,
              child: Column(children: <Widget>[
                isLoading
                    ? SizedBox(
                        height: deviceSize.height * 0.28,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : failedToFetch
                        ? SizedBox(
                            height: deviceSize.height * 0.28,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Check your internet connection and refresh'),
                                  TextButton(
                                      onPressed: () {
                                        fetchSliderData();
                                      },
                                      child: const Text('Refresh'))
                                ],
                              ),
                            ),
                          )
                        : sliderData.isEmpty
                            ? Column(
                                children: [
                                  const Text("aucun site trouvé"),
                                  OutlinedButton(onPressed: () {}, child: const Text("Créer site")),
                                ],
                              )
                            : DashSlider(
                                height: deviceSize.height,
                                width: deviceSize.width,
                              ),
                Container(
                  width: deviceSize.width * 1,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(top: 4, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DashboardAppButton(
                            route: BeforeAddingScreen.routeName,
                            title: "Ajouter",
                            width: deviceSize.width * 0.45,
                            height: 110,
                            bgcolor: const Color(0xFFFFFFFF),
                            toPage: goToPage,
                            icon: const Icon(
                              Icons.app_registration,
                              color: Color(0xFF90bc29),
                              size: 35,
                            ),
                          ),
                          DashboardAppButton(
                            route: "/",
                            title: "Charts",
                            width: deviceSize.width * 0.45,
                            height: 110,
                            bgcolor: const Color(0xFFFFFFFF),
                            toPage: goToPage,
                            icon: const Icon(
                              Icons.query_stats_outlined,
                              color: Color(0xFFf1a741),
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DashboardAppButton(
                            route: "/",
                            title: "supplémentation",
                            width: deviceSize.width * 0.45,
                            height: 110,
                            bgcolor: const Color(0xFFFFFFFF),
                            toPage: goToPage,
                            icon: const Icon(
                              Icons.vaccines_outlined,
                              color: Color(0xFFf87878),
                              size: 35,
                            ),
                          ),
                          DashboardAppButton(
                            route: AppsScreen.routeName,
                            title: "Plus",
                            width: deviceSize.width * 0.45,
                            height: 110,
                            bgcolor: const Color(0xFFFFFFFF),
                            toPage: goToPage,
                            icon: const Icon(
                              Icons.apps,
                              color: Color(0xFF40a8ea),
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  // height: deviceSize.height * 0.3,
                  width: deviceSize.width,
                  margin: const EdgeInsets.only(bottom: 60, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFFFFFFF),
                  ),
                  child: DashChartsSlider(height: deviceSize.height),
                )
              ]),
            ),
          )),
    );
  }
}
