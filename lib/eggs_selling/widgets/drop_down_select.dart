import 'package:flutter/material.dart';

class OperationSelect extends StatefulWidget {
  final List<SelectOption> inputsOptions;
  final String name;
  final Function getter;
  final Color borderColor;
  const OperationSelect({
    super.key,
    required this.inputsOptions,
    required this.name,
    required this.getter,
    required this.borderColor,
  });

  @override
  State<OperationSelect> createState() => _OperationSelectState();
}

class _OperationSelectState extends State<OperationSelect> {
  @override
  Widget build(BuildContext context) {
    int? dropdownValue;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor, // Border color
          width: 1.4, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      child: DropdownButtonFormField<int>(
        dropdownColor: Colors.white,
        hint: Text(widget.name),
        value: dropdownValue,
        items: widget.inputsOptions.map<DropdownMenuItem<int>>((SelectOption value) {
          return DropdownMenuItem<int>(
            value: value.id,
            child: Text(
              value.value,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
          );
        }).toList(),
        onChanged: (int? newValue) {
          setState(() {
            dropdownValue = newValue!;
            widget.getter(dropdownValue);
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class SelectOption {
  int id;
  String value;
  SelectOption({required this.id, required this.value});
}
