import 'package:flutter/material.dart';
import 'package:pisid/screens/screens.dart';

class Readings3 extends StatelessWidget {
  const Readings3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Mouses Per Room';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingsScreen(),
    );
  }
}