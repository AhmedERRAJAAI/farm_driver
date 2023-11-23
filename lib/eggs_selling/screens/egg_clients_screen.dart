import 'package:flutter/material.dart';
import './egg_single_client_screen.dart';
import './egg_gestion_clients.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';

class EggClientScreen extends StatefulWidget {
  const EggClientScreen({super.key});
  static const routeName = "egg-clients/";

  @override
  State<EggClientScreen> createState() => _EggClientScreenState();
}

class _EggClientScreenState extends State<EggClientScreen> {
  bool isLoading = false;
  bool requestFailed = false;
  bool _isInit = true;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getClients();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void getClients() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ClientProvider>(context, listen: false).fetchClients().then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        requestFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientProv = Provider.of<ClientProvider>(context);
    final clientList = clientProv.clientList;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pushNamed("egg-dashboard/"),
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
        child: ListView.builder(
          itemCount: clientList.length,
          itemBuilder: (context, i) {
            return ClientListItem(
              name: "${clientList[i].fname} ${clientList[i].lname}",
            );
          },
        ),
      ),
    );
  }
}

class ClientListItem extends StatelessWidget {
  final String name;
  const ClientListItem({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          // side: MaterialStateProperty.all<BorderSide>(
          //   BorderSide(
          //     color: Colors.purple.shade300, // Change the border color to blue.
          //     width: 2.0, // Change the border width to 2.0.
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
              name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue.shade800, fontSize: 16),
            )
          ]),
        ),
      ),
    );
  }
}
