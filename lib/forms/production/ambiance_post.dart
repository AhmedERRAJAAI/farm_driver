import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class AmbiancePost extends StatefulWidget {
  final TextEditingController poidsVifController;
  final TextEditingController homogController;
  final Color postColor;
  final Function lOnGetter;
  final Function lOffGetter;
  final Function fOnGetter;
  final Function fOffGetter;
  final Function liDurGetter;
  final Function flDurGetter;
  final Function intensiteGetter;
  final Function intensiteUnit;
  final Function tempIntMinGetter;
  final Function tempIntMaxGetter;
  final Function tempExtMinGetter;
  final Function tempExtMaxGetter;
  final bool closed;
  final bool ready;
  final Map<String, dynamic> prevData;

  const AmbiancePost({super.key, 
    required this.ready,
    required this.prevData,
    required this.closed,
    required this.tempIntMinGetter,
    required this.tempIntMaxGetter,
    required this.tempExtMinGetter,
    required this.tempExtMaxGetter,
    required this.lOnGetter,
    required this.lOffGetter,
    required this.fOnGetter,
    required this.fOffGetter,
    required this.liDurGetter,
    required this.flDurGetter,
    required this.poidsVifController,
    required this.homogController,
    required this.postColor,
    required this.intensiteGetter,
    required this.intensiteUnit,
  });

  @override
  State<AmbiancePost> createState() => _AmbiancePostState();
}

class _AmbiancePostState extends State<AmbiancePost> {
  TimeOfDay lightOn = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay lightOff = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay lightDuration = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashOn = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashOff = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay flashDuration = const TimeOfDay(hour: 00, minute: 00);
  double intensite = 0.0;
  double _tempMin = 0.0;
  double _tempMax = 0.0;
  double _tempExMin = 0.0;
  double _tempExMax = 0.0;
  bool _ambianceIsExpanded = false;
  bool isLux = false;

  TimeOfDay calculateTimeDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final int startMinutes = startTime.hour * 60 + startTime.minute;
    final int endMinutes = endTime.hour * 60 + endTime.minute;
    late TimeOfDay duration;

    if (startMinutes < endMinutes) {
      final int durationMinutes = endMinutes - startMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else if (startMinutes > endMinutes) {
      final int durationMinutes = (24 * 60 - startMinutes) + endMinutes;
      final int hours = durationMinutes ~/ 60;
      final int minutes = durationMinutes % 60;
      duration = TimeOfDay(hour: hours, minute: minutes);
    } else {
      duration = const TimeOfDay(hour: 0, minute: 0);
      // Same time, duration is 0.
    }
    return duration;
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    List<String> parts = timeString.split(':');
    if (parts.length == 2) {
      int hour = int.tryParse(parts[0]) ?? 0;
      int minute = int.tryParse(parts[1]) ?? 0;

      return TimeOfDay(hour: hour, minute: minute);
    } else {
      // Handle invalid input, such as "00:00:00" or "00"
      return const TimeOfDay(hour: 00, minute: 00);
    }
  }

  bool _isInit = true;

  @override
  void initState() {
    // isLoading = true;
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {}
    _isInit = false;
    super.didChangeDependencies();
  }

