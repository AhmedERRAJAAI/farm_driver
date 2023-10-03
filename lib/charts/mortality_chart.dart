import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './charts_provider.dart';

class MortChart extends StatefulWidget {
  const MortChart({super.key});

  @override
  State<MortChart> createState() => _MortChartState();
}

class _MortChartState extends State<MortChart> {
  // ZOOMING IN CHART ----------------------
  late TrackballBehavior _trackballBehavior;
  // late ZoomPanBehavior _zoomPanBehavior;
  @override
  void initState() {
    // _zoomPanBehavior = ZoomPanBehavior(
    //   // Enables pinch zooming
    //   enablePinching: true,
    //   enableSelectionZooming: true,
    //   selectionRectBorderColor: Colors.red,
    //   selectionRectBorderWidth: 1,
    //   selectionRectColor: Colors.grey,
    // );
    _trackballBehavior = TrackballBehavior(
        // Enables the trackball
        enable: true,
        tooltipSettings: const InteractiveTooltip(enable: true, color: Colors.red));
    super.initState();
  }
// ZOOMING IN CHART ----------------------

  @override
  Widget build(BuildContext context) {
    List<Mortality> mortData = ChartsDataLocalProvider().getMortData;

    return SfCartesianChart(
      trackballBehavior: _trackballBehavior,
      // zoomPanBehavior: _zoomPanBehavior,
      enableAxisAnimation: true,
      // isTransposed: true,
      // primaryXAxis: CategoryAxis(interval: 1),
      primaryXAxis: NumericAxis(
        // majorGridLines: MajorGridLines(width: 0),
        // labelFormat: 's: {value}',
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        interval: 1,
        title: AxisTitle(
          text: '-Age-',
          textStyle: TextStyle(
            color: Colors.grey.shade900,
            // fontFamily: 'Roboto',
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: MajorGridLines(
          width: 0.6,
        ),
        labelFormat: '{value}g',
        decimalPlaces: 1,
        // interval: 1,
        title: AxisTitle(
          // alignment: ChartAlignment,
          text: '- Mortalité/sem (%)-',
          textStyle: TextStyle(
            color: Colors.grey.shade900,
            // fontFamily: 'Roboto',
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      axes: <ChartAxis>[
        NumericAxis(
          // isInversed: true,
          labelFormat: '{value}%',
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 1,
          majorGridLines: MajorGridLines(width: 0),
          name: 'rightAxis',
          opposedPosition: true,
          // isInversed: true,

          title: AxisTitle(
            text: '- Mortalité cumulée (%) -',
            textStyle: TextStyle(
              color: Colors.grey.shade900,
              // fontFamily: 'Roboto',
              fontSize: 10,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
      title: ChartTitle(text: 'Courbde de PARAM_NAME', textStyle: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.white,
      legend: const Legend(isVisible: true, position: LegendPosition.top),
      tooltipBehavior: TooltipBehavior(enable: true),

      series: <ChartSeries>[
        AreaSeries<Mortality, int>(
          dataSource: mortData,
          xValueMapper: (Mortality param, _) => param.age,
          yValueMapper: (Mortality param, _) => param.sem_reel,
          yAxisName: 'rightAxis',
          enableTooltip: true,
          name: 'Mort/sem',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          color: Colors.green.shade100,
          legendItemText: 'Réel homog',
        ),
        LineSeries<Mortality, int>(
          dataSource: mortData,
          xValueMapper: (Mortality param, _) => param.age,
          yValueMapper: (Mortality param, _) => param.sem_guide,
          yAxisName: 'rightAxis',
          enableTooltip: true,
          name: 'Guide mort/sem',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          color: Colors.green,
          legendItemText: 'Guide homog',
        ),
        LineSeries<Mortality, int>(
          dataSource: mortData,
          xValueMapper: (Mortality param, _) => param.age,
          yValueMapper: (Mortality param, _) => param.cuml_reel,
          enableTooltip: true,
          name: 'Mort cuml',
          color: Colors.deepPurple.shade100,
          width: 5,
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        ),
        FastLineSeries<Mortality, int>(
          dataSource: mortData,
          xValueMapper: (Mortality param, _) => param.age,
          yValueMapper: (Mortality param, _) => param.cuml_guide,
          enableTooltip: true,
          name: 'Guide mort cuml',
          color: Colors.deepPurple,
          dataLabelSettings: const DataLabelSettings(isVisible: false, borderColor: Colors.black, borderWidth: 0.9),
        ),
      ],
    );
  }
}
