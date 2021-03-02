import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final ImageProvider image;
  final Color color;
  final VoidCallback onTap;
  final List<Widget> children;

  CardButton({
    Key key,
    @required this.image,
    @required this.color,
    this.onTap,
    this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width:
            ((MediaQuery.of(context).size.width - (30.0 * 2 + 20.0 / 2)) / 2),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: color,
        ),
        child: Material(
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Stack(
              overflow: Overflow.clip,
              children: <Widget>[
                Positioned(
                  child: ClipPath(
                    clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.black.withOpacity(0.03),
                      ),
                      height: 110,
                      width: 110,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Icon and Hearbeat
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image(width: 32, height: 32, image: image),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ...children,
                    ],
                  ),
                )
              ],
            ),
            onTap: onTap,
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
