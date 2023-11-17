import 'package:flutter/material.dart';

class EggGestionClients extends StatefulWidget {
  const EggGestionClients({super.key});
  static const routeName = "egg-gestion-clients/";

  @override
  State<EggGestionClients> createState() => _EggGestionClientsState();
}

class _EggGestionClientsState extends State<EggGestionClients> {
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
          "Gestion des clients",
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
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AddClient(),
                    );
                  });
            },
            icon: const Icon(
              Icons.add,
              size: 24,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
          child: ListView(
            primary: false,
            padding: const EdgeInsets.all(5),
            children: <Widget>[
              ManageClientListItem(),
              ManageClientListItem(),
              ManageClientListItem(),
            ],
          )),
    );
  }
}

class ManageClientListItem extends StatefulWidget {
  const ManageClientListItem({super.key});

  @override
  State<ManageClientListItem> createState() => _ManageClientListItemState();
}

class _ManageClientListItemState extends State<ManageClientListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          title: Text("Name Name"),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_off),
          ),
        ),
      ),
    );
  }
}

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              "Nouveau client",
              style: TextStyle(color: Color(0xFF145da0), fontSize: 16),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Nom'),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Prénom'),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'solde initiale'),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: TextFormField(
                textInputAction: TextInputAction.next,
                // controller: quantityController,
                decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
