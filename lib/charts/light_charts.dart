import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './charts_provider.dart';

class LightChart extends StatefulWidget {
  const LightChart({super.key});

  @override
  State<LightChart> createState() => _LightChartState();
}

class _LightChartState extends State<LightChart> {
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
    List<LightFlash> lightData = ChartsDataLocalProvider().getLightData;

    return SfCartesianChart(
      trackballBehavior: _trackballBehavior,
      // zoomPanBehavior: _zoomPanBehavior,
      enableAxisAnimation: true,
      // isTransposed: true,

      primaryXAxis: NumericAxis(
        // labelFormat: '{value}sem',
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
        labelFormat: '{value}h',
        decimalPlaces: 1,
        interval: 1,
        title: AxisTitle(
          text: '- Durée -',
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
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '{value}%',
          interval: 1,
          // anchorRangeToVisiblePoints: true,
          majorGridLines: MajorGridLines(width: 0),
          name: 'intensiteAxis',
          opposedPosition: true,
          title: AxisTitle(
            text: '- intensité -',
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
        StepAreaSeries<LightFlash, int>(
          // spacing: 0.6,
          dataSource: lightData,
          xValueMapper: (LightFlash intensite, _) => intensite.age,
          yValueMapper: (LightFlash intensite, _) => intensite.intensite,
          yAxisName: 'intensiteAxis',
          enableTooltip: true,
          name: 'intensité',
          dataLabelSettings: const DataLabelSettings(isVisible: false),
          color: Colors.amber.shade300.withOpacity(0.6),
          // width: ,
          legendItemText: 'intensité',

          // markerSettings: const MarkerSettings(
          //   isVisible: true,
          //   shape: DataMarkerType.diamond,
          // ),
        ),
        StepLineSeries<LightFlash, int>(
          dataSource: lightData,
          xValueMapper: (LightFlash flash, _) => flash.age,
          yValueMapper: (LightFlash flash, _) => flash.flash,
          enableTooltip: true,
          name: 'flash',
          color: Colors.amber.shade700,
          dataLabelSettings: const DataLabelSettings(isVisible: false, borderColor: Colors.black, borderWidth: 0.9),
        ),
        StepLineSeries<LightFlash, int>(
          dataSource: lightData,
          xValueMapper: (LightFlash light, _) => light.age,
          yValueMapper: (LightFlash light, _) => light.light,
          enableTooltip: true,
          name: 'light',
          color: Colors.green,
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }
}
