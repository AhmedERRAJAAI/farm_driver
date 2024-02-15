import 'package:flutter/material.dart';
import './eggs_records_screen.dart';
import './forms/sortie_form.dart';
import './forms/entree_form.dart';

class EggOperationForm extends StatefulWidget {
  static const routeName = 'operations-types/';
  const EggOperationForm({super.key});

  @override
  State<EggOperationForm> createState() => _EggOperationFormState();
}

class _EggOperationFormState extends State<EggOperationForm> {
  int isEntree = 0;
  Color selectedColor = Colors.blue;
  void toggleForms(int index) {
    setState(() {
      isEntree = index;
      if (index == 0) {
        selectedColor = Colors.blue;
      } else {
        selectedColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: isEntree == 1
            ? const Text(
                "Entrée",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              )
            : const Text(
                "Sortie",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
        backgroundColor: selectedColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EggMouvementRecords.routeName);
              },
              icon: Icon(
                Icons.read_more,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: isEntree == 1 ? EntreeMovement() : SortieMovement(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_up),
            label: 'Sortie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down),
            label: 'Entree',
          ),
        ],
        currentIndex: isEntree,
        selectedItemColor: selectedColor,
        onTap: toggleForms,
      ),
    );
  }
}
