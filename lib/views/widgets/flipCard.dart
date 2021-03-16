import 'package:flutter/material.dart';
import 'dart:math' as math;

enum FlipAxis { vertical, horizontal }

class FlipCard extends StatefulWidget {
  final Widget frontChild;
  final Widget backChild;
  final double height;
  final double width;
  final VoidCallback onTap;
  final FlipAxis flipAxis;

  final AnimationController animationController;

  final bool willHandleCallBackWithChild;

  const FlipCard({
    Key key,
    @required this.frontChild,
    @required this.backChild,
    @required this.height,
    @required this.width,
    this.onTap,
    @required this.flipAxis,
    this.animationController,
    this.willHandleCallBackWithChild,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    if (widget.animationController == null) {
      animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 3000));
    } else {
      animationController = widget.animationController;
    }

    animation = Tween(
      begin: 0.0,
      end: math.pi / 2,
    ).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.elasticInOut,
      ),
    );

    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    if (widget.animationController == null) {
      animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.flipAxis == FlipAxis.vertical
        ? Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (!(widget.willHandleCallBackWithChild)) {
                    animationController.reverse();
                  }
                },
                child: animation.value > (85 * math.pi / 180)
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                            0.0,
                            -(math.cos(animation.value) * (widget.height / 2)),
                            ((-widget.height / 2) * math.sin(animation.value)),
                          )
                          ..rotateX(-(math.pi / 2) + animation.value),
                        child: widget.backChild,
                      )
                    : Container(),
              ),
              GestureDetector(
                onTap: () {
                  if (!(widget.willHandleCallBackWithChild)) {
                    widget.onTap();
                    animationController.forward();
                  }
                },
                child: animation.value < (85 * math.pi / 180)
                    ? Transform(
                        alignment: Alignment.center,
                        transform: new Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                            0.0,
                            math.sin(animation.value) * (widget.height / 2),
                            -((widget.height / 2) * math.cos(animation.value)),
                          )
                          ..rotateX(animation.value),
                        child: widget.frontChild,
                      )
                    : Container(),
              ),
            ],
          )
        : Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (!(widget.willHandleCallBackWithChild)) {
                    // widget.onTap();
                    animationController.reverse();
                  }
                },
                child: animation.value > (85 * math.pi / 180)
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                            -(math.cos(animation.value) * (widget.width / 2)),
                            0.0,
                            ((-widget.width / 2) * math.sin(animation.value)),
                          )
                          ..rotateY(-(math.pi / 2) + animation.value),
                        child: widget.backChild,
                      )
                    : Container(),
              ),
              GestureDetector(
                onTap: () {
                  if (!(widget.willHandleCallBackWithChild)) {
                    widget.onTap();
                    animationController.forward();
                  }
                },
                child: animation.value < (85 * math.pi / 180)
                    ? Transform(
                        alignment: Alignment.center,
                        transform: new Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                            math.sin(animation.value) * (widget.width / 2),
                            0.0,
                            -((widget.width / 2) * math.cos(animation.value)),
                          )
                          ..rotateY(animation.value),
                        child: widget.frontChild,
                      )
                    : Container(),
              ),
            ],
          );
  }
}
