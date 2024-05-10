import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

/// The entry point for the Rat Monitoring App.
void main() => runApp(const Login());

/// A StatelessWidget representing the login screen of the Rat Monitoring App.
///
/// This screen allows users to log in to the application.
class Login extends StatelessWidget {

  /// Constructs a [Login] widget.
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Rat Monitoring App';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  appTitle,
                  style: TextStyle(fontSize: 30),
                ),
            ),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}