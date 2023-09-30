import 'package:flutter/material.dart';

class InitFormSelect extends StatefulWidget {
  final String selectName;
  final List inputsOptions;
  final Function fetch;
  final Function selectedVal;
  final Color themeColor;
  const InitFormSelect({super.key, required this.inputsOptions, required this.fetch, required this.selectedVal, required this.selectName, required this.themeColor});

  @override
  State<InitFormSelect> createState() => _InitFormSelectState();
}

class _InitFormSelectState extends State<InitFormSelect> {
  @override
  Widget build(BuildContext context) {
    int selected = widget.inputsOptions.isEmpty ? 0 : widget.inputsOptions[0].id;
    widget.selectedVal(selected);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.themeColor, // Border color
          width: 1.4, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        value: selected.toString(),
        items: widget.inputsOptions.map((option) {
          return DropdownMenuItem<String>(
            value: option.id.toString(),
            child: Text("${option.name}"),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selected = int.parse(newValue ?? '0');
            widget.fetch(selected);
            widget.selectedVal(selected);
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'sélectionner ${widget.selectName}',
        ),
      ),
    );
  }
}
