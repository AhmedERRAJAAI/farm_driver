import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../mywidgets/carousel_slider_item.dart';
import '../providers/dashboard_provider.dart';

class DashSlider extends StatefulWidget {
  // const DashSlider({super.key});
  final double width;
  final double height;

  DashSlider({required this.width, required this.height});

  @override
  State<DashSlider> createState() => _DashSliderState();
}

class _DashSliderState extends State<DashSlider> {
  @override
  Widget build(BuildContext context) {
    final init_sliders = Provider.of<DashboardProvider>(context);
    final sliderData = init_sliders.slidesData;

    return Container(
        //Slider
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 6),
        child: CarouselSlider(
                items: sliderData.map((e) {
                  return CarouselSliderItem(
                    width: widget.width * 0.96,
                    siteName: e.siteName ?? "Non défini",
                    temprature: e.currentTemp ?? '--',
                    // weatherType: e.wheatherType ?? '--',

                    lastUpdated: e.lastUpdate ?? '--',
                    effectifPresent: e.effectifPresent ?? '--',
                    ageMoy: e.ageMoy ?? '--',
                    prodjour: e.prodJour ?? '--',
                    siteIsGood: e.siteIsGood ?? false,
                    statusMsg: e.statusMsg ?? '--',
                    weatherIcon: e.weatherIcon,
                    height: widget.height * 0.28,
                    humidity: e.humidity ?? '--',
                  );
                }).toList(),
                options: CarouselOptions(
                  height: widget.height * 0.28,
                  // enableInfiniteScroll: false,
                  // autoPlay: true,
                  // autoPlayAnimationDuration: Duration(milliseconds: 1000),
                ),
              )
            // : CarouselSliderItem(
            //     width: widget.width * 0.96,
            //     siteName: sliderData.last.siteName ?? "Non défini",
            //     temprature: sliderData.last.currentTemp ?? '--',
            //     weatherType: sliderData.last.wheatherType ?? '--',
            //     lastUpdated: sliderData.last.lastUpdate ?? '--',
            //     effectifPresent: sliderData.last.effectifPresent ?? '--',
            //     ageMoy: sliderData.last.ageMoy ?? '--',
            //     prodjour: sliderData.last.prodJour ?? '--',
            //     siteIsGood: sliderData.last.siteIsGood ?? false,
            //     statusMsg: sliderData.last.statusMsg ?? '--',
            //     weatherIcon: sliderData.last.weatherIcon,
            //     height: widget.height * 0.28,
            //   ),
              );
  }
}
