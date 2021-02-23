import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Color shadowColor;
  final EdgeInsets paddingInsets;
  final Icon icon;
  final Color textColor;
  final Gradient gradient;
  final Function onTap;
  final BorderRadius borderRadius;

  const Button({
    Key key,
    this.height = 38.0,
    this.width = double.infinity,
    this.text,
    this.shadowColor,
    this.paddingInsets =
        const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
    this.icon,
    this.textColor = Colors.white,
    this.gradient,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(7.0)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingInsets,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          // gradient: gradient != null
          //     ? gradient
          //     : LinearGradient(colors: [
          //         AppTheme.lightGreen,
          //         HexColor('#DCE775'),
          //       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: borderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: shadowColor != null
                    ? shadowColor
                    : Colors.green.withOpacity(0.4),
                offset: const Offset(4.0, 4.0),
                blurRadius: 4.0),
          ],
        ),
        child: Material(
          color: AppTheme.getPrimaryColor(),
          borderRadius: borderRadius,
          // color: Colors.transparent,
          child: InkWell(
            borderRadius: borderRadius,
            highlightColor: Colors.transparent,
            onTap: onTap,
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon != null ? icon : SizedBox(),
                  Text(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
