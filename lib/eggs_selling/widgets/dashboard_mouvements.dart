import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';
import '../widgets/operation_list_item.dart';

class EggDashMouvments extends StatefulWidget {
  const EggDashMouvments({super.key});

  @override
  State<EggDashMouvments> createState() => _EggDashMouvmentsState();
}

class _EggDashMouvmentsState extends State<EggDashMouvments> {
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
      getDaysPrices(30);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getDaysPrices(period) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchMouvments(count: 10, isEntree: false).then((_) {
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

  @override
  Widget build(BuildContext context) {
    final mouvements = Provider.of<MouvementProvider>(context).mouvements;
    return isLoading
        ? SizedBox(
            height: 100,
            width: double.infinity,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            children: mouvements.map((mouv) {
              return OperationListOneItem(batiment: mouv.bat ?? "", name: mouv.client, date: mouv.date, id: mouv.id, operType: mouv.outType, pu: mouv.pu, qty: mouv.qty);
            }).toList(),
          );
  }
}
