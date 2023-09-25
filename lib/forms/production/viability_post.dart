import 'package:flutter/material.dart';

class ViabilityPost extends StatefulWidget {
  final TextEditingController mortController;
  final TextEditingController sujetElimController;
  final bool closed;
  final Color postColor;

  ViabilityPost({
    required this.mortController,
    required this.sujetElimController,
    required this.closed,
    required this.postColor,
  });

  @override
  State<ViabilityPost> createState() => _ViabilityPostState();
}

class _ViabilityPostState extends State<ViabilityPost> {
  bool _viaIsExpanded = false;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: _viaIsExpanded ? Colors.white : widget.postColor,
        border: Border.all(
          color: widget.postColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      height: _viaIsExpanded ? 180.0 : 80.0, // Change the height when expanded
      child: _viaIsExpanded
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
                              'Viabilité',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: widget.postColor,
                              ),
                            ),
                            Icon(
                              Icons.stream,
                              color: _viaIsExpanded ? widget.postColor : Colors.white,
                            )
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _viaIsExpanded = !_viaIsExpanded;
                            });
                          },
                          child: Transform.rotate(
                            angle: _viaIsExpanded ? 180 * (3.14159265359 / 180) : 0,
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
                  const SizedBox(height: 6.0),
                  Container(
                    height: deviceSize.height * 0.05,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Center(
                      child: TextFormField(
                        controller: widget.mortController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1, color: widget.postColor),
                          ),
                          labelText: 'Nombre de mortalité',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Container(
                    height: deviceSize.height * 0.05,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Center(
                      child: TextFormField(
                        controller: widget.sujetElimController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 6),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                          ),
                          // fillColor: Colors.red,
                          labelText: 'Sujets triés',
                          // labelStyle: TextStyle(color: Colors.red),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
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
                            'Viabilité',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _viaIsExpanded ? widget.postColor : Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.stream,
                            color: _viaIsExpanded ? widget.postColor : Colors.white,
                          )
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          widget.closed
                              ? null
                              : setState(() {
                                  _viaIsExpanded = !_viaIsExpanded;
                                });
                        },
                        child: Transform.rotate(
                          angle: _viaIsExpanded ? 180 * (3.14159265359 / 180) : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: _viaIsExpanded ? widget.postColor : Colors.white,
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
