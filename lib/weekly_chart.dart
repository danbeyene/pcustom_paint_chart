import 'dart:async';

import 'package:flutter/material.dart';

import 'my_canvas.dart';

class WeeklyChart extends StatefulWidget {
  final List<double> dummyData;
  final List<String>? dummyLabel;
  const WeeklyChart({super.key,required this.dummyData, this.dummyLabel});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  late List<double> weekData;
  double minData = double.maxFinite;
  double maxData = -double.maxFinite;
  double rangeValue = 1.0;
  double percentage = 0.0;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    setState(() {
      weekData = widget.dummyData.toList();
      for (var d in weekData) {
        minData = d < minData ? d : minData;
        maxData = d > maxData ? d : maxData;
      }
      rangeValue = maxData - minData;
    });

    // setup animation timer and update variable
    const fps = 50.0;
    const totalAnimDuration = 1.0; // animate for x seconds
    var percentStep = 1.0 / (totalAnimDuration * fps);
    var frameDuration = (1000 ~/ fps);
    timer = Timer.periodic(Duration(milliseconds: frameDuration), (timer) {
      setState(() {
        percentage += percentStep;
        percentage = percentage > 1.0 ? 1.0 : percentage;
        if (percentage >= 1.0) {
          timer.cancel();
        }
      });
    });

    print("all parameters === weekdata : $weekData  minD: $minData  maxD: $maxData  rangeD:  $rangeValue  percentage: $percentage");
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 45),
          child: CustomPaint(
            foregroundPainter: MyCanvas(labelData: widget.dummyLabel, weekData: weekData, minData: minData, maxData: maxData, rangeValue: rangeValue, percentage: percentage),
            child: SizedBox(
              // width: double.maxFinite,
              width: MediaQuery.of(context).size.width*0.8,
              height: MediaQuery.of(context).size.height*0.2,
            ),
          )
        ),
      ),
    );
  }
}