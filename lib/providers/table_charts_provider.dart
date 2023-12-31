import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class TableAndChartsProvider with ChangeNotifier {
  static const String _base_url = "https://farmdriver.savas.ma/api";

  List<LtableData> _tableData = [
    // FETCHED DATA ...
  ];

  List<LtableData> get getTableData {
    return [
      ..._tableData
    ];
  }

  Future<void> fetchLargeTableData(int lotId, int sAge, int lAge) async {
    final url = Uri.parse('$_base_url/get-mob-large-table-data/?lotId=$lotId&startSlice=$sAge&endSlice=$lAge');

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
        final List<LtableData> extractedData = [];
        for (var item in fetchedItems) {
          extractedData.add(
            LtableData(
              lotId: item['lotId'],
              age: item['age'],
              year: item['year'],
              altCumlPd: item['alt_cuml_pd'],
              altDistCuml: item['alt_dist_cuml'],
              altOeufCuml: item['alt_oeuf_cuml'],
              altOeufSem: item['alt_oeuf_sem'],
              aps: item['aps'],
              eauDistCuml: item['eau_dist'],
              eps: item['eps'],
              flash: item['flash'],
              ic: item['ic_cuml'],
              homog: item['homog'],
              intensite: item['intensite'],
              isLux: item['isLux'],
              light: item['lumiere'],
              massOeufCuml: item['mass_oeuf_cuml'],
              massOeufSem: item['mass_oeuf_sem'],
              mortCuml: item['cent_mort_cuml'],
              mortSem: item['cent_mort_sem'],
              nbrPonte: item['ponte_nbr'],
              nopppSem: item['noppp_sem'],
              noppdCuml: item['noppd_cuml'],
              pmo: item['pmo'],
              poidVif: item['poid_vif'],
              ponteCent: item['ponte_cent'],
              ponteVar: item['ponte_var'],
              ratio: item['ratio'],
              coloration: item['coloration'],
              coquille: item['coquille'],
              ed: item['ed'],
              ep: item['ep'],
              semCivil: item['sem_civil'],
              icSem: item['ic_sem'],
              noppdSem: item['noppd_sem'],
              nopppCuml: item['noppp_cuml'],
              observs: item['observs'],
            ),
          );
        }
        _tableData = extractedData;
        notifyListeners();
      } else {
        throw Exception("ERROR  DURING FETCHING SITES");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // ------ FETCH GUIDE --------
  late GuidesData _guideData;
  GuidesData get getGuide {
    return _guideData;
  }

  Future<void> fetchGuide(lotId, paramId) async {
    final url = Uri.parse('$_base_url/get-param-guide-data-mob/?lotId=$lotId&paramId=$paramId');
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
        final fetchedGuide = json.decode(responseBody) as Map;
        _guideData = GuidesData(params: fetchedGuide['data']);
      } else {
        throw Exception("ERROR  DURING FETCHING GUIDE");
      }
    } catch (e) {
      rethrow;
    }
  }

  late PdfData _pdfPath;
  PdfData get getPdfPath {
    return _pdfPath;
  }

  Future<void> downloadPDF(String fileName, lotId, age) async {
    final url = Uri.parse('$_base_url/pdf-week/?lot_id=$lotId&age=$age');
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
      if (response.statusCode == 200) {
        final path = "/storage/emulated/0/Download/rapport_age_$age.pdf";
        File pdfFile = File(path);
        _pdfPath = PdfData(path: path);
        await pdfFile.writeAsBytes(response.bodyBytes);
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}

class PdfData {
  final String path;
  PdfData({required this.path});
}

class GuidesData {
  final List params;

  GuidesData({required this.params});

  // [{paramName: xxx, values: [1,2,3,4]}, {paramName: xxx, values: [1,2,3,4]}, ]
}

class LtableData {
  final int lotId;
  final int ep;
  final int ed;
  final int semCivil;
  final int year;
  final int age;
  final Map light;
  final Map flash;
  final int intensite;
  final bool isLux;
  final Map<String, dynamic> poidVif;
  final Map<String, dynamic> homog;
  final Map<String, dynamic> mortSem;
  final Map<String, dynamic> mortCuml;
  final double eauDistCuml;
  final int eps;
  final double altDistCuml;
  final int nbrPonte;
  final Map<String, dynamic> aps;
  final Map<String, dynamic> altCumlPd;
  final Map<String, dynamic> altOeufSem;
  final Map<String, dynamic> altOeufCuml;
  final Map<String, dynamic> massOeufCuml;
  final Map<String, dynamic> massOeufSem;
  final Map<String, dynamic> nopppSem;
  final Map<String, dynamic> noppdSem;
  final Map<String, dynamic> noppdCuml;
  final Map<String, dynamic> nopppCuml;
  final Map<String, dynamic> pmo;
  final Map<String, dynamic> ponteCent;
  final Map<String, dynamic> ponteVar;
  final Map<String, dynamic> ratio;
  final Map<String, dynamic> ic;
  final Map<String, dynamic> icSem;
  final List coloration;
  final List coquille;
  final List observs;

  LtableData({
    required this.lotId,
    required this.ep,
    required this.ed,
    required this.year,
    required this.semCivil,
    required this.age,
    required this.light,
    required this.flash,
    required this.intensite,
    required this.isLux,
    required this.poidVif,
    required this.homog,
    required this.mortSem,
    required this.mortCuml,
    required this.eauDistCuml,
    required this.eps,
    required this.altDistCuml,
    required this.nbrPonte,
    required this.aps,
    required this.altCumlPd,
    required this.altOeufSem,
    required this.altOeufCuml,
    required this.massOeufCuml,
    required this.massOeufSem,
    required this.nopppSem,
    required this.noppdSem,
    required this.noppdCuml,
    required this.nopppCuml,
    required this.pmo,
    required this.ponteCent,
    required this.ponteVar,
    required this.ratio,
    required this.ic,
    required this.icSem,
    required this.coloration,
    required this.coquille,
    required this.observs,
  });
}
