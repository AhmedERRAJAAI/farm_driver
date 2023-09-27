import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './create_profile_screen.dart';

import '../providers/auth.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth/';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  size: 100,
                  color: Color(0xFF0071ce),
                ),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _loginForm = GlobalKey<FormState>();
  bool isLoading = false;

  final Map<String, String> _authData = {
    'username': '',
    'password': ''
  };

  void login(BuildContext context) async {
    final isValid = _loginForm.currentState?.validate();
    if (isValid ?? false) {
      _loginForm.currentState?.save();
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).login(_authData['username'] ?? '', _authData['password'] ?? '');
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Erreur'),
            content: Text(e.toString().split(": ")[1]),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Set the border radius
      ),
      // constraints: const BoxConstraints(
      //   maxHeight: 325, // Set the maximum height you want
      // ),
      child: Column(
        children: [
          Form(
            key: _loginForm,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'identifiant'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "champs requis";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['username'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'mot de passe'),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "champs requis";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              login(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0071ce), // Button background color
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
                : const Text(
                    "Se connecter",
                    style: TextStyle(fontSize: 17),
                  ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text("Mot de passe oublié ?"),
          ),
          const SizedBox(height: 100),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CreateProfileScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade700, // Button background color
                foregroundColor: Colors.white, // Button text color
                elevation: 0, // Elevation for the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                ),
              ),
              child: const SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    "Créer votre profile",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
