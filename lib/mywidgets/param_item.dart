import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sites_bats_provider.dart';
import './chip_widget.dart';
import './day_widget.dart';
import './table_header.dart';

class ParamItem extends StatefulWidget {
  final int id;
  final int age;
  final int lotId;
  final String paramName;
  final String? unity;
  final double reel;
  final double? guide;
  final double? ecart;
  final int? isUp;
  final String color;

  const ParamItem({super.key, 
    required this.id,
    required this.age,
    required this.lotId,
    required this.paramName,
    this.unity,
    this.guide,
    required this.reel,
    this.ecart,
    this.isUp,
    required this.color,
  });

  @override
  State<ParamItem> createState() => _ParamItemState();
}

class _ParamItemState extends State<ParamItem> {
  bool isLoading = false;
  List daysData = [];

  Future<void> fetchData(BuildContext context, age, id, lotId) async {
    setState(() {
      isLoading = true;
    });
    try {
      Provider.of<SitesBatsProvider>(context, listen: false).fetchDaysReports(lotId, age, id).then((_) {
        setState(() {
          // daysData = Provider.of<SitesBatsProvider>(context, listen: false).paramDays;
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  void _showModalBottomSheet(context, age, id, lotId) async {
    await fetchData(context, age, id, lotId).then((value) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 450,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('01/02/2023'),
                        Text('08/02/2023'),
                      ],
                    ),
                  ),
                  daysData.isEmpty
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          child: Column(
                            children: [
                              TableHeader(columns: daysData[0].header),
                              DayWidget(days: daysData[0].body),
                            ],
                          ),
                        ),
                ]),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet(context, widget.age, widget.id, widget.lotId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.paramName,
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                    ),
                  ),
                  Text(
                    widget.unity != null ? '(${widget.unity})' : "",
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 10),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.reel.toString(),
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  EcartChip(
                    colorName: widget.color,
                    directionIndex: widget.isUp ?? 1,
                    ecart: widget.ecart ?? 0,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.guide != null ? widget.guide.toString() : '-',
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
