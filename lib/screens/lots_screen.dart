import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../providers/sites_bats_provider.dart';
import '../mywidgets/lot_item_widget.dart';

class LotsScreen extends StatefulWidget {
  const LotsScreen({super.key});
  static const routeName = "lots-list/";

  @override
  State<LotsScreen> createState() => _LotsScreenState();
}

class _LotsScreenState extends State<LotsScreen> {
  bool _isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        isLoading = true;
      });
      final siteData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      Provider.of<SitesBatsProvider>(context, listen: false)
          .fetchLots(siteData['siteId'])
          .then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshPage(BuildContext context, siteId) async {
    await Provider.of<SitesBatsProvider>(context, listen: false)
        .fetchLots(siteId);
  }

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final siteData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final lotsData = Provider.of<SitesBatsProvider>(context).lotsData;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            RefreshIndicator(
              onRefresh: () => _refreshPage(context, siteData['siteId']),
              child: Container(
                height: deviceSize.height * 0.26,
                padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                color: const Color.fromARGB(255, 179, 215, 255),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          siteData['siteName'],
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        Hero(
                          tag: 'siteToLot${siteData['siteId']}',
                          child: Icon(MdiIcons.sitemapOutline,
                              size: 73, color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: deviceSize.height * 0.74,
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                                  style: TextStyle(
                                      color: Colors.orange[900], fontSize: 16),
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
                              children: lotsData
                                  .map((lot) => LotListItem(
                                        id: lot.id,
                                        effectif:
                                            lot.ep! > 0 ? lot.ep : lot.edp,
                                        name: lot.code,
                                        batname: lot.name,
                                        edp: lot.edp,
                                        fAge: lot.firstAge,
                                        lAge: lot.lastAge,
                                      ))
                                  .toList(),
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
