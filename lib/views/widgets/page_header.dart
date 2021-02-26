import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PageHeader extends StatefulWidget {
  final double offset;
  final String image;
  final String message;

  const PageHeader({Key key, this.offset, this.image, this.message})
      : super(key: key);

  @override
  _PageHeader createState() => _PageHeader();
}

class _PageHeader extends State<PageHeader> {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return ClipPath(
      clipper: MyCustomClipper(clipType: ClipType.bottom),
      child: Container(
        height: 228.5 + statusBarHeight,
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [
              // AppTheme.black,
              AppTheme.getPrimaryColor(),
              AppTheme.getPrimaryDarkColor(),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          image: DecorationImage(
            image: AssetImage('assets/images/virus.png'),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: (widget.offset < 0) ? 0 : widget.offset,
                    child: SvgPicture.asset(
                      widget.image,
                      width: 230,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  Positioned(
                    top: 50 - widget.offset / 2,
                    left: 150,
                    child: Text(
                      "${widget.message}",
                      style: AppTheme.textFieldTitlePrimaryColored
                          .copyWith(color: Colors.white, fontSize: 22.0),
                    ),
                  ),
                  Container(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
