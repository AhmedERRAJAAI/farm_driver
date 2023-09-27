import 'package:flutter/material.dart';

class ConstatPost extends StatefulWidget {
  final Color postColor;
  final Function colorGetter;
  final Function coquilleGetter;
  final Function observsGetter;
  final bool closed;

  const ConstatPost({super.key, 
    required this.closed,
    required this.postColor,
    required this.colorGetter,
    required this.coquilleGetter,
    required this.observsGetter,
  });

  @override
  State<ConstatPost> createState() => _ConstatPostState();
}

class _ConstatPostState extends State<ConstatPost> {
  bool _constatIsExpanded = false;
  final List<int> _coloration = [70, 80, 90, 100, 110];
  final List<int> _coquille = [1, 2, 3, 4, 5];
  Map<int, Color> observUrgColors = {
    0: Colors.red,
    1: Colors.orange,
    2: Colors.green,
    3: Colors.blue,
  };
  int urgIndex = 3;
  List<Map> observs = [];
  int selectedColoration = 70;
  int selectedCoquille = 3;

  final TextEditingController tempObserv = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: _constatIsExpanded ? Colors.white : Colors.yellow.shade700,
        border: Border.all(
          color: Colors.yellow.shade700, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      height:
          _constatIsExpanded ? 240.0 : 80.0, // Change the height when expanded
      child: _constatIsExpanded
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Constats',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow.shade700,
                              ),
                            ),
                            Icon(
                              Icons.visibility,
                              color: _constatIsExpanded
                                  ? Colors.yellow.shade700
                                  : Colors.white,
                            )
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _constatIsExpanded = !_constatIsExpanded;
                            });
                          },
                          child: Transform.rotate(
                            angle: _constatIsExpanded
                                ? 180 * (3.14159265359 / 180)
                                : 0,
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.yellow.shade700,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: deviceSize.width * 0.43,
                        padding: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Border radius
                        ),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: _coloration[0].toString(),
                          items: _coloration.map((option) {
                            return DropdownMenuItem<String>(
                              value: option.toString(),
                              child: Text(option.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedColoration = int.parse('$newValue');
                              widget.colorGetter(int.parse('$newValue'));
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Coloration d'oeuf",
                          ),
                        ),
                      ),
                      Container(
                        width: deviceSize.width * 0.43,
                        padding: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // Border color
                            width: 1.0, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Border radius
                        ),
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Colors.white,
                          value: _coquille[0].toString(),
                          items: _coquille.map((option) {
                            return DropdownMenuItem<String>(
                              value: option.toString(),
                              child: Row(children: [
                                for (int i = 0; i < option; i++)
                                  const Icon(Icons.star,
                                      color: Colors.blue, size: 15),
                              ]),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCoquille = int.parse('$newValue');
                              widget.coquilleGetter(int.parse('$newValue'));
                            });
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Qualité de coquille",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    // height: deviceSize.height * 0.05,
                    margin: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: deviceSize.width * 0.65,
                            child: TextFormField(
                              controller: tempObserv,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 0),
                                  border: OutlineInputBorder(),
                                  labelText: "Observation"),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: observUrgColors[urgIndex] ?? Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: observUrgColors[urgIndex] ?? Colors.blue,
                                width: 2.0, // Set the border width
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  urgIndex = urgIndex + 1;
                                  if (urgIndex > 3) {
                                    urgIndex = 0;
                                  }
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (tempObserv.text.isNotEmpty) {
                                setState(() {
                                  observs.add({
                                    'urg': urgIndex,
                                    'value': tempObserv.text
                                  });
                                  tempObserv.text = '';
                                  widget.observsGetter(observs);
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 32,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                      children: observs.map((obsrv) {
                    return Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: observUrgColors[obsrv['urg']] ??
                                    Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        width: deviceSize.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: deviceSize.width * 0.7,
                              child: Text('${obsrv['value']}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      overflow: TextOverflow.clip)),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    observs.removeWhere((ele) =>
                                        ele['value'] == obsrv['value']);
                                    widget.observsGetter(observs);
                                  });
                                },
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red, size: 23))
                          ],
                        ));
                  }).toList())
                ],
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Constats',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _constatIsExpanded
                                  ? Colors.yellow.shade700
                                  : Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.visibility,
                            color: _constatIsExpanded
                                ? Colors.yellow.shade700
                                : Colors.white,
                          )
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          widget.closed
                              ? null
                              : setState(() {
                                  _constatIsExpanded = !_constatIsExpanded;
                                });
                        },
                        child: Transform.rotate(
                          angle: _constatIsExpanded
                              ? 180 * (3.14159265359 / 180)
                              : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: _constatIsExpanded
                                ? Colors.yellow.shade700
                                : Colors.white,
                            size: 26,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
