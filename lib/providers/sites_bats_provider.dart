import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SitesBatsProvider with ChangeNotifier {




  Future<void> createLot(data) async {
    final url = Uri.parse('http://localhost:8000/api/add-lot/');

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
        throw Exception("ERROR  DURING CREATING REPORT");
      }
    } catch (e) {
      rethrow;
    }
  }

  List<Site> Sites = [
    // FETCHED DATA ...
  ];

  List<Site> get sitesData {
    return [
      ...Sites
    ];
  }

  List<Lot> lots = [
    // FETCHED DATA ...
  ];

  List<Lot> get lotsData {
    return [
      ...lots
    ];
  }

  Future<void> fetchSites() async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-sites-mob/');

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
        final List<Site> extractedData = [];
        for (var item in fetchedItems) {
          extractedData.add(
            Site(
              id: item['id'],
              name: item['name'],
              lotNbr: item['lot_nbr'],
              pouss: item['containsPouss'],
            ),
          );
        }
        Sites = extractedData;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING SITES");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchLots(siteId) async {
    final url = Uri.parse('http://localhost:8000/api/get-lots-mob/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(
      {
        'siteId': siteId
      },
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedItems = json.decode(responseBody) as List;
        final List<Lot> extractedLots = [];
        for (var item in fetchedItems) {
          extractedLots.add(
            Lot(
              siteId: item['siteId'],
              id: item['id'],
              lotId: item['lot_id'],
              code: item['code'],
              name: item['batiment'],
              edp: item['edp'],
              ep: item['ep'],
              age: item['age'],
              firstAge: item['firstAge'],
              lastAge: item['lastAge'],
              prod: item['isProd'],
            ),
          );
        }
        lots = extractedLots;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING LOTS");
      }
    } catch (e) {
      rethrow;
    }
  }

  List<_Bat> _bats = [
    // FETCHED DATA ...
  ];

  List<_Bat> get batsGetter {
    return [
      ..._bats
    ];
  }

  Future<void> fetchAllBats(siteId) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-bats-mob/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(
      {
        'site': siteId
      },
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedItems = json.decode(responseBody) as List;
        final List<_Bat> extractedLots = [];
        for (var item in fetchedItems) {
          extractedLots.add(_Bat(
            name: item['name'],
            id: item['id'],
            isEmpty: item['isEmpty'],
            type: item['type'],
          ));
        }
        _bats = extractedLots;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING LOTS");
      }
    } catch (e) {
      rethrow;
    }
  }

  List<TableData> _reports = [
    // FETCHED DATA ...
  ];

  List<TableData> get reportsData {
    return [
      ..._reports
    ];
  }

  Future<void> fetchReports(lotId, startAge, lastAge) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-table-data-mob/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(
      {
        "lotId": lotId,
        'startSlice': startAge,
        'endSlice': lastAge
      },
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedItems = json.decode(responseBody) as List;
        final List<TableData> extractedReps = [];
        for (var rep in fetchedItems) {
          extractedReps.add(
            TableData(edp: rep['effectifDP'], ep: rep['effectifP'], calendar: rep['calendrier'], consumption: rep['consommation'], indiceConver: rep['indice_conver'], lumiere: rep['lumiere'], flash: rep['flash'], params: rep['params']),
          );
          _reports = extractedReps;
        }
        notifyListeners();
      } else {
        throw Exception("${response.statusCode} (Aucune donnée disponible)");
      }
    } catch (e) {
      rethrow;
    }
  }

  List<_Guide> _guides = [
    // FETCHED DATA ...
  ];

  List<_Guide> get getGuides {
    return [
      ..._guides
    ];
  }

  Future<void> fetchActiveGuides() async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-active-mob-guides/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedGuides = json.decode(responseBody);
        final List<_Guide> extractedReps = [];
        for (var guide in fetchedGuides) {
          extractedReps.add(
            _Guide(id: guide['id'], name: guide['name'], type: 'PH'),
          );
          _guides = extractedReps;
        }
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING GUIDES");
      }
    } catch (e) {
      rethrow;
    }
  }

  late PrefilledProd _prefilledCreateData;

  PrefilledProd get prefilledCreateData {
    return _prefilledCreateData;
  }

  Future<void> fetchPrefilledProdForm(batId) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-next-send/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(
      {
        "batiment": batId,
      },
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedData = json.decode(responseBody);
        _prefilledCreateData = PrefilledProd(closed: fetchedData['closed'], date: fetchedData['nextDate'], lotCode: fetchedData['lot_code'], lastRepData: fetchedData['last_rep']);
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING PREFILLING DATA");
      }
    } catch (e) {
      rethrow;
    }
  }

  late BottomSheetTable _daysData;

  BottomSheetTable get paramDays {
    return _daysData;
  }

  Future<void> fetchDaysReports(lotId, age, paramId) async {
    final url = Uri.parse('https://farmdriver.savas.ma/api/get-param-days/');

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return;
    }
    final accessToken = jsonDecode(prefs.getString('userdata') ?? '')['token'];
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
    final body = json.encode(
      {
        "lotId": lotId,
        'age': age,
        'param_id': paramId
      },
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = utf8.decode(response.bodyBytes);
        final fetchedItems = json.decode(responseBody) as Map;
        _daysData = BottomSheetTable(header: fetchedItems['head'] ?? [], body: fetchedItems['data'] ?? [], dates: fetchedItems['dates'], name: fetchedItems['name']);
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING REPORTS");
      }
    } catch (e) {
      rethrow;
    }
  }
}

