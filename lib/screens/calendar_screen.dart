import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// import '../mywidgets/event_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  static const routeName = 'calendar/';

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
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

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focuedDay) {
    setState(() {
      _today = day;
    });
  }

  final List<Item> _data = generateItems(2);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF145da0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Calendrier",
          style: TextStyle(
              color: Color(0xFF145da0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TableCalendar(
              headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle:
                      TextStyle(color: Color(0xFF145da0), fontSize: 18),
                  leftChevronMargin: EdgeInsets.zero,
                  rightChevronMargin: EdgeInsets.zero),
              availableGestures: AvailableGestures.all,
              rowHeight: 40,
              locale: 'fr_FR',
              focusedDay: _today,
              firstDay: DateTime.utc(2015, 01, 01),
              lastDay: DateTime.utc(2030, 01, 01),
              selectedDayPredicate: (day) => isSameDay(day, _today),
              onDaySelected: _onDaySelected,
            ),
          ),
          Container(
            height: deviceSize.height * 0.5,
            child: SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return const ListTile(
                        title: Text('Nobilis Clone30'),
                        trailing: Text('22/11/2023'),
                      );
                    },
                    body: ListTile(
                      title: Text('Injection + NB'),
                      subtitle: const Text('R.Salm à j 1'),
                      trailing: Container(
                        width: deviceSize.width * 0.25,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(30)),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(30)),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _data.removeWhere((Item currentItem) =>
                                        item == currentItem);
                                  });
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isExpanded: item.isExpanded,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF145da0),
      //   child: FittedBox(
      //       child: Column(
      //     children: [
      //       const Icon(Icons.add),
      //       Text(DateFormat('dd/MM').format(_today)),
      //     ],
      //   )),
      //   onPressed: () {
      //     showDialog(
      //         context: context,
      //         builder: (context) {
      //           return AlertDialog(
      //             scrollable: true,
      //             title: Text("+ rappel"),
      //             content: Padding(
      //               padding: EdgeInsets.all(8),
      //               child: TextField(),
      //             ),
      //           );
      //         });
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
