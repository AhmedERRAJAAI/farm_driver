import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class Auth with ChangeNotifier {
  String? _accessToken;
  String? userFirstName;
  String? userSecondName;
  bool? isAdmin;
  bool? isMaster;
  DateTime? expiryDate;

  // late Timer _authTimer;

  bool get isAuth {
    return _accessToken != null;
  }

  // String? get token {
  //   if (expiryDate != null &&
  //       expiryDate!.isAfter(DateTime.now()) &&
  //       _accessToken != null) {
  //     return _accessToken;
  //   }
  //   return null;
  // }

  Future<void> login(String username, String password) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/token');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(
          {'username': username, 'password': password},
        ),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _accessToken = json.decode(response.body)['access'];
        Map<String, dynamic> userDecodedData = Jwt.parseJwt(_accessToken ?? '');
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _accessToken,
          'first_name': userDecodedData['first_name'],
          'last_name': userDecodedData['last_name'],
          'isAdmin': userDecodedData['isAdmin'],
          'isMaster':userDecodedData['isMaster'],
          'isTechnicien':userDecodedData['isTechnicien'],
        });
        prefs.setString('userdata', userData);
      } else {
        if (response.statusCode == 401) {
          logout();
          throw Exception(
              "désolé, aucun utilisateur trouvé avec ces informations d'identification");
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    _accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _accessToken = null;
    expiryDate = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userdate');
    prefs.clear();
  }
}
