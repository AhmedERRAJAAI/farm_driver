import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormClient {
  final int id;
  final String firstName;
  final String lastName;
  final String? batName;
  final int? batId;
  final int? immNbr;
  final int? immLetter;
  final int? immCity;
  final String? transfName;
  final String? translName;
  final String? transCin;

  FormClient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.batName,
    required this.batId,
    required this.immNbr,
    required this.immLetter,
    required this.immCity,
    required this.transfName,
    required this.translName,
    required this.transCin,
  });
}

class Batiment {
  final int id;
  final String name;

  Batiment({
    required this.id,
    required this.name,
  });
}

class Mouvement {
  final int id;
  final String date;
  final int qty;
  final double? pu;
  final int outType;
  final String? client;
  final String? bat;

  Mouvement({
    required this.pu,
    required this.id,
    required this.date,
    required this.outType,
    required this.client,
    required this.bat,
    required this.qty,
  });
}

class MouvementProvider with ChangeNotifier {
  List<FormClient> _formClients = [];
  List<FormClient> get formClients {
    return [
      ..._formClients
    ];
  }

  List<Batiment> _Batiment = [];
  List<Batiment> get batiments {
    return [
      ..._Batiment
    ];
  }

  List<Mouvement> _mouvements = [];
  List<Mouvement> get mouvements {
    return [
      ..._mouvements
    ];
  }

  Future<void> fetchFormClients() async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-form-clients/');
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
      _formClients.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody) as Map;

        final List<FormClient> gotClients = [];
        final List<Batiment> gotBatiments = [];
        for (var item in fetchedData['clients']) {
          gotClients.add(
            FormClient(
              id: item['id'],
              firstName: item['firstName'],
              lastName: item['lastName'],
              batName: item['batName'],
              batId: item['batId'],
              immNbr: item['immNbr'],
              immLetter: item['immLetter'],
              immCity: item['immCity'],
              transfName: item['transfName'],
              translName: item['translName'],
              transCin: item['transCin'],
            ),
          );
        }
        for (var item in fetchedData['batiments']) {
          gotBatiments.add(
            Batiment(id: item['id'], name: item['name']),
          );
        }
        _formClients = gotClients;
        _Batiment = gotBatiments;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  Future<void> fetchMouvments({int count = 100, bool isEntree = false}) async {
    final url = isEntree ? Uri.parse('${Urls.url}/egg-sell/get-entrees/?count=$count') : Uri.parse('${Urls.url}/egg-sell/get-sorties/?count=$count');
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
      _mouvements.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody) as List;

        final List<Mouvement> gotRecords = [];
        for (var item in fetchedData) {
          gotRecords.add(
            Mouvement(
              id: item['id'],
              qty: item['qty'],
              pu: item['pu'],
              client: item['client'],
              date: item['date'],
              outType: item['type'],
              bat: item['bat'],
            ),
          );
        }
        _mouvements = gotRecords;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  Future<void> sendSortieData(data) async {
    final url = Uri.parse('${Urls.url}/egg-sell/add-sortie/');
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
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> sendEntreeData(data) async {
    final url = Uri.parse('${Urls.url}/egg-sell/add-entree/');
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
      } else {
        throw Exception("ERROR  DURING SENDING REPORTS");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchMouvementDetails(int id) async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-oper-details/');
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
      _formClients.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody) as Map;

        final List<FormClient> gotClients = [];
        final List<Batiment> gotBatiments = [];
        for (var item in fetchedData['clients']) {
          gotClients.add(
            FormClient(
              id: item['id'],
              firstName: item['firstName'],
              lastName: item['lastName'],
              batName: item['batName'],
              batId: item['batId'],
              immNbr: item['immNbr'],
              immLetter: item['immLetter'],
              immCity: item['immCity'],
              transfName: item['transfName'],
              translName: item['translName'],
              transCin: item['transCin'],
            ),
          );
        }
        for (var item in fetchedData['batiments']) {
          gotBatiments.add(
            Batiment(id: item['id'], name: item['name']),
          );
        }
        _formClients = gotClients;
        _Batiment = gotBatiments;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("ERROR  DURING FETCHING");
    }
  }
}