class PrefilledProd {
  final String date;
  final String lotCode;
  final bool closed;
  final Map<String, dynamic> lastRepData;

  PrefilledProd({required this.date, required this.lotCode, required this.closed, required this.lastRepData});
}

// {nextDate: 05/04/2023, type: day, closed: false, lot_code: LOT_IN_B1_TALMOUST, last_rep: {formule: DIK3421, lumiere_alum: 05:00, lumiere_extin: 20:00, flash_alum: null, flash_extin: null, intensite: 0, intensIsLux: false, coloration: null, qty_coquille: 3}}

class BottomSheetTable {
  final String name;
  final List dates;
  final List header;
  final List body;

  BottomSheetTable({required this.header, required this.body, required this.dates, required this.name});
}

class _ParamDays {
  final String day;
  final String date;
  final double reel;
  final double ecart;

  _ParamDays({
    required this.day,
    required this.date,
    required this.reel,
    required this.ecart,
  });
}

class TableData {
  final int edp;
  final int ep;
  final Map calendar;
  final Map consumption;
  final Map indiceConver;
  final Map lumiere;
  final Map flash;
  final List params;

  TableData({
    required this.edp,
    required this.ep,
    required this.calendar,
    required this.consumption,
    required this.indiceConver,
    required this.lumiere,
    required this.flash,
    required this.params,
  });
}

class _Guide {
  final int id;
  final String name;
  final String type;

  _Guide({
    required this.id,
    required this.name,
    required this.type,
  });
}

class _Bat {
  final String name;
  final int id;
  final bool isEmpty;
  final String type;

  _Bat({required this.name, required this.id, required this.isEmpty, required this.type});
}

class Lot {
  final int siteId;
  final int id;
  final int lotId;
  final String code;
  final String name;
  final bool prod;
  final int? edp;
  final int? ep;
  final int? age;
  final int? firstAge;
  final int? lastAge;

  Lot({
    required this.siteId,
    required this.id,
    required this.lotId,
    required this.code,
    required this.name,
    required this.prod,
    this.firstAge,
    this.lastAge,
    this.edp,
    this.ep,
    this.age,
  });
}

class Site {
  final int id;
  final String name;
  final int lotNbr;
  final bool pouss;

  Site({
    required this.id,
    required this.name,
    required this.lotNbr,
    required this.pouss,
  });
}

// class _Batiment {
//   final String? id;
//   final String? name;
//   final String? effectif;
//   final String? age;
//   _Batiment();
// }
