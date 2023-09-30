import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class RangeChartTester extends StatefulWidget {
  const RangeChartTester({super.key});

  @override
  State<RangeChartTester> createState() => _RangeChartTesterState();
}

class _RangeChartTesterState extends State<RangeChartTester> {
  final chartData = <ChartData>[
    ChartData(x: 1, y: 10),
    ChartData(x: 2, y: 20),
    ChartData(x: 3, y: 30),
    ChartData(x: 4, y: 40),
    ChartData(x: 5, y: 50),
  ];
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(),
      series: <ChartSeries>[
        AreaSeries<ChartData, double>(
          dataSource: chartData,
          xValueMapper: (ChartData data, int index) => data.x,
          yValueMapper: (ChartData data, int index) => data.y,
        ),
      ],
    );
  }
}

class ChartData {
  final double x;
  final double y;

  ChartData({required this.x, required this.y});
}
