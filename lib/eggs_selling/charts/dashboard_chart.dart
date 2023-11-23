import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import '../providers/daily_price_provider.dart';

class EggsDashCharts extends StatefulWidget {
  const EggsDashCharts({super.key});

  @override
  State<EggsDashCharts> createState() => _EggsDashChartsState();
}

class _EggsDashChartsState extends State<EggsDashCharts> {
  bool isLoading = false;
  bool requestFailed = false;
  bool _isInit = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getDaysPrices(30);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getDaysPrices(period) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<EggPrice>(context, listen: false).fetchDailyPrices(period, null, null).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailyPrice = Provider.of<EggPrice>(context);
    final dailyPriceRecords = dailyPrice.daysPrices;

    final List<Color> color = <Color>[];
    color.add(const Color(0xFFe8f0f5));
    color.add(const Color(0xFFE2F4FF));
    color.add(const Color.fromARGB(255, 210, 237, 254));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors = LinearGradient(
      colors: color,
      stops: stops,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    return Scaffold(
        body: Center(
            child: Stack(
      children: [
        Column(
          children: [
            SfCartesianChart(primaryYAxis: NumericAxis(), primaryXAxis: DateTimeAxis(), series: <ChartSeries>[
              AreaSeries<EggPriceItem, DateTime>(
                dataSource: dailyPriceRecords,
                xValueMapper: (EggPriceItem data, _) => data.date,
                yValueMapper: (EggPriceItem data, _) => data.price,
                borderColor: Theme.of(context).primaryColor,
                borderWidth: 1,
                gradient: gradientColors,
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    getDaysPrices(7);
                  },
                  child: Text(
                    "7j",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getDaysPrices(365);
                  },
                  child: Text(
                    "1An",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getDaysPrices(0);
                  },
                  child: Text(
                    "Max",
                    style: TextStyle(color: Colors.blue, fontSize: 12),
                  ),
                )
              ],
            ),
          ],
        ),
        isLoading
            ? Container(
                color: Colors.white.withOpacity(0.6),
                child: Center(child: CircularProgressIndicator()),
              )
            : SizedBox(),
      ],
    )));
  }
}
