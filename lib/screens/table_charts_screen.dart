import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import '../charts/light_charts.dart';
import '../charts/pv_homog_chart.dart';

class ChartsScreen extends StatefulWidget {
  ChartsScreen({super.key});

  static const routeName = 'table-charts/';

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  bool isLandscape = false;

  Widget chartLoader(int id) {
    switch (id) {
      case 1:
        return const LightChart();
      case 2:
        return const PvHomogChart();
      default:
        return const LightChart();
    }
  }

  int chartId = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inCommingData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    chartId = inCommingData['chartId'];
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 500,
                // height: isLandscape ? deviceSize.height : deviceSize.width * 1.2,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 17),
                child: Transform.rotate(angle: 0 * 3.1415927 / 180, child: chartLoader(chartId)),
              ),
              SizedBox(
                height: 50,
                child: IconButton(
                  alignment: Alignment.centerLeft,
                  icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    // setState(() {
                    //   SystemChrome.setPreferredOrientations([
                    //     DeviceOrientation.portraitUp,
                    //   ]);
                    // });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   isLandscape = !isLandscape;
                    //   if (isLandscape) {
                    //     SystemChrome.setPreferredOrientations([
                    //       DeviceOrientation.landscapeLeft,
                    //       DeviceOrientation.landscapeRight,
                    //     ]);
                    //   } else {
                    //     SystemChrome.setPreferredOrientations([
                    //       DeviceOrientation.portraitUp,
                    //     ]);
                    //   }
                    // });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.aspect_ratio,
                        color: Colors.amber.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
