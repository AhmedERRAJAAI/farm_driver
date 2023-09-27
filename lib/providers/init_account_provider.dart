import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InitUserProvider with ChangeNotifier {
  static const String baseUrl = "https://farmdriver.savas.ma/api";

  Future<void> createMaster(data) async {
    final url = Uri.parse('$baseUrl/create-master-user/');

    final headers = {
      'Content-Type': 'application/json',
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

class MasterUser {}
