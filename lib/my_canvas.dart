import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MyCanvas extends CustomPainter {
  final List<double> weekData;
  final List<String>? labelData;
  final double minData;
  final double maxData;
  final double rangeValue;
  final double percentage;
  MyCanvas({this.labelData,required this.weekData, required this.minData, required this.maxData, required this.rangeValue, required this.percentage});
  @override
  void paint(Canvas canvas, Size size) {
    /// center to start drawing
    var center = Offset(size.width *0.5, size.height*0.5);
    /// draw gray frame
    // drawFrame(canvas, center, size);
    /// draw all char inside frame
    drawChart(canvas, center, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // void drawFrame(Canvas canvas, Offset center, Size canvasSize) {
  //   /// draw rectangle
  //   var rect = Rect.fromCenter(center: center, width: canvasSize.width, height: canvasSize.height);
  //   // fill rect
  //   var bg = Paint()..color = const Color(0xfff2f3f0);
  //   canvas.drawRect(rect, bg);
  //   // draw border
  //   var border = Paint()
  //     ..color = Colors.black45
  //     ..strokeWidth = 10.0
  //     ..style = PaintingStyle.stroke;
  //   canvas.drawRect(rect, border);
  // }

  // var chartW = 500.0;
  // var chartH = 150.0;
  void drawChart(Canvas canvas, Offset center, Size canvasSize) {
    var rectangle = Rect.fromCenter(center: center, width: canvasSize.width, height: canvasSize.height);
    ///painter for both border and inside grid
    var gridPainter = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
     /// path painter for data
    var pathPainter = Paint()
      // ..color = Colors.green
      // ..strokeWidth = 3.0
    // ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;
    /// create gradient
    pathPainter.shader = ui.Gradient.linear(Offset(canvasSize.width*0.5,canvasSize.height*0.01),Offset(canvasSize.width*0.5,canvasSize.height*1.01),[Colors.blue,Colors.lightBlue.withOpacity(0.3)],[0.00,1.00]);
    /// style for title
    // var titleStyle = const TextStyle(
    //   color: Colors.black,
    //   fontSize: 40,
    //   fontWeight: FontWeight.w900,
    // );
    /// label style for data
    var labelStyle = const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );
    // draw chart borders
    // drawChartBorder(canvas, gridPainter, rectangle);
    // draw data points
    drawDataPoints(canvas, pathPainter, rectangle, canvasSize);
    // draw chart guides
    // drawChartGuides(canvas, gridPainter, rectangle, canvasSize);
    // draw chart title
    // drawText(canvas, rectangle.topLeft + const Offset(0, -60), rectangle.width, titleStyle,
    //     "Weekly Data");
    drawLabels(canvas, rectangle, labelStyle, canvasSize);
  }

  // void drawChartBorder(Canvas canvas, Paint gridPainter, Rect rectangle) {
  //   canvas.drawRect(rectangle, gridPainter);
  // }

  // void drawChartGuides(Canvas canvas, Paint gridPainter, Rect rectangle, Size size) {
  //   /// total number of data to be represented
  //   var numberOfData = weekData.length;
  //   /// rectangle horizontal value, we will start from 0
  //   var x = rectangle.left;
  //   /// width between data
  //   var widthBNData = size.width / (numberOfData-1);
  //   // print('total wdth ========= ${size.width} data width value ===== $widthBNData');
  //   for (var i = 0; i < numberOfData; i++) {
  //     var point1 = Offset(x, rectangle.bottom);
  //     var point2 = Offset(x, rectangle.top);
  //     canvas.drawLine(point1, point2, gridPainter);
  //     // print('all data === X: $x colW: $colW rect bottom: ${rect.bottom} rect top : ${rect.top}');
  //     x += widthBNData;
  //   }
  //
  //   /// draw horizontal lines
  //   /// vertical grid width
  //   // var verticalGridWidth = size.height / 3;
  //   // canvas.drawLine(Offset(rectangle.left, rectangle.bottom - verticalGridWidth),
  //   //     Offset(rectangle.right, rectangle.bottom - verticalGridWidth), gridPainter);
  //   // canvas.drawLine(Offset(rectangle.left, rectangle.bottom - verticalGridWidth * 2),
  //   //     Offset(rectangle.right, rectangle.bottom - verticalGridWidth * 2), gridPainter);
  // }

  void drawDataPoints(Canvas canvas, pathPainter, Rect rectangle, Size size) {

    /// total number of data to be represented
    // var numberOfData = weekData.length;
    var numberOfData = 2;
    /// this ratio is the number of y pixels per unit data
    var yRatio = size.height / rangeValue;
    /// width between data
    var widthBNData = size.width / (numberOfData-1);
    /// path which will move
    var path = Path();
    /// rectangle horizontal value, we will start from 0
    var x = rectangle.left;
    /// to move painter without draw for first time
    bool first = true;
    var previousValue=weekData[0];
    /// we should pass original data list to loop if we want to draw line for every data
    /// for our case we will take two data which is minData maxData so let's generate list
    var twoDataList=[minData,maxData];
    for (var singleData in twoDataList) {
      var y = (singleData - minData) * yRatio * percentage;
      var yToDraw=rectangle.bottom - y;
      if (first) {
        path.moveTo(x, yToDraw);
        first = false;
      } else {
        /// for smooth line using cubic
        final xPrevious = x - widthBNData;
        final yPrevious = rangeValue == 0
            ? (0.5 * size.height)
            : ((maxData - previousValue) / rangeValue) * size.height;
        final controlPointX1 = xPrevious + (x - xPrevious) *(1/3);
        final controlPointX2 = xPrevious + (x - xPrevious) *(2/3);
        path.cubicTo(
            controlPointX1, yToDraw, controlPointX2, yPrevious, x, yToDraw);
        // final controlPointX = xPrevious + (x - xPrevious) / 2;
        // path.cubicTo(
        //     controlPointX, yPrevious, controlPointX, yToDraw, x, yToDraw);
        ///for sharp line
        // path.lineTo(x, yToDraw);
      }
      previousValue=singleData;
      x += widthBNData;
    }

    path.lineTo(size.width,size.height);
    path.lineTo(0,size.height);
    /// first y
    var y = (weekData[0] - minData) * yRatio * percentage;
    var yToDraw=rectangle.bottom - y;
    path.lineTo(0,yToDraw);

    // path.moveTo(x - widthBNData, rectangle.bottom);
    // path.moveTo(rectangle.left, rectangle.bottom);
    path.close();
    canvas.drawPath(path, pathPainter);
  }

  drawText(Canvas canvas, Offset position, double width, TextStyle style,
      String text) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter =
    TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: width);
    textPainter.paint(canvas, position);
  }

  void drawLabels(Canvas canvas, Rect rectangle, TextStyle labelStyle, Size size) {
    // final xLabel = ["M", "T", "W", "T", "F", "S", "S"];
    /// total number of data to be represented
    var numberOfData = weekData.length;
    ///labels
    List<String>? xLabel = labelData;
    /// width between data
    var widthBNData = size.width / (numberOfData-1);
    // draw x Label
    var x = rectangle.left;
    if(xLabel!=null){
      for (var i = 0; i < numberOfData; i++) {
        drawText(canvas, Offset(x, rectangle.bottom + 15), 20, labelStyle, xLabel[i]);
        x += widthBNData;
      }
    }

    //draw y Label
    // drawText(canvas, rectangle.bottomLeft + const Offset(-35, -10), 40, labelStyle,
    //     minData.toStringAsFixed(1)); // print min value
    // drawText(canvas, rectangle.topLeft + const Offset(-35, 0), 40, labelStyle,
    //     maxData.toStringAsFixed(1)); // print max value
  }
}