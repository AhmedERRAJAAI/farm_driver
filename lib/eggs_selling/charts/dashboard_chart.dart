import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EggsDashCharts extends StatefulWidget {
  const EggsDashCharts({super.key});

  @override
  State<EggsDashCharts> createState() => _EggsDashChartsState();
}

class _EggsDashChartsState extends State<EggsDashCharts> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(24, 0.8),
      ChartData(25, 0.9),
      ChartData(26, 1.1),
      ChartData(27, 0.9),
      ChartData(28, 0.9),
      ChartData(29, 0.9),
      ChartData(30, 0.9),
      ChartData(31, 0.9),
      ChartData(32, 0.9),
      ChartData(33, 0.9),
      ChartData(34, 0.9),
      ChartData(35, 0.9),
      ChartData(36, 0.9),
      ChartData(37, 0.9),
      ChartData(38, 0.9),
      ChartData(39, 0.9),
      ChartData(40, 0.9),
      ChartData(41, 0.9),
      ChartData(42, 0.9),
      ChartData(43, 0.9),
    ];
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
            child: Container(
                child: SfCartesianChart(
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}DH',
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryXAxis: NumericAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      interval: 2,
                    ),
                    series: <ChartSeries>[
          AreaSeries<ChartData, int>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            borderColor: Theme.of(context).primaryColor,
            borderWidth: 1,
            gradient: gradientColors,
          ),
        ]))));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
