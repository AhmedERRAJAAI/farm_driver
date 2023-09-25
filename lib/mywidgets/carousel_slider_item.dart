import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CarouselSliderItem extends StatelessWidget {
  final double width;
  final String siteName;
  final String lastUpdated;
  final String temprature;
  final String humidity;
  final String effectifPresent;
  final String ageMoy;
  final String prodjour;
  final bool siteIsGood;
  final String statusMsg;

  CarouselSliderItem({
    required this.width,
    required this.siteName,
    required this.lastUpdated,
    required this.temprature,
    required this.humidity,
    required this.effectifPresent,
    required this.ageMoy,
    required this.prodjour,
    required this.siteIsGood,
    required this.statusMsg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromARGB(255, 26, 85, 134),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            //Card header
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                //Site name + MAJ
                children: <Widget>[
                  Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF0083B0),
                      size: 26,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        siteName.toString(),
                        style: const TextStyle(color: Color(0xFFfbfafd), fontWeight: FontWeight.w600, letterSpacing: 0.4),
                        textScaleFactor: MediaQuery.textScaleFactorOf(context),
                      ),
                      Text(
                        'MAJ: $lastUpdated',
                        style: const TextStyle(fontSize: 8, color: Color(0xFFfbfafd)),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                //Weather info
                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            const Icon(
                              Icons.device_thermostat,
                              color: Color(0xFFfbfafd),
                              size: 13,
                            ),
                            Text('$temprature °C', style: const TextStyle(fontSize: 12, color: Color(0xFFfbfafd))),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              MdiIcons.waterPercent,
                              color: Colors.white,
                              size: 14,
                            ),
                            Text('$humidity %', style: const TextStyle(fontSize: 12, color: Color(0xFFfbfafd))),
                          ],
                        ),
                        
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            //Second Row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 6),
                child: Column(
                  //Middle Row
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Effectif présent",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                          Text(
                            effectifPresent.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Age moyen",
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          Text(
                            ageMoy.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Prod./jour",
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        Text(
                          prodjour.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ].animate(interval: .250.seconds, effects: [
                    const FadeEffect()
                  ]).slideY(curve: Curves.decelerate),
                ),
              ),
              Container(
                //GO TO SITE BUTTON
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    // color: const Color(0XFFFD8D14),
                    border: Border.all(color: const Color(0XFFFD8D14), width: 2),
                    borderRadius: BorderRadius.circular(60)),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero, // Remove padding
                    backgroundColor: Colors.transparent,
                    side: BorderSide.none, // Remove border
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(1),
            width: width,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: [
                siteIsGood
                    ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFF339900),
                        size: 16,
                      )
                    : const Icon(
                        Icons.error,
                        color: Color(0xFFF97910),
                        size: 16,
                      ),
                Flexible(
                  child: Text(
                    statusMsg.toString(),
                    style: TextStyle(color: siteIsGood ? const Color(0xFF339900) : const Color(0xFFF97910), fontSize: 10),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
