import 'package:pisid_group_6/widgets/widgets.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A stateful widget representing a login form.
///
/// This widget provides a form for users to input their login credentials.
/// It is used to collect username and password information for authentication.
/// The [LoginForm] widget manages its state internally and rebuilds when
/// necessary.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

/// The state for the [LoginForm] widget.
///
/// This class manages the state of the [LoginForm] widget. It handles the
/// internal state of the login form, such as user input validation,
/// error handling, and updating the UI accordingly.
class LoginFormState extends State<LoginForm> {

  /// Create a global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Creates TextEditingControllers for each input label necessary for the login
  /// form
  final usernameController = TextEditingController(text: "PessoaTeste");
  final passwordController = TextEditingController();
  final ipController = TextEditingController(text: "127.0.0.1");
  final portController = TextEditingController(text: "80");

  /// Clean up the controller when the widget is disposed.
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    ipController.dispose();
    portController.dispose();
    super.dispose();
  }

  /// Builds the [LoginForm] User Interface
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: usernameController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: passwordController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: ipController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'IP (xxx.xxx...)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid IP';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: portController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Port XAMPP',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 50),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      validateLogin();
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> validateLogin() async {
    String loginURL = "http://${ipController.text.trim()}:"
        "${portController.text.trim()}/php/actions/validateLoginFlutter.php";

    late http.Response response;

    try {
      response = await http.post(Uri.parse(loginURL), body: {
        'username': usernameController.text.trim(), //get the username text
        'password': passwordController.text.trim()  //get password text
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("The connection to the database failed."),
          );
        },
      );
    }

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData["success"]) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', usernameController.text.trim());
        await prefs.setString('password', passwordController.text.trim());
        await prefs.setString('ip', ipController.text.trim());
        await prefs.setString('port', portController.text.trim());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Alerts()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(jsonData["message"]),
            );
          },
        );
      }
    }
  }
}