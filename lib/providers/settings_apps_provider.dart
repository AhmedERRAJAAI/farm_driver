import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsAppsProvider with ChangeNotifier {
  static const String _base_url = "https://farmdriver.savas.ma/api";




  List<LotData> _allLots = [
    // FETCHED DATA ...
  ];

  List<LotData> get getAllLots {
    return [
      ..._allLots
    ];
  }

  Future<void> fetchAllUserlots() async {
    final url = Uri.parse('$_base_url/get-mob-all-lots/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedItems = json.decode(responseBody) as List;
        final List<LotData> extractedData = [];
        for (var item in fetchedItems) {
          extractedData.add(
            LotData(
                deletable: item['deletable'],
                siteId: item['site_id'],
                batimentId: item['bat_id'],
                batimentName: item['bat_name'],
                siteName: item['site_name'],
                lotId: item['lot_id'],
                lotCode: item['lot_code'],
                isProd: item['is_prod'],
                isReforming: item['is_reforming'],
                isActive: item['is_active'],
                edp: item['edp'],
                ep: item['ep'],
                age: item['age'],
            ),
          );
        }
        _allLots = extractedData;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING SITES");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class LotData {
  final int siteId;
  final int batimentId;
  final String batimentName;
  final String siteName;
  final int lotId;
  final String lotCode;
  final bool isProd;
  final bool isReforming;
  final bool isActive;
  final bool deletable;
  final int? edp;
  final int? ep;
  final int? age;

  LotData({
    required this.siteId,
    required this.batimentId,
    required this.batimentName,
    required this.siteName,
    required this.lotId,
    required this.lotCode,
    required this.isProd,
    required this.isReforming,
    required this.isActive,
    required this.deletable,
    this.edp,
    this.ep,
    this.age,
  });
}
