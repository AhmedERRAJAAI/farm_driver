import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SignlaProblem extends StatelessWidget {
  const SignlaProblem({super.key});
  Future<void> signaleLaunchUrl() async {
    if (!await launchUrl(Uri.parse('https://wa.link/4074nu'))) {
      throw Exception('Could not launch https://wa.link/4074nu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "- assurez-vous que vous êtes connecté à Internet",
            style: TextStyle(fontSize: 14),
          ),
          const Text(
            "- réessayez dans une minute",
            style: TextStyle(fontSize: 14),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(width: 0.6, color: Colors.green), borderRadius: BorderRadius.circular(6)),
            child: Center(
              child: Column(
                children: [
                  const Text(
                    'pas résolu? Contactez-nous',
                    style: TextStyle(fontSize: 13),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        signaleLaunchUrl();
                      },
                      child: const Text("Whatsapp")),
                  OutlinedButton(onPressed: () {}, child: const Text("Email"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}