import 'package:flutter/material.dart';
import '../widgets/operation_list_item.dart';
import '../widgets/drop_down_select.dart';
import '../widgets/dates_filter.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';

class EggAllOperations extends StatefulWidget {
  const EggAllOperations({super.key});
  static const routeName = "egg-opérations/";

  @override
  State<EggAllOperations> createState() => _EggAllOperationsState();
}

class _EggAllOperationsState extends State<EggAllOperations> {
  bool isLoading = false;
  bool requestFailed = false;
  bool _isInit = true;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getDaysPrices(100);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getDaysPrices(period) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchMouvments(count: period, isEntree: false).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
      });
    }
  }

  String? filterFisrtDate;
  String? filterLastDate;
  void filterFirstDateGetter(String date) {
    setState(() {
      filterFisrtDate = date;
    });
  }

  void filterLastDateGetter(String date) {
    setState(() {
      filterLastDate = date;
    });
  }

  void clearFilter() {
    setState(() {
      filterFisrtDate = null;
      filterLastDate = null;
      getDaysPrices(100);
    });
  }

  void clientGetter(value) {}
  @override
  Widget build(BuildContext context) {
    final mouvements = Provider.of<MouvementProvider>(context).mouvements;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        title: const Text(
          "Opérations",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
       
        backgroundColor: Color(0xFF145da0),
      ),
      body: ListView.builder(
        itemCount: mouvements.length,
        itemBuilder: ((context, i) {
          return OperationListOneItem(batiment: mouvements[i].bat ?? "", name: mouvements[i].client, date: mouvements[i].date, id: mouvements[i].id, operType: mouvements[i].outType, pu: mouvements[i].pu, qty: mouvements[i].qty);
        }),
      ),
    );
  }
}
