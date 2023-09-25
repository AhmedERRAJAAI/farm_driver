import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});
  static final routeName = 'charts/';

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  List<_SalesData> data = [
    _SalesData('Jan', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Apr', 32),
    _SalesData('May', 40)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("CHART_NAME", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14, fontStyle: FontStyle.normal))),
        body: SizedBox(
          // height: 400,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            // Chart title
            title: ChartTitle(text: 'Courbde de PARAM_NAME'),
            // Enable legend
            // legend: Legend(isVisible: true),
            // Enable tooltip
            tooltipBehavior: TooltipBehavior(enable: false),
            series: <ChartSeries<_SalesData, String>>[
              LineSeries<_SalesData, String>(
                  dataSource: data,
                  xValueMapper: (_SalesData sales, _) => sales.year,
                  yValueMapper: (_SalesData sales, _) => sales.sales,
                  name: 'Sales',
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true))
            ],
          ),
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
