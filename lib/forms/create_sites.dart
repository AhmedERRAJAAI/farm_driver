import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/init_account_provider.dart';

class CreateSitesForm extends StatefulWidget {
  final Function tapIndexIncrementer;
  const CreateSitesForm({super.key, required this.tapIndexIncrementer});

  @override
  State<CreateSitesForm> createState() => _CreateSitesFormState();
}

class _CreateSitesFormState extends State<CreateSitesForm> {
  bool isLoading = false;
  bool failed = false;
  bool done = false;

  final eleveurFormKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController city = TextEditingController();

  Future<void> sendMasterUserData(BuildContext context, data) async {
    setState(() {
      isLoading = true;
    });
    try {
      // await Provider.of<InitUserProvider>(context, listen: false).createMaster(data).then((_) {
      setState(() {
        isLoading = false;
        done = true;
      });
      // });
    } catch (e) {
      setState(() {
        isLoading = false;
        done = false;
      });
    }
  }

  void createMasterUser(data) async {
    await sendMasterUserData(context, data).then((_) {
      if (done) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rapport envoyé'),
                TextButton(onPressed: () {}, child: const Text('Voir'))
              ],
            ),
          ),
        );
        setState(() {
          widget.tapIndexIncrementer();
        });
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

  void launchURL() async {
    const url = 'https://www.youtube.com/watch?v=Q_HoGYhk4x8&list=RD23ruEfLScnM&index=7';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Form(
      key: eleveurFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: deviceSize.width * 0.94,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Initiation 2/4",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue.shade700, decoration: TextDecoration.underline),
                ),
                Text(
                  "Creation des sites",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.amber.shade800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.4,
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
                      labelText: 'Latitude',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(
                  width: deviceSize.width * 0.4,
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
                      labelText: 'Longitude',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      launchURL();
                    },
                    child: Icon(
                      Icons.info,
                      color: Colors.amber.shade700,
                      size: 33,
                    )),
              ],
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
                    'name': name.text,
                    'phone': phone.text,
                    'email': email.text,
                    'city': city.text,
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
    );
  }
}