  bool localReady = true;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    if (widget.ready && localReady) {
      if (widget.prevData.isNotEmpty) {
        lightOn = stringToTimeOfDay(widget.prevData['lumiere_alum'] ?? '');
        lightOff = stringToTimeOfDay(widget.prevData['lumiere_extin'] ?? '');
        lightDuration = stringToTimeOfDay(widget.prevData['lightDuration'] ?? '');
        flashOn = stringToTimeOfDay(widget.prevData['flash_alum'] ?? '');
        flashOff = stringToTimeOfDay(widget.prevData['flash_alum'] ?? '');
        flashDuration = stringToTimeOfDay(widget.prevData['flashDuration'] ?? '');
        intensite = double.parse("${widget.prevData['intensite'] ?? '0.0'}");
        isLux = widget.prevData['intensIsLux'];
        _tempMin = double.parse("${widget.prevData['tempIntMin'] ?? '0.0'}");
        _tempMax = double.parse("${widget.prevData['tempIntMax'] ?? '0.0'}");
        _tempExMin = double.parse("${widget.prevData['tempExtMin'] ?? '0.0'}");
        _tempExMax = double.parse("${widget.prevData['tempExtMax'] ?? '0.0'}");
      }
      setState(() {
        localReady = false;
      });
    }
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: _ambianceIsExpanded ? Colors.white : widget.postColor,
        border: Border.all(
          color: widget.postColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      height: _ambianceIsExpanded ? 420.0 : 80.0, // Change the height when expanded
      child: _ambianceIsExpanded
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Ambiance',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: widget.postColor,
                              ),
                            ),
                            Icon(
                              Icons.sentiment_satisfied,
                              color: _ambianceIsExpanded ? widget.postColor : Colors.white,
                            )
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _ambianceIsExpanded = !_ambianceIsExpanded;
                            });
                          },
                          child: Transform.rotate(
                            angle: _ambianceIsExpanded ? 180 * (3.14159265359 / 180) : 0,
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.green.shade700,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.4,
                              child: OutlinedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    cancelText: 'Annuler',
                                    initialTime: lightDuration,
                                    initialEntryMode: TimePickerEntryMode.inputOnly,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                        child: child ?? const Text(''),
                                      );
                                    },
                                  );
                                  if (newTime == null) return;
                                  setState(() {
                                    lightOn = const TimeOfDay(hour: 00, minute: 00);
                                    lightOff = const TimeOfDay(hour: 00, minute: 00);
                                    lightDuration = newTime;
                                    widget.lOnGetter(lightOn);
                                    widget.lOffGetter(lightOff);
                                    widget.liDurGetter(lightDuration);
                                  });
                                },
                                child: FittedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text('Lumiére'),
                                      const Icon(Icons.timelapse_sharp),
                                      Text("${lightDuration.hour}h: ${lightDuration.minute}m")
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.2,
                              child: OutlinedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    cancelText: 'Annuler',
                                    context: context,
                                    initialTime: lightOn,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                        child: child ?? const Text(''),
                                      );
                                    },
                                  );
                                  if (newTime == null) return;
                                  setState(() {
                                    lightOn = newTime;
                                    lightDuration = calculateTimeDuration(lightOn, lightOff);
                                    widget.lOnGetter(lightOn);
                                    widget.liDurGetter(lightDuration);
                                  });
                                },
                                child: FittedBox(
                                  child: Text('ON: ${lightOn.hour}:${lightOn.minute}'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.2,
                              child: OutlinedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    cancelText: 'Annuler',
                                    context: context,
                                    initialTime: lightOff,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                        child: child ?? const Text(''),
                                      );
                                    },
                                  );
                                  if (newTime == null) return;

                                  setState(() {
                                    lightOff = newTime;
                                    lightDuration = calculateTimeDuration(lightOn, lightOff);
                                    widget.lOffGetter(lightOff);
                                    widget.liDurGetter(lightDuration);
                                  });
                                },
                                child: FittedBox(
                                  child: Text('OFF: ${lightOff.hour}:${lightOff.minute}'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.4,
                              child: OutlinedButton(
                                  onPressed: () async {
                                    TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      cancelText: 'Annuler',
                                      initialTime: flashDuration,
                                      initialEntryMode: TimePickerEntryMode.inputOnly,
                                      builder: (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                          child: child ?? const Text(''),
                                        );
                                      },
                                    );
                                    if (newTime == null) return;
                                    setState(() {
                                      flashOn = const TimeOfDay(hour: 00, minute: 00);
                                      flashOff = const TimeOfDay(hour: 00, minute: 00);
                                      flashDuration = newTime;
                                      widget.fOnGetter(flashOn);
                                      widget.fOffGetter(flashOff);
                                      widget.flDurGetter(flashDuration);
                                    });
                                  },
                                  child: FittedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const Text('Flash'),
                                        const Icon(Icons.timelapse_sharp),
                                        Text("${flashDuration.hour}h: ${flashDuration.minute}m")
                                      ],
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.2,
                              child: OutlinedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: flashOn,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                        child: child ?? const Text(''),
                                      );
                                    },
                                  );
                                  if (newTime == null) return;
                                  setState(() {
                                    flashOn = newTime;
                                    flashDuration = calculateTimeDuration(flashOn, flashOff);
                                    widget.fOnGetter(flashOn);
                                    widget.flDurGetter(flashDuration);
                                  });
                                },
                                child: FittedBox(
                                  child: Text('ON: ${flashOn.hour}:${flashOn.minute}'),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.2,
                              child: OutlinedButton(
                                onPressed: () async {
                                  TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: flashOff,
                                    builder: (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                        child: child ?? const Text(''),
                                      );
                                    },
                                  );
                                  if (newTime == null) return;
                                  setState(() {
                                    flashOff = newTime;
                                    flashDuration = calculateTimeDuration(flashOn, flashOff);
                                    widget.fOffGetter(flashOff);
                                    widget.flDurGetter(flashDuration);
                                  });
                                },
                                child: FittedBox(
                                  child: Text('OFF: ${flashOff.hour}:${flashOff.minute}'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Container(
                          width: deviceSize.width,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: isLux ? Colors.amber.shade900 : Colors.yellow.shade800, width: 1.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Intensité   '),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            height: isLux ? (intensite / 2) : intensite / 100 * 22,
                                            width: 22,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: isLux ? Colors.amber.shade900.withOpacity(intensite / 44) : Colors.yellow.shade800.withOpacity(intensite / 100), // Color of the shadow
                                                  spreadRadius: 10, // Spread radius
                                                  blurRadius: 10, // Blur radius
                                                  offset: const Offset(0, 0), // Offset of the shadow
                                                ),
                                              ],
                                              color: isLux ? Colors.amber.shade900 : Colors.yellow.shade800,
                                              // border:
                                              //     Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(22),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "${intensite.toStringAsFixed(0)} ${isLux ? 'Lx' : '%'}",
                                                style: const TextStyle(color: Colors.transparent),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "${intensite.toStringAsFixed(0)} ${isLux ? 'Lx' : '%'}",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Lux',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Switch(
                                        value: !isLux,
                                        activeColor: Colors.yellow.shade800,
                                        inactiveThumbColor: Colors.amber.shade900,
                                        onChanged: (bool value) {
                                          setState(() {
                                            isLux = !isLux;
                                            widget.intensiteUnit(isLux);
                                            intensite = 0;
                                            widget.intensiteGetter(intensite);
                                          });
                                        },
                                      ),
                                      const Text(
                                        '%',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              isLux
                                  ? Expanded(
                                      child: Slider.adaptive(
                                        activeColor: Colors.amber.shade900,
                                        value: intensite,
                                        max: 44,
                                        min: 0,
                                        divisions: 20,
                                        label: intensite.round().toString(),
                                        onChanged: (double value) {
                                          setState(() {
                                            intensite = value;
                                            widget.intensiteGetter(intensite);
                                          });
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: Slider.adaptive(
                                        activeColor: Colors.yellow.shade700,
                                        value: intensite,
                                        max: 100,
                                        min: 0,
                                        divisions: 20,
                                        label: intensite.round().toString(),
                                        onChanged: (double value) {
                                          setState(() {
                                            intensite = value;
                                          });
                                        },
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.46,
                              child: Center(
                                child: TextFormField(
                                  controller: widget.poidsVifController,
                                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0), border: OutlineInputBorder(), labelText: 'Poids corporel'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.05,
                              width: deviceSize.width * 0.44,
                              child: Center(
                                child: TextFormField(
                                  controller: widget.homogController,
                                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 0), border: OutlineInputBorder(), labelText: 'Homogéniété'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'cant be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: deviceSize.width * 0.46,
                                padding: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    const Text('Temperature intérieur'),
                                    OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: ((ctx) => NumberPickerDialog(
                                                  initialValue: _tempMin, // Pass initial value
                                                  onChanged: (value) {
                                                    // Update _coloration when the value changes
                                                    setState(() {
                                                      _tempMin = value;
                                                      widget.tempIntMinGetter(value);
                                                    });
                                                  },
                                                )),
                                          );
                                        },
                                        child: FittedBox(
                                          child: Text('Min $_tempMin'),
                                        )),
                                    OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: ((ctx) => NumberPickerDialog(
                                                  initialValue: _tempMax, // Pass initial value
                                                  onChanged: (value) {
                                                    // Update _coloration when the value changes
                                                    setState(() {
                                                      _tempMax = value;
                                                      widget.tempIntMaxGetter(value);
                                                    });
                                                  },
                                                )),
                                          );
                                        },
                                        child: FittedBox(
                                          child: Text('Max $_tempMax'),
                                        )),
                                  ],
                                )),
                            Container(
                                padding: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                width: deviceSize.width * 0.44,
                                child: Column(
                                  children: [
                                    const Text('Temperature extérieure'),
                                    OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: ((ctx) => NumberPickerDialog(
                                                  initialValue: _tempExMin, // Pass initial value
                                                  onChanged: (value) {
                                                    // Update _coloration when the value changes
                                                    setState(() {
                                                      _tempExMin = value;
                                                      widget.tempExtMinGetter(value);
                                                    });
                                                  },
                                                )),
                                          );
                                        },
                                        child: FittedBox(
                                          child: Text('Min $_tempExMin'),
                                        )),
                                    OutlinedButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: ((ctx) => NumberPickerDialog(
                                                  initialValue: _tempExMax, // Pass initial value
                                                  onChanged: (value) {
                                                    // Update _coloration when the value changes
                                                    setState(() {
                                                      _tempExMax = value;
                                                      widget.tempExtMaxGetter(value);
                                                    });
                                                  },
                                                )),
                                          );
                                        },
                                        child: FittedBox(
                                          child: Text('Max $_tempExMax'),
                                        )),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Ambiance',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _ambianceIsExpanded ? widget.postColor : Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.sentiment_satisfied,
                            color: _ambianceIsExpanded ? widget.postColor : Colors.white,
                          )
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          widget.closed
                              ? null
                              : setState(() {
                                  _ambianceIsExpanded = !_ambianceIsExpanded;
                                });
                        },
                        child: Transform.rotate(
                          angle: _ambianceIsExpanded ? 180 * (3.14159265359 / 180) : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: _ambianceIsExpanded ? widget.postColor : Colors.white,
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

class NumberPickerDialog extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;

  const NumberPickerDialog({super.key, required this.initialValue, required this.onChanged});

  @override
  _NumberPickerDialogState createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  double _coloration = 0.0;

  @override
  void initState() {
    super.initState();
    _coloration = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: DecimalNumberPicker(
        haptics: true,
        axis: Axis.horizontal,
        value: _coloration,
        minValue: -20,
        maxValue: 60,
        decimalPlaces: 1,
        textStyle: const TextStyle(color: Colors.blue),
        onChanged: (value) {
          setState(() {
            _coloration = value;
          });
          widget.onChanged(value); // Notify the parent about the change
        },
      ),
    );
  }
}
