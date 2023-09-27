import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormsProvider with ChangeNotifier {
  static const String _base_url = "https://farmdriver.savas.ma/api";

    Future<void> sendReport(data) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/add-report-prod/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<void> sendPoussReport(data) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/add-report-prod/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(data);
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      rethrow;
    }
  }

}

class MasterUser {
  
}
