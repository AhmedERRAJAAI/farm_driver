import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../providers/sites_bats_provider.dart';
import '../mywidgets/report_item.dart';

class DisplayDataScreen extends StatefulWidget {
  const DisplayDataScreen({super.key});
  static const routeName = "data-screen/";

  @override
  State<DisplayDataScreen> createState() => _DisplayDataScreenState();
}

class _DisplayDataScreenState extends State<DisplayDataScreen> {
  bool _isInit = true;
  bool isLoading = false;
  bool failedToFecthReports = false;

  List reportsData = [];
  String failedMsg = "échec de récupération des données";

  @override
  void initState() {
    isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      fetchReports();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void fetchReports() async {
    setState(() {
      isLoading = true;
    });
    final lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    try {
      await Provider.of<SitesBatsProvider>(context, listen: false).fetchReports(lotData['lotId'], lotData['fage'], lotData['lage']).then((_) {
        setState(() {
          reportsData = Provider.of<SitesBatsProvider>(context, listen: false).reportsData;
          isLoading = false;
          failedToFecthReports = false;
        });
      });
    } catch (e) {
      setState(() {
        failedMsg = e.toString();
        isLoading = false;
        failedToFecthReports = true;
      });
    }
  }

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    reportsData = Provider.of<SitesBatsProvider>(context).reportsData;
    final deviceSize = MediaQuery.of(context).size;
    final lotData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 80,
              width: deviceSize.width,
              padding: const EdgeInsets.only(right: 10, left: 15, top: 25),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    '${lotData['lotCode']} (${lotData['batiment']})',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            isLoading
                ? const LinearProgressIndicator()
                : failedToFecthReports
                    ? Column(
                        children: [
                          Text(failedMsg),
                          TextButton(
                              onPressed: () {
                                fetchReports();
                              },
                              child: const Text("Refresh"))
                        ],
                      )
                    : Container(
                        color: Colors.white,
                        child: CarouselSlider(
                          items: reportsData.map((report) {
                            return ReportItem(
                              height: deviceSize.height,
                              width: deviceSize.height,
                              oneReport: report,
                              lotId: lotData['lotId'],
                            );
                          }).toList(),
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            height: deviceSize.height * 0.9,
                            viewportFraction: 1,
                            reverse: false,
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
