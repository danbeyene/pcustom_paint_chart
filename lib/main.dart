import 'dart:math';

import 'package:flutter/material.dart';

import 'weekly_chart.dart';
/// random class
var random = Random();
const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));
void main() {
  /// generate the dummy data
  var dummyData = <double>[0.0,40.0,60.0,100.0];
  // var dummyData = <double>[];
  // var dummyLabel = <String>[];
  // for (var i = 0; i < 11; i++) {
  //   // print('next random ========== ${random.nextDouble()}');
  //   dummyData.add(random.nextDouble() * 100.0);
  //   dummyLabel.add(getRandomString(1));
  // }

  runApp(MyApp(dummyData: dummyData,));
}

class MyApp extends StatelessWidget {
  final List<double> dummyData;
  final List<String>? dummyLabel;
  const MyApp({super.key, required this.dummyData,this.dummyLabel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Week Chart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WeeklyChart(dummyData: dummyData,dummyLabel: null,),
    );
  }
}