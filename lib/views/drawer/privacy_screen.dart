import 'package:covid_app/views/widgets/cardContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:covid_app/data/privacy_policy.dart';
import 'package:covid_app/utils/app_theme.dart';
// import 'package:covid_app/views/widgets/card_container.dart';

class PrivacyScreen extends StatefulWidget {
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  Widget renderPrivacyPolicy() {
    return Html(
      data: getPrivacyPolicy(),
      style: {
        'p': Style(fontFamily: AppTheme.fontName),
        'h1': Style(fontFamily: AppTheme.fontName),
        'h2': Style(fontFamily: AppTheme.fontName),
        'h3': Style(fontFamily: AppTheme.fontName),
        'li': Style(
            margin: new EdgeInsets.only(left: 10, top: 15),
            fontFamily: AppTheme.fontName)
      },
      onLinkTap: (link) {
        // launchURL(link);
      },
      onImageTap: (url) {
        if (url.contains('data:image/')) {
          // Navigator.push(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (context) => FullImageView(
          //               base64Data: url,
          //             )));
        } else {
          // Navigator.push(
          //     context,
          //     new MaterialPageRoute(
          //         builder: (context) => FullImageView(
          //               url: url,
          //             )));
        }
      },
    );
  }

  Widget _buildOverlayBackground() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return IgnorePointer(
          ignoring: _animation.value == 0,
          child: InkWell(
            onTap: () => _animationController.reverse(),
            child: Container(
              color: Colors.black.withOpacity(_animation.value * 0.5),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CardContainer(
            // appBar: true,
            image: 'assets/images/legal.png',
            children: <Widget>[
              SizedBox(height: screenSize.height * 0.144),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: renderPrivacyPolicy(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildOverlayBackground(),
        ],
      ),
    );
  }
}
