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
    this.height = 40.0,
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
          gradient: new LinearGradient(
              colors: [
                AppTheme.getPrimaryColor(),
                AppTheme.getPrimaryDarkColor(),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Material(
          borderRadius: borderRadius,
          color: Colors.transparent,
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
