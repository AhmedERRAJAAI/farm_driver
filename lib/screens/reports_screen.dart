import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/sites_bats_provider.dart';

import '../screens/calendar_screen.dart';
import '../mywidgets/site_list_item.dart';
// import '../mywidgets/badge_widget.dart';

class AddScreen extends StatefulWidget {
  static const routeName = 'add-screen/';

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  bool _isInit = true;
  bool isLoading = false;

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<SitesBatsProvider>(context, listen: false)
        .fetchSites();
  }

  @override
  Widget build(BuildContext context) {
    final sites = Provider.of<SitesBatsProvider>(context).sitesData;
    // final deviceSize = MediaQuery.of(context).size;
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
                child: Text("Ajouter un site"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text(
                    "voir sites details"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
              )
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () => _refreshPage(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 12),
                  child: Column(
                    children: AnimateList(
                      interval: 50.ms,
                      effects: [
                        FadeEffect(
                          duration: 100.ms,
                        )
                      ],
                      children: sites
                          .map((site) => SiteListItem(
                                id: site.id,
                                lotNbr: site.lotNbr,
                                name: site.name,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
