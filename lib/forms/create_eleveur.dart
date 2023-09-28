import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/init_account_provider.dart';

class CreateEleveurForm extends StatefulWidget {
  static const routeName = 'create-eleveur-profile/';
  const CreateEleveurForm({super.key});

  @override
  State<CreateEleveurForm> createState() => _CreateEleveurFormState();
}

class _CreateEleveurFormState extends State<CreateEleveurForm> {
  final eleveurFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool failed = false;
  bool done = false;
  bool _isInit = false;
  int? userId;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userId = Provider.of<InitUserProvider>(context).getUserId;
    print(userId);
    _isInit = false;
    super.didChangeDependencies();
  }

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController city = TextEditingController();

  Future<void> sendEleveurData(BuildContext context, data) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<InitUserProvider>(context, listen: false).createEleveur(data).then((_) {
        setState(() {
          isLoading = false;
          done = true;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        done = false;
      });
    }
  }

  void createEleveurProfile(data) async {
    await sendEleveurData(context, data).then((_) {
      if (done) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Done, identifiez vous pour continuer',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
        // Navigator.pushNamed(context, "/");
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 12),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ERROR: echec d'envoyer les données"),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Aide', style: TextStyle(fontSize: 17, fontStyle: FontStyle.normal, color: Colors.grey.shade800)),
                          content: Text("check your internet connection"),
                        ),
                      );
                    },
                    child: const Text('Plus'))
              ],
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Identification d'eleveur",
          style: TextStyle(color: Colors.white, fontSize: 22, fontStyle: FontStyle.normal),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: eleveurFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 70,
                  width: deviceSize.width * 0.94,
                  child: Center(
                      child: Icon(
                    Icons.description,
                    color: Colors.blue.shade700,
                    size: 60,
                  )),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champs requis';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      labelText: 'Nom',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champs requis';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champs requis';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      labelText: 'E-mail',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: city,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champs requis';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      labelText: 'Ville',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: deviceSize.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (eleveurFormKey.currentState!.validate()) {
                        Map data = {
                          'userId': userId,
                          'name': name.text,
                          'phone': phone.text,
                          'email': email.text,
                          'city': city.text,
                        };
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text(
                                    "Confirmer ?",
                                    style: TextStyle(color: Colors.grey.shade800, fontStyle: FontStyle.normal, fontSize: 16),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Annuler",
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        createEleveurProfile(data);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Creer",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700, // Button background color
                      foregroundColor: Colors.white, // Button text color
                      elevation: 2, // Elevation for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Créer",
                                style: TextStyle(fontSize: 17),
                              ),
                              Icon(Icons.add)
                            ],
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
