import 'package:flutter/material.dart';

class ProductionPost extends StatefulWidget {
  final TextEditingController prodNormController;
  final TextEditingController prodDjController;
  final TextEditingController prodBlancController;
  final TextEditingController prodCasseController;
  final TextEditingController prodFelesController;
  final TextEditingController prodElimnController;
  final TextEditingController pmoController;
  final Color postColor;
  final bool closed;

  const ProductionPost({super.key, 
    required this.closed,
    required this.prodNormController,
    required this.prodDjController,
    required this.prodBlancController,
    required this.prodCasseController,
    required this.prodFelesController,
    required this.prodElimnController,
    required this.pmoController,
    required this.postColor,
  });

  @override
  State<ProductionPost> createState() => _ProductionPostState();
}

class _ProductionPostState extends State<ProductionPost> {
  bool _prodIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: _prodIsExpanded ? Colors.white : widget.postColor,
        border: Border.all(
          color: widget.postColor, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      height: _prodIsExpanded ? 290.0 : 80.0, // Change the height when expanded
      child: _prodIsExpanded
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
                              'Production',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _prodIsExpanded
                                    ? widget.postColor
                                    : Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.egg,
                              color: _prodIsExpanded
                                  ? widget.postColor
                                  : Colors.white,
                            )
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _prodIsExpanded = !_prodIsExpanded;
                            });
                          },
                          child: Transform.rotate(
                            angle: _prodIsExpanded
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
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: widget.prodNormController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Normaux'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: widget.prodDjController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Double jaunes'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: widget.prodBlancController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Blancs'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: widget.prodCasseController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Cassés'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: Center(
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: widget.prodFelesController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Félés'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: deviceSize.height * 0.06,
                              width: deviceSize.width * 0.46,
                              child: TextFormField(
                                controller: widget.prodElimnController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Éliminées'),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        SizedBox(
                          height: deviceSize.height * 0.06,
                          child: Center(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: widget.pmoController,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "poids moyen d'oeuf"),
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
                            'Production',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _prodIsExpanded
                                  ? widget.postColor
                                  : Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.egg,
                            color: _prodIsExpanded
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
                            _prodIsExpanded = !_prodIsExpanded;
                          });
                        },
                        child: Transform.rotate(
                          angle:
                              _prodIsExpanded ? 180 * (3.14159265359 / 180) : 0,
                          child: Icon(
                            Icons.expand_more,
                            color: _prodIsExpanded
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
