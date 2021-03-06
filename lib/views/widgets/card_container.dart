import 'package:covid_app/utils/Paths.dart';
import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    Key key,
    this.appBar = false,
    this.children,
    this.decoration,
    this.height,
    this.path = Paths.appLogoPath,
  }) : super(key: key);
  final bool appBar;
  final List<Widget> children;
  final Decoration decoration;
  final double height;
  final String path;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final containerSize = screenSize.width * 0.66;
    final containerTop = -(screenSize.width * 0.154);
    final containerRight = -(screenSize.width * 0.23);
    final appBarTop =
        containerSize / 2 + containerTop - IconTheme.of(context).size / 2;

    return Container(
      width: screenSize.width,
      decoration: decoration,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: containerTop,
            right: containerRight,
            child: Image.asset(
              path,
              width: containerSize,
              height: containerSize,
              color: Color(0xFF303943).withOpacity(0.05),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (appBar)
                Padding(
                  padding: EdgeInsets.only(left: 26, right: 26, top: appBarTop),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.arrow_back_ios),
                        onTap: Navigator.of(context).pop,
                      ),
                      // Icon(Icons.menu),
                    ],
                  ),
                ),
              if (children != null) ...children,
            ],
          ),
        ],
      ),
    );
  }
}
