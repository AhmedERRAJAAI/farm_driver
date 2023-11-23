import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLUEPRINT
class EggPriceItem {
  final int id;
  final double price;
  final DateTime? date;

  EggPriceItem({
    required this.id,
    required this.price,
    this.date,
  });
}

// PROVIDER
class EggPrice with ChangeNotifier {
  List<EggPriceItem> _dayPrice = [];
  List<EggPriceItem> get daysPrices {
    return [
      ..._dayPrice
    ];
  }

  Future<void> sendDailyPrice(double price, DateTime date) async {
    final url = Uri.parse('${Urls.url}/egg-sell/add-daily-price/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    Map data = {
      "price": price,
      "date": "${date.year}-${date.month}-${date.day}"
    };
    final body = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final returnedData = json.decode(response.body);
        _dayPrice.add(
          EggPriceItem(
            id: returnedData['id'],
            price: returnedData['price'],
            date: DateTime.parse(returnedData['date']),
          ),
        );
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> modifyDailyPrice(double price, DateTime date, int id) async {
    final url = Uri.parse('${Urls.url}/egg-sell/update-daily-price/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    Map data = {
      "id": id,
      "price": price,
      "date": "${date.year}-${date.month}-${date.day}"
    };
    final body = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        EggPriceItem updatedItem = EggPriceItem(id: id, price: price, date: date);
        int index = _dayPrice.indexWhere((item) => item.id == id);
        _dayPrice[index] = updatedItem;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDailyPrices(int period, String? fDate, String? lDate) async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-daily-price-chart/?period=$period&fDate=$fDate&lDate=$lDate');
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
      _dayPrice.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;

        final List<EggPriceItem> gotPrices = [];
        for (var item in fetchedProducts) {
          gotPrices.add(
            EggPriceItem(
              id: item['id'],
              date: item['date'] is String ? DateTime.parse(item['date']) : null,
              price: item['price'],
            ),
          );
        }
        _dayPrice = gotPrices;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  Future<void> deleteDailyPrice(int id) async {
    final url = Uri.parse('${Urls.url}/egg-sell/delete-daily-price/?id=$id');
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
      final response = await http.delete(
        url,
        headers: headers,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        int index = _dayPrice.indexWhere((item) => item.id == id);
        _dayPrice.removeAt(index);
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("ERROR  DURING FETCHING");
    }
  }
}
