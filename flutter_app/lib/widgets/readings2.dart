import 'package:flutter/material.dart';
import 'package:pisid_group_6/screens/screens.dart';

class Readings2 extends StatelessWidget {
  const Readings2({Key? key}) : super(key: key);

  /// Builds the [Readings2] Widget's User Interface
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Readings T2';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingsScreen(tempSensor1: false),
    );
  }
}