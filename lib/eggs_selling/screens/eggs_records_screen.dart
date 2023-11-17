import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './egg_all_operations_screen.dart';
import './EggsOperationFormScreen.dart';

class EggMouvementRecords extends StatefulWidget {
  const EggMouvementRecords({super.key});
  static const routeName = "egg-mouv-records";

  @override
  State<EggMouvementRecords> createState() => _EggMouvementRecordsState();
}

class _EggMouvementRecordsState extends State<EggMouvementRecords> {
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        backgroundColor: const Color(0xFF145da0),
        title: const Text(
          "Enregistrements",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OperationsFilter(
                      clientsOptions: null,
                      clientGetter: null,
                    );
                  });
            },
            icon: const Icon(
              Icons.tune,
              size: 24,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: [
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: CupertinoSegmentedControl(
                padding: EdgeInsets.zero,
                children: {
                  0: Text('sorties'),
                  1: Text('entrées'),
                },
                groupValue: selectedPage,
                onValueChanged: (value) {
                  setState(() {
                    selectedPage = value as int;
                  });
                },
              ),
            ),
            for (int i = 0; i <= 20; i++) RecordListItem(selectedPage: selectedPage),
            SizedBox(height: 90),
          ]),
        ),
      ),
    );
  }
}

class RecordListItem extends StatelessWidget {
  final int selectedPage;
  const RecordListItem({super.key, required this.selectedPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Client"),
            Text(
              "23/01/2023",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "12000000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: selectedPage == 0 ? SortieMovement(id: 9) : EntreeMovement(id:9),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


