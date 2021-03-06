import 'package:flutter/material.dart';

class AnimatedFade extends StatelessWidget {
  const AnimatedFade({
    Key key,
    @required this.animation,
    @required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, widget) => IgnorePointer(
        ignoring: animation.value < 1,
        child: Opacity(
          opacity: animation.value,
          child: widget,
        ),
      ),
    );
  }
}
