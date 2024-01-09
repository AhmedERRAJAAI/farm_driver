import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLUEPRINT
class Stock {
  final String? bat;
  final double total;
  final int normaux;
  final int dj;
  final int blancs;
  final int casse;
  final int feles;
  final double congeles;
  final int sale;

  Stock({
    required this.bat,
    required this.total,
    required this.normaux,
    required this.dj,
    required this.blancs,
    required this.casse,
    required this.feles,
    required this.congeles,
    required this.sale,
  });
}

class StockProvider with ChangeNotifier {
  List<Stock> _stocks = [];
  List<Stock> get stocks {
    return [
      ..._stocks
    ];
  }

  Future<void> fetchStockData() async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-stock-status/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }

    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      _stocks.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        final List<Stock> gotData = [];
        for (var item in fetchedProducts) {
          gotData.add(
            Stock(
              bat: item['bat'],
              total: double.parse("${item['total']}"),
              normaux: int.parse("${item['normaux']}"),
              dj: int.parse("${item['dj']}"),
              blancs: int.parse("${item['blancs']}"),
              casse: int.parse("${item['casse']}"),
              feles: int.parse("${item['feles']}"),
              congeles: double.parse("${item['congeles']}"),
              sale: item['sale'],
            ),
          );
        }
        _stocks = gotData;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print("ER $e");
      throw Exception("ERROR  DURING FETCHING");
    }
  }
}
