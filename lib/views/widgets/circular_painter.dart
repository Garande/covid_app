import 'dart:math';

import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  const OptionButton(
      {Key key,
      this.width,
      this.height,
      this.lineWidth,
      this.lineColor,
      this.completeColor,
      this.padding,
      this.innerFill,
      this.splashColor,
      this.completePercent,
      this.isLineDotted,
      this.onSelected})
      : super(key: key);
  final double width;
  final double height;
  final double lineWidth;
  final Color lineColor;
  final Color completeColor;
  final double padding;
  final Color innerFill;
  final Color splashColor;
  final double completePercent;
  final bool isLineDotted;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: width,
        child: new CustomPaint(
          foregroundPainter: new CircularPainter(
              width: lineWidth,
              lineColor: lineColor,
              completeColor: completeColor,
              completePercent: completePercent,
              isLineDotted: isLineDotted,
              numberOfDots: 15),
          child: new Padding(
            padding: new EdgeInsets.all(padding),
            child: new RaisedButton(
              onPressed: () {
                onSelected();
              },
              color: innerFill,
              splashColor: splashColor,
              shape: new CircleBorder(),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}

class CircularPainter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completePercent;
  double width;
  bool isLineDotted;
  int numberOfDots;

  CircularPainter({
    this.lineColor,
    this.isLineDotted,
    this.completeColor,
    this.completePercent,
    this.width,
    this.numberOfDots = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    if (isLineDotted) {
      double percent = (size.width * 0.001) / 2;
      double arcAngle = 2 * pi * percent;

      for (int i = 0; i < numberOfDots; i++) {
        double startAngle = (-pi / 2) * (i / 2);

        canvas.drawArc(new Rect.fromCircle(center: center, radius: radius),
            startAngle, arcAngle, false, line);
      }
    } else {
      //if a none dotted line is required
      canvas.drawCircle(center, radius, line);
    }

    double completeArcAngle = 2 * pi * (completePercent / 100);

    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        completeArcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
