import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReadingRoomsScreen extends StatefulWidget {
  const ReadingRoomsScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReadingRoomsScreen> {
  late int showingTooltip;
  late Timer timer;

  @override
  void initState() {
    showingTooltip = -1;
    const interval = Duration(seconds:1);
    timer = Timer.periodic(interval, (Timer t) => getReadings());
    super.initState();
  }
  var readingsValues = <int>[];
  var readingsTimes = <int>[];
  var minY = 0.0;
  var maxY = 100.0;

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y.toDouble()),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    getReadings();
    int sizelist = readingsTimes.length;
    for( int i = sizelist ; i < 9; i++ ) {
      readingsTimes.add(i + 2);
      readingsValues.add(0);
    }
    //sleep(Duration(seconds:2));
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 60),
            child: BarChart(
              BarChartData(
                barGroups: [
                  generateGroupData(readingsTimes[0].toInt(),readingsValues[0].toInt()),
                  generateGroupData(readingsTimes[1].toInt(),readingsValues[1].toInt()),
                  generateGroupData(readingsTimes[2].toInt(),readingsValues[2].toInt()),
                  generateGroupData(readingsTimes[3].toInt(),readingsValues[3].toInt()),
                  generateGroupData(readingsTimes[4].toInt(),readingsValues[4].toInt()),
                  generateGroupData(readingsTimes[5].toInt(),readingsValues[5].toInt()),
                  generateGroupData(readingsTimes[6].toInt(),readingsValues[6].toInt()),
                  generateGroupData(readingsTimes[7].toInt(),readingsValues[7].toInt()),
                  generateGroupData(readingsTimes[8].toInt(),readingsValues[8].toInt()),
                  generateGroupData(readingsTimes[9].toInt(),readingsValues[9].toInt()),
                ],
                barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (response != null && response.spot != null && event is FlTapUpEvent) {
                        setState(() {
                          final x = response.spot!.touchedBarGroup.x;
                          final isShowing = showingTooltip == x;
                          if (isShowing) {
                            showingTooltip = -1;
                          } else {
                            showingTooltip = x;
                          }
                        });
                      }
                    },
                    mouseCursorResolver: (event, response) {
                      return response == null || response.spot == null
                          ? MouseCursor.defer
                          : SystemMouseCursors.click;
                    }
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: () {
              readingsValues.clear();
              readingsTimes.clear();

              minY = 0.0;
              maxY = 100.0;
              Navigator.pop(context);
            },
            child: const Text('Alerts'),
          ),
        ));

  }

  getReadings() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String? ip = prefs.getString('ip');
    String? port = prefs.getString('port');
    String readingsURL = "http://" + ip! + ":" + port! + "/php/actions/getMousesRoom.php";
    var response = await http
        .post(Uri.parse(readingsURL), body: {'username': username, 'password': password});

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var data = jsonData["data"];
      setState(() {
        readingsValues.clear();
        readingsTimes.clear();
        minY = 0;
        maxY = 100;

        if (data != null && data.length > 0) {
          int i = 0;
          for (var reading in data) {
            while(i < reading.length) {
              readingsValues.add(reading["sala_" + i.toString()]);
              readingsTimes.add(i++);
            }
          }
          if (readingsValues.isNotEmpty) {
            minY = readingsValues.reduce(min) - 1;
            maxY = readingsValues.reduce(max) + 1;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}