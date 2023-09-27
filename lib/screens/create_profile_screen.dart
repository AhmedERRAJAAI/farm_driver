import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/init_account_provider.dart';
import './auth_screen.dart';
import '../mywidgets/create_eleveur.dart';
import '../mywidgets/create_sites.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  static const routeName = 'create-profile/';

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final masterUserFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool failedToCreateMaster = false;
  bool masterCreated = false;
  int tapIndex = 0;

  void tapIndexIncrementer() {
    tapIndex = tapIndex + 1;
  }

  final TextEditingController stname = TextEditingController();
  final TextEditingController ndname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController identifiant = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> sendMasterUserData(BuildContext context, data) async {
    setState(() {
      isLoading = true;
    });
    try {
      // await Provider.of<InitUserProvider>(context, listen: false).createMaster(data).then((_) {
      setState(() {
        isLoading = false;
        masterCreated = true;
      });
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
        masterCreated = false;
      });
    }
  }

  void createMasterUser(data) async {
    await sendMasterUserData(context, data).then((_) {
      if (masterCreated) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            content: Text(
              'Done, identifiez vous pour continuer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
        Navigator.of(context).pop();

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
                          content: Text(""),
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
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          width: deviceSize.width,
          child: Form(
            key: masterUserFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: deviceSize.width * 0.94,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Créer compte",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue.shade700, decoration: TextDecoration.underline),
                      ),
                      Text(
                        "Créer compte utilisateur principal",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.amber.shade800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: ndname,
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
                SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: stname,
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
                      labelText: 'Prenom',
                    ),
                    keyboardType: TextInputType.text,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: identifiant,
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
                      labelText: 'Identifiant',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
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
                      labelText: 'Mot de passe',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: deviceSize.width * 0.94,
                  child: TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Champs requis';
                      } else if (value != password.text) {
                        return 'les mots de passe ne se ressemblent pas';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      labelText: 'Confirmer votre mot de passe',
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: deviceSize.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (masterUserFormKey.currentState!.validate()) {
                        Map data = {
                          'first_name': stname.text,
                          'last_name': ndname.text,
                          'username': identifiant.text,
                          'password': password.text,
                          'email': email.text
                        };
                        createMasterUser(data);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700, // Button background color
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recent_actors),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Sites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bâtiment',
          ),
        ],
        currentIndex: tapIndex,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            tapIndex = value;
          });
        },
      ),
    );
  }
}
