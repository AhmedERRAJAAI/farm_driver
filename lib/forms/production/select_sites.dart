import 'package:flutter/material.dart';

class SelectSites extends StatefulWidget {
  final String selectName;
  final List sites;
  final Function fetch;
  final Function selectedVal;
  SelectSites(
      {required this.sites,
      required this.fetch,
      required this.selectedVal,
      required this.selectName});

  @override
  State<SelectSites> createState() => _SelectSitesState();
}

class _SelectSitesState extends State<SelectSites> {
  @override
  Widget build(BuildContext context) {
    int selected = widget.sites.isEmpty ? 0 : widget.sites[0].id;
    widget.selectedVal(selected);
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        borderRadius: BorderRadius.circular(8.0), // Border radius
      ),
      duration: const Duration(milliseconds: 300),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        value: selected.toString(),
        items: widget.sites.map((option) {
          return DropdownMenuItem<String>(
            value: option.id.toString(),
            child: Text(option.name.toString()),
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
          labelText: 'sélectionner un ${widget.selectName}',
        ),
      ),
    );
  }
}
