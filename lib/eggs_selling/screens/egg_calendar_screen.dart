import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/operation_list_item.dart';
// import 'package:intl/intl.dart';

// import '../mywidgets/event_item.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                children: [
                  OperationListOneItem(batiment: "T1", name: "AZIZ", date: "09/11/2023", id: 0, operType: 0, pu: 0.95, qty: 90000),
                  OperationListOneItem(batiment: "T1", name: "T1", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 90000),
                  OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 2, pu: 0.95, qty: 90000),
                  OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 3, pu: 0.95, qty: 90000),
                  OperationListOneItem(batiment: "T1", name: "T2", date: "09/11/2023", id: 0, operType: 1, pu: null, qty: 100000),
                  OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 4, pu: 0.95, qty: 90000),
                  OperationListOneItem(batiment: "T1", name: "JOHN DOE", date: "09/11/2023", id: 0, operType: 0, pu: 0.95, qty: 90000),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
