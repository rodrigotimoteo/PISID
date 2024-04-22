import 'package:flutter/material.dart';
import 'package:pisid/screens/screens.dart';

class Readings2 extends StatelessWidget {
  const Readings2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Readings T2';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingsScreen(),
    );
  }
}