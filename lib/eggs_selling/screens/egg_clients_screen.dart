import 'package:flutter/material.dart';
import './egg_single_client_screen.dart';
import './egg_gestion_clients.dart';

class EggClientScreen extends StatefulWidget {
  const EggClientScreen({super.key});
  static const routeName = "egg-clients/";

  @override
  State<EggClientScreen> createState() => _EggClientScreenState();
}

class _EggClientScreenState extends State<EggClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        title: const Text(
          "Mes clients",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
          ),
        ),
        backgroundColor: Color(0xFF145da0),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EggGestionClients.routeName);
            },
            icon: const Icon(
              Icons.group_add,
              size: 24,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          child: ListView(
            primary: false,
            padding: const EdgeInsets.all(5),
            children: <Widget>[
              ClientListItem(),
              SizedBox(height: 3),
              ClientListItem(),
              SizedBox(height: 3),
              ClientListItem(),
            ],
          )),
    );
  }
}

class ClientListItem extends StatelessWidget {
  const ClientListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.white,
        ),
        // side: MaterialStateProperty.all<BorderSide>(
        //   BorderSide(
        //     color: Colors.purple.shade300, // Change the border color to blue.
        //     width: 0.0, // Change the border width to 2.0.
        //   ),
        // ),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(EggClientDetailScreen.routeName);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(
            Icons.person,
            size: 45,
            color: Colors.blue.shade800,
          ),
          Text(
            "Prenom NOM",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
          )
        ]),
      ),
    );
  }
}
