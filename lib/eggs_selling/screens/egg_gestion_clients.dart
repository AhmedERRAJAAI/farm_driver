import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';

class EggGestionClients extends StatefulWidget {
  const EggGestionClients({super.key});
  static const routeName = "egg-gestion-clients/";

  @override
  State<EggGestionClients> createState() => _EggGestionClientsState();
}

class _EggGestionClientsState extends State<EggGestionClients> {
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

  void toggleActiveClient(data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ClientProvider>(context, listen: false).toggleActiveClient(data).then((_) {
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
          isLoading
              ? CupertinoActivityIndicator(
                  color: Colors.white,
                )
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
        child: ListView.builder(
          itemCount: clientList.length,
          itemBuilder: ((context, i) => ManageClientListItem(
                toggleActiveClient: toggleActiveClient,
                client: clientList[i],
              )),
        ),
      ),
    );
  }
}
// ManageClientListItem(),

class ManageClientListItem extends StatefulWidget {
  final Client client;
  final Function toggleActiveClient;
  const ManageClientListItem({super.key, required this.client, required this.toggleActiveClient});

  @override
  State<ManageClientListItem> createState() => _ManageClientListItemState();
}

class _ManageClientListItemState extends State<ManageClientListItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      borderOnForeground: true,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.lightGreen, width: 3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.client.fname} ${widget.client.lname}",
              style: TextStyle(fontWeight: FontWeight.bold, color: widget.client.isActive ? Colors.blue : Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    widget.toggleActiveClient({
                      "id": widget.client.id,
                      "active": !widget.client.isActive
                    });
                  },
                  icon: widget.client.isActive
                      ? const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.person_off,
                          size: 20,
                          color: Colors.grey,
                        ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: SingleChildScrollView(child: ClientDataModal(client: widget.client)),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'Fermer',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.info, size: 20, color: Colors.blue),
                ),
              ],
            )
          ],
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
  final createClientForm = GlobalKey<FormState>();
  final TextEditingController lname = TextEditingController();
  final TextEditingController fname = TextEditingController();
  final TextEditingController initSolde = TextEditingController(text: "0");
  final TextEditingController email = TextEditingController(text: "");
  final TextEditingController phone = TextEditingController(text: "");

  bool isLoading = false;
  bool requestFailed = false;

  void forwardClientData(Map data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ClientProvider>(context, listen: false).sendClientData(data).then((_) {
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
    return SizedBox(
      height: 450,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: createClientForm,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Annuler")),
                    const Text("Ajouter nouveau client"),
                    TextButton(
                        onPressed: () {
                          if (createClientForm.currentState!.validate()) {
                            forwardClientData({
                              "firstName": fname.text,
                              "lastName": lname.text,
                              "email": email.text,
                              "phone": phone.text,
                              "initSolde": initSolde.text,
                            });
                          }
                        },
                        child: const Text("Effectuer")),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: lname,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Nom'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Champs requis";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: fname,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Prénom'),
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: initSolde,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'solde initial'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: phone,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Téléphone'),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: email,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ClientDataModal extends StatefulWidget {
  final Client client;
  const ClientDataModal({super.key, required this.client});

  @override
  State<ClientDataModal> createState() => _ClientDataModalState();
}

class _ClientDataModalState extends State<ClientDataModal> {
  final updateClientForm = GlobalKey<FormState>();
  bool isEditing = false;

  bool isLoading = false;
  bool requestFailed = false;

  void forwardUpdateClientData(Map data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<ClientProvider>(context, listen: false).updateClientData(data).then((_) {
        setState(() {
          isLoading = false;
          requestFailed = false;
          Navigator.of(context).pop();
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
    final TextEditingController lname = TextEditingController(text: widget.client.lname);
    final TextEditingController fname = TextEditingController(text: widget.client.fname);
    final TextEditingController initSolde = TextEditingController(text: "${widget.client.initSolde}");
    final TextEditingController email = TextEditingController(text: widget.client.email);
    final TextEditingController phone = TextEditingController(text: widget.client.phone);
    return SizedBox(
      height: 340,
      child: Form(
        key: updateClientForm,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.client.fname} ${widget.client.lname}',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    icon: Icon(
                      isEditing ? Icons.cancel : Icons.edit,
                      size: 20,
                      color: Colors.lightGreen,
                    ),
                  ),
                  isEditing
                      ? TextButton(
                          onPressed: () {
                            if (updateClientForm.currentState!.validate()) {
                              updateClientForm.currentState!.save();
                              forwardUpdateClientData({
                                "id": widget.client.id,
                                "email": email.text,
                                "firstName": fname.text,
                                "lastName": lname.text,
                                "phone": phone.text,
                                "initSolde": double.parse(initSolde.text),
                                "active": widget.client.isActive
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  "Effectuer  ",
                                  style: TextStyle(color: Colors.orange),
                                ),
                                isLoading
                                    ? SizedBox(
                                        height: 10,
                                        width: 10,
                                        child: CircularProgressIndicator(color: Colors.orange),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nom",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              SizedBox(
                width: 180,
                height: 50,
                child: TextFormField(
                  enabled: isEditing,
                  textInputAction: TextInputAction.next,
                  controller: lname,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champs requis";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prénom", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              SizedBox(
                width: 180,
                height: 50,
                child: TextFormField(
                  enabled: isEditing,
                  textInputAction: TextInputAction.next,
                  controller: fname,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Téléphone", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              SizedBox(
                width: 180,
                height: 50,
                child: TextFormField(
                  enabled: isEditing,
                  textInputAction: TextInputAction.next,
                  controller: phone,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("E-mail", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              SizedBox(
                width: 200,
                height: 50,
                child: TextFormField(
                  enabled: isEditing,
                  textInputAction: TextInputAction.next,
                  controller: email,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Solde initial", style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
              SizedBox(
                width: 180,
                height: 50,
                child: TextFormField(
                  enabled: isEditing,
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.next,
                  controller: initSolde,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
