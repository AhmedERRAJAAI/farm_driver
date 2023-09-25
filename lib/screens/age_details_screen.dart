import 'package:flutter/material.dart';
import '../mywidgets/age_details.dart';

class AgeDetailsScreen extends StatefulWidget {
  const AgeDetailsScreen({super.key});
  static const routeName = "age-details-screen/";

  @override
  State<AgeDetailsScreen> createState() => _AgeDetailsScreenState();
}

class _AgeDetailsScreenState extends State<AgeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Age, lot)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
      body: AgeDetails(), //send the data of the clicked row to this widget
                         // send fetch just the missing data and pass it to this widget
    );
  }
}
