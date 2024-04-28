import 'package:flutter/material.dart';
import 'package:pisid/screens/screens.dart';

class Readings1 extends StatelessWidget {
  const Readings1({Key? key}) : super(key: key);

  /// Builds the [Readings1] Widget's User Interface
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Readings T1';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingsScreen(),
    );
  }
}