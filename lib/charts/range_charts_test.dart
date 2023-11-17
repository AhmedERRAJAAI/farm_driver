import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class RangeChartTester extends StatefulWidget {
  const RangeChartTester({super.key});

  @override
  State<RangeChartTester> createState() => _RangeChartTesterState();
}

class _RangeChartTesterState extends State<RangeChartTester> {
  final chartData = <ChartData>[
    ChartData(x: DateTime(2021, 1, 20), high: 1400, low: 10),
    ChartData(x: DateTime(2021, 2, 20), high: 1222, low: 9),
    ChartData(x: DateTime(2021, 3, 20), high: 16, low: 10),
    ChartData(x: DateTime(2021, 4, 20), high: 18, low: 14),
    ChartData(x: DateTime(2021, 5, 20), high: 20, low: 15),
  ];
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <RangeAreaSeries>[
        RangeAreaSeries<ChartData, DateTime>(
          dataSource: chartData,
          name: "NAME",
          xValueMapper: (ChartData data, _) => data.x,
          highValueMapper: (ChartData data, _) => data.high,
          lowValueMapper: (ChartData data, _) => data.low,
        ),
      ],
    );
  }
}

class ChartData {
  DateTime x;
  final double high;
  final double low;

  ChartData({required this.high, required this.low, required this.x});
}
