import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

// BLUEPRINT
class Client {
  int id;
  String fname;
  String lname;
  String email;
  String phone;
  double initSolde;
  bool isActive;

  Client({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.initSolde,
  });
}

class ClientProvider with ChangeNotifier {
  List<Client> _clients = [];
  List<Client> get clientList {
    return [
      ..._clients
    ];
  }

  Future<void> sendClientData(Map data) async {
    final url = Uri.parse('${Urls.url}/egg-sell/add-client/');
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
        final returnedData = json.decode(response.body);
        _clients.add(
          Client(
            id: returnedData['id'],
            fname: returnedData['firstName'],
            lname: returnedData['lastName'],
            email: returnedData['email'],
            phone: returnedData['phone'],
            isActive: returnedData['active'],
            initSolde: returnedData['initSolde'],
          ),
        );
        notifyListeners();
      } else {
        throw Exception("ERROR  SENDING");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> fetchClients() async {
    final url = Uri.parse('${Urls.url}/egg-sell/get-clients');
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
      _clients.clear();
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedProducts = json.decode(responseBody) as List;
        final List<Client> gotClients = [];
        for (var item in fetchedProducts) {
          gotClients.add(
            Client(
              id: item['id'],
              fname: item['firstName'],
              lname: item['lastName'],
              email: item['email'],
              phone: item['phone'],
              isActive: item['active'],
              initSolde: item['initSolde'],
            ),
          );
        }
        _clients = gotClients;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING CODE: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
      throw Exception("ERROR  DURING FETCHING");
    }
  }

  Future<void> updateClientData(Map data) async {
    final url = Uri.parse('${Urls.url}/egg-sell/update-client-data/');
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
        Client updatedItem = Client(
          id: data['id'],
          email: data['email'],
          fname: data['firstName'],
          lname: data['lastName'],
          phone: data['phone'],
          initSolde: data['initSolde'],
          isActive: data['isActive'],
        );
        int index = _clients.indexWhere((item) => item.id == data['id']);
        _clients[index] = updatedItem;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING UPDATING");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
