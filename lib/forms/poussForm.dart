import 'package:flutter/material.dart';

import './poussiniere/prophylaxis_post.dart';

class PoussForm extends StatefulWidget {
  final List poussBats;
  PoussForm({required this.poussBats});

  @override
  State<PoussForm> createState() => _PoussFormState();
}

class _PoussFormState extends State<PoussForm> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    // String selectedBatiment = bats.isEmpty ? '' : bats[0].id.toString();
    return Column(
      children: [
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   margin: const EdgeInsets.only(bottom: 6),
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: Colors.grey, // Border color
        //       width: 1.0, // Border width
        //     ),
        //     borderRadius: BorderRadius.circular(8.0), // Border radius
        //   ),
        //   child: DropdownButtonFormField<String>(
        //     value: selectedBatiment.toString(),
        //     items: widget.poussBats.map((option) {
        //       return DropdownMenuItem<String>(
        //         value: option.id.toString(),
        //         child: Text('(${option.batName}) ${option.code}'),
        //       );
        //     }).toList(),
        //     onChanged: batsAreLoading
        //         ? null
        //         : (newValue) {
        //             setState(() {
        //               selectedBatiment = '$newValue';
        //             });
        //           },
        //     decoration: const InputDecoration(
        //       border: InputBorder.none,
        //       labelText: 'sélectionner un lot',
        //     ),
        //   ),
        // ),
        ProphylaxisPost(),
      ],
    );
  }
}
