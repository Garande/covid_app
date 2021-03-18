import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

int _duration = 2000;

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.primaryColorDark],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: FadeTransition(
          opacity: _animation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Paths.appLogoPath,
                  width: 90.0,
                  height: 90.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Covid-19 Contact Tracker',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleTextStyle.copyWith(
                    color: AppTheme.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
