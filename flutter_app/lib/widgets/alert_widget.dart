import 'package:flutter/material.dart';

import '../screens/screens.dart';

class Alerts extends StatelessWidget {
//class Alerts extends StatefulWidget {
  const Alerts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Alertas';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const AlertsScreen(),
    );
  }
}