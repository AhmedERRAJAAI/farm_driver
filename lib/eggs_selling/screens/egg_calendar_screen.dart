import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/operation_list_item.dart';
import 'package:provider/provider.dart';
import '../providers/mouvements_provider.dart';

class EggCalendarScreen extends StatefulWidget {
  const EggCalendarScreen({super.key});
  static const routeName = 'egg-calendar/';

  @override
  State<EggCalendarScreen> createState() => _EggCalendarScreenState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class _EggCalendarScreenState extends State<EggCalendarScreen> {
  DateTime _today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focuedDay) {
    setState(() {
      _today = day;
      getDateSorties("${day.year}-${day.month}-${day.day}");
    });
  }

  bool isLoading = false;
  bool requestFailed = false;

  void getDateSorties(date) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<MouvementProvider>(context, listen: false).fetchDateMouvements(date: date).then((_) {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Calendrier",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        backgroundColor: Color(0xFF145da0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TableCalendar(
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true, titleTextStyle: TextStyle(color: Color(0xFF145da0), fontSize: 18), leftChevronMargin: EdgeInsets.zero, rightChevronMargin: EdgeInsets.zero),
                availableGestures: AvailableGestures.all,
                rowHeight: 40,
                locale: 'fr_FR',
                focusedDay: _today,
                firstDay: DateTime.utc(2015, 01, 01),
                lastDay: DateTime.utc(2030, 01, 01),
                selectedDayPredicate: (day) => isSameDay(day, _today),
                onDaySelected: _onDaySelected,
              ),
              isLoading
                  ? SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      children: mouvements.map((mouv) {
                        return OperationListOneItem(
                          batiment: mouv.bat ?? "",
                          name: mouv.client,
                          date: mouv.date,
                          id: mouv.id,
                          operType: mouv.outType,
                          pu: mouv.pu,
                          qty: mouv.qty,
                        );
                      }).toList(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
