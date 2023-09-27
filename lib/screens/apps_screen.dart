import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/sites_bats_provider.dart';
import '../mywidgets/dashboard_button.dart';
import './calendar_screen.dart';
import './manage_lots_screen.dart';

class AppsScreen extends StatefulWidget {
  static const routeName = 'apps-screen/';

  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFetch = false;

  List sites = [];

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
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        failedToFetch = true;
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
    sites = Provider.of<SitesBatsProvider>(context, listen: false).sitesData;
    if (_isInit && sites.isEmpty) {
      fetchSites();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  void placeHolder() {}

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    sites = Provider.of<SitesBatsProvider>(context).sitesData;
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
              goToPage(context, CalendarScreen.routeName);
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
                child: Text("Creer un nouveau lot"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Lot archivées"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
              )
            ],
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardAppButton(
                    route: ManageLotsScreen.routeName,
                    title: "Mes lots",
                    width: deviceSize.width * 0.46,
                    height: 110,
                    bgcolor: const Color(0xFFFFFFFF),
                    toPage: goToPage,
                    icon: Icon(
                      MdiIcons.selectGroup,
                      color: Colors.green.shade500,
                      size: 35,
                    ),
                  ),
                  DashboardAppButton(
                    route: '/',
                    title: "Mes Rapports",
                    width: deviceSize.width * 0.46,
                    height: 110,
                    bgcolor: const Color(0xFFFFFFFF),
                    toPage: placeHolder,
                    icon: Icon(
                      Icons.description,
                      color: Colors.blue.shade500,
                      size: 35,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
            ],
          )),
    );
  }
}
