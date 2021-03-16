import 'package:covid_app/blocs/corona/corona_bloc.dart';
import 'package:covid_app/models/question.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/test/quizScreen.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class WelcomeSelfTestScreen extends StatefulWidget {
  @override
  _WelcomeSelfTestScreenState createState() => _WelcomeSelfTestScreenState();
}

class _WelcomeSelfTestScreenState extends State<WelcomeSelfTestScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  int _duration = 2000;

  CoronaBloc _coronaBloc = CoronaBloc();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    _coronaBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      key: _scaffoldKey,
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
                  width: 120.0,
                  height: 120.0,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome to COVID-19 self checkup',
                  textAlign: TextAlign.center,
                  style: AppTheme.titleTextStyle.copyWith(
                    color: AppTheme.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Question>>(
                    future: _coronaBloc.fetchSelfTestQuestions(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingIndicator();
                      }

                      if (!snapshot.hasData) {
                        _scaffoldKey.currentState
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'NO Test Questions found! Try Again later.',
                                  ),
                                  Icon(Icons.error),
                                ],
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        return Container();
                      }
                      return Button(
                        text: 'Start Test',
                        width: 250,
                        gradient: LinearGradient(
                            colors: [
                              AppTheme.background,
                              AppTheme.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        textColor: AppTheme.primaryColorDark,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                questions: snapshot.data,
                              ),
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
