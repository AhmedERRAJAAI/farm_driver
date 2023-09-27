import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardProvider with ChangeNotifier {
  List<_SliderItem> _slides = [
    // FETCHED DATA ...
  ];

  List<_SliderItem> get slidesData {
    return [..._slides];
  }

  Future<void> fetchSliderData() async {
    final url =
        Uri.parse('https://farmdriver.savas.ma/api/get-dash-slider-data/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {'Authorization': 'Bearer $accessToken'};

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        final List<_SliderItem> extractedData = [];
        for (var item in fetchedProducts) {
          extractedData.add(
            _SliderItem(
              siteId: item['site_id'],
              siteName: item['placeName'] ?? 'Non défini',
              ageMoy: item['ageMoy'],
              containsWeeklyLots: item['containsWeeklyLots'],
              currentTemp: item['currentTemp'],
              dateOfProdJour: item['siteName'],
              effectifPresent: item['effectifPresent'],
              lastUpdate: item['lastUpdate'],
              prodJour: item['prodJour'],
              siteIsGood: item['siteIsGood'],
              statusMsg: item['statusMsg'],
              weatherIcon: item['weatherIcon'],
              disabled: item['disabled'],
              humidity: item['humidity'],
            ),
          );
        }
        _slides = extractedData;
        notifyListeners();
      } else {
        throw Exception(
            "ERROR  DURING FETCHING SLIDERS CODE: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("ERROR  DURING FETCHING SLIDERS");
    }
  }
}

class _SliderItem {
  final int siteId;
  final String? siteName;
  final String? lastUpdate;
  final String? currentTemp;
  final String? humidity;
  final String weatherIcon;
  final String? effectifPresent;
  final String? ageMoy;
  final String? prodJour;
  final String? dateOfProdJour;
  final bool? containsWeeklyLots;
  final bool? siteIsGood;
  final bool? disabled;
  final String? statusMsg;

  _SliderItem({
    required this.siteId,
    this.siteName,
    this.ageMoy,
    this.containsWeeklyLots,
    required this.weatherIcon,
    this.currentTemp,
    this.humidity,
    this.dateOfProdJour,
    this.effectifPresent,
    this.lastUpdate,
    this.siteIsGood,
    this.statusMsg,
    this.prodJour,
    this.disabled,
  });
}
