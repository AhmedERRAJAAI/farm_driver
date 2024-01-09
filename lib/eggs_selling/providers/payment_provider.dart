import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

// BLUEPRINT
class Transaction {
  final int id;
  final double amount;
  final String date;
  final String? img_url;
  final bool? isPayed;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.img_url,
    required this.isPayed,
  });
}

class PaymentProvider with ChangeNotifier {
  List<Transaction> _clientTransactions = [];
  List<Transaction> get clientTransactions {
    return [
      ..._clientTransactions
    ];
  }

  double _solde = 0;
  double get solde {
    return _solde;
  }

  Future<void> sendPaymentData(File? selectedImage, data) async {
    final url = Uri.parse('${Urls.url}/egg-sell/add-payment/');
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll(headers)
        ..fields['body'] = json.encode(data);

      if (selectedImage != null) {
        request.files.add(
          http.MultipartFile(
            'pyamentImg',
            selectedImage.readAsBytes().asStream(),
            selectedImage.lengthSync(),
            filename: "${data['client']}_payment_img.jpg",
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      var response = await request.send();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // var responseBody = await response.stream.bytesToString();
        // var returnedData = json.decode(responseBody);
        fetchClientInOuts();
      } else {
        throw Exception("ERROR DURING SENDING REPORTS");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchClientInOuts({int? count, int? client}) async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-client-payments/?count=$count&client=$client');
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
      _clientTransactions.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as Map;
        _solde = fetchedProducts['solde'];
        final List<Transaction> gotTransactions = [];
        for (var item in fetchedProducts['transctions']) {
          gotTransactions.add(
            Transaction(
              id: item['id'],
              img_url: item['img_url'],
              amount: item['amount'],
              date: item['date'],
              isPayed: item['isPayed'],
            ),
          );
        }
        _clientTransactions = gotTransactions;
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
