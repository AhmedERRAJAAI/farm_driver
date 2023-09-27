import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../mywidgets/line_charts_item.dart';

class DashChartsSlider extends StatefulWidget {
  final double height;
  DashChartsSlider({super.key, required this.height});

  final List sliderData = [
    1,
    2,
    3,
    4
  ];

  @override
  State<DashChartsSlider> createState() => _DashChartsSliderState();
}

class _DashChartsSliderState extends State<DashChartsSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.sliderData.map((e) {
        return const LineChartItem();
      }).toList(),
      options: CarouselOptions(
        // height: widget.height * 0.30,
        enableInfiniteScroll: false,

        // autoPlay: true,
        // autoPlayAnimationDuration: Duration(milliseconds: 1000),
      ),
    );
  }
}
