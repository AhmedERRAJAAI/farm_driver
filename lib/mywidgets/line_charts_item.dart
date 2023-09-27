import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartItem extends StatefulWidget {
  const LineChartItem({super.key});

  @override
  State<LineChartItem> createState() => _LineChartItemState();
}

class _LineChartItemState extends State<LineChartItem> {
  List<_SalesData> data = [
    _SalesData('01/01', 35),
    _SalesData('02/01', 28),
    _SalesData('03/01', 34),
    _SalesData('04/01', 32),
    _SalesData('05/01', 40),
    _SalesData('06/01', 40),
    _SalesData('07/01', 40),
  ];

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      // Chart title
      title: ChartTitle(text: 'Mortalité', textStyle: const TextStyle(fontSize: 11)),
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
            dataLabelSettings: const DataLabelSettings(isVisible: true))
      ],
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
