import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConsoPost extends StatefulWidget {
  final TextEditingController consoAltController;
  final TextEditingController consoEauController;
  final TextEditingController consoFormuleController;
  final Color postColor;
  final bool closed;

  ConsoPost({
    required this.closed,
    required this.consoAltController,
    required this.consoEauController,
    required this.consoFormuleController,
    required this.postColor,
  });

  @override
  State<ConsoPost> createState() => _ConsoPostState();
}

class _ConsoPostState extends State<ConsoPost> {
  bool _consoIsExpanded = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: _consoIsExpanded ? Colors.white : widget.postColor,
        border: Border.all(
          color: widget.postColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      height:
          _consoIsExpanded ? 200.0 : 80.0, // Change the height when expanded
      child: _consoIsExpanded
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Consommation',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: widget.postColor,
                              ),
                            ),
                            Icon(
                              MdiIcons.barley,
                              color: _consoIsExpanded
                                  ? Colors.white
                                  : widget.postColor,
                            )
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _consoIsExpanded = !_consoIsExpanded;
                            });
                          },
                          child: Transform.rotate(
                            angle: _consoIsExpanded
                                ? 180 * (3.14159265359 / 180)
                                : 0,
                            child: Icon(
                              Icons.expand_more,
                              color: widget.postColor,
                              size: 26,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: widget.consoAltController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Aliment (kg)'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: widget.consoEauController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Eau (litre)'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          height: deviceSize.height * 0.06,
                          // width: deviceSize.width * 0.43,
                          child: Center(
                            child: TextFormField(
                              controller: widget.consoFormuleController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Formule en place'),
                              keyboardType: TextInputType.number,
                            ),
                          ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Consommation',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _consoIsExpanded
                                  ? widget.postColor
                                  : Colors.white,
                            ),
                          ),
                          Icon(
                            MdiIcons.barley,
                            color: _consoIsExpanded
                                ? widget.postColor
                                : Colors.white,
                          )
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          widget.closed
                              ? null :
                          setState(() {
                            _consoIsExpanded = !_consoIsExpanded;
                          });
                        },
                        child: Transform.rotate(
                          angle: _consoIsExpanded
                              ? 180 * (3.14159265359 / 180)
                              : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: _consoIsExpanded
                                ? widget.postColor
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
