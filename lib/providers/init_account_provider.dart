import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Future<void> createEleveur(data) async {
    final url = Uri.parse('$baseUrl/create-eleveur/');

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

  int? userId;

  int? get getUserId {
    return userId;
  }

  Future<void> fetchUserId(
    String username,
  ) async {
    final url = Uri.parse('$baseUrl/get-user-id/?username=$username');

    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedUserId = json.decode(responseBody);
        userId = fetchedUserId;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING SITES");
      }
    } catch (e) {
      rethrow;
    }
  }
}
