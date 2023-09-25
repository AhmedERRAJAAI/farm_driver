import 'package:flutter/material.dart';
import './calendar_screen.dart';
import '../forms/production_form.dart';
import '../forms/lotForm.dart';
import '../forms/poussForm.dart';

class BeforeAddingScreen extends StatelessWidget {
  const BeforeAddingScreen({super.key});
  static const routeName = 'before-add-report/';

  goToPage(BuildContext ctx, routeName) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF145da0)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              goToPage(context, CalendarScreen.routeName);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              size: 24,
            ),
            color: const Color(0xFF145da0),
          ),
          const SizedBox(width: 10),
          PopupMenuButton(
            onSelected: (selectedVal) {},
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Ajouter un site"),
              ),
              const PopupMenuItem(
                value: 1,
                child: Text("Ajouter un lot"), //this road should lead to a page where all the sites are listed, and could be accessed one by one to see info about the selected site
              )
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height * 0.15,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    goToPage(context, ProductionFrom.routeName);
                  },
                  child: const Text(
                    "Rapport de production",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height * 0.15,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                  ),
                  onPressed: () {
                    goToPage(context, PoussForm.routeName);
                  },
                  child: const Text(
                    "Rapport de poussiniere",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: deviceSize.width,
                height: deviceSize.height * 0.15,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    goToPage(context, LotForm.routeName);
                  },
                  child: const Text(
                    "Creer un lot",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
