import 'package:pisid/screens/screens.dart';

import 'package:flutter/material.dart';

/// A stateless widget representing a collection of reading rooms.
///
/// This widget displays a collection of reading rooms using a layout that
/// is suitable for rendering in various contexts, such as within a list or
/// a grid.
///
/// Instances of this class are immutable and can be used to represent
/// reading rooms with different configurations and data sources.
class ReadingRooms extends StatelessWidget {


  /// Constructs a [ReadingRooms] widget.
  ///
  /// This constructor initializes the widget with any necessary configuration
  /// options and data sources required to render the collection of reading rooms.
  ///
  /// The [key] parameter is an optional key that can be used to uniquely identify
  /// instances of the [ReadingRooms] widget in the widget tree for performance
  /// optimizations, such as widget rebuilding.
  const ReadingRooms({Key? key}) : super(key: key);

  /// Builds the [ReadingRooms] Widget's User Interface
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Mice  / Room';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingRoomsScreen(),
    );
  }
}