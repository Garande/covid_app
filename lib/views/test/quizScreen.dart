import 'dart:async';

import 'package:covid_app/blocs/corona/corona_bloc.dart';
import 'package:covid_app/models/question.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/flashCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    Key key,
    this.questions,
    // this.learningBloc,
  }) : super(key: key);
  final List<Question> questions;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> rotate;
  Animation<double> right;
  Animation<double> bottom;
  Animation<double> width;

  List<Question> questions;

  int swipeFlag = 0;

  AnimationController flipCardAnimationController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Scaffold

  Timer _timer;

  // LearningBloc _learningBloc;

  bool areQuestionsAvailable = false;

  CoronaBloc _coronaBloc = CoronaBloc();

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    flipCardAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );

    questions = widget.questions;
    if (widget.questions.length > 0) {
      areQuestionsAvailable = true;
    }

    // if (widget.learningBloc != null)
    //   _learningBloc = widget.learningBloc;
    // else
    //   _learningBloc = LearningBloc();
    // if (questions.length > 0) {
    //   _learningBloc.add(StartQuizTimer(
    //     questions[questions.length - 1].assignedTimeInSeconds,
    //   ));
    //   _learningBloc.startQuiz(questions.length);
    // }

    rotate = new Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      ),
    );

    rotate.addListener(() {
      setState(() {
        //remove the current card and insert new card

        animationController.reset();
      });
    });

    right = new Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      ),
    );

    bottom = new Tween<double>(
      begin: 15.0,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      ),
    );

    width = new Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _coronaBloc.close();
    // _learningBloc.add(
    //   StoreQuizResults(
    //     classId: widget.classId,
    //     subjectId: widget.subjectId,
    //     topicId: widget.topicId,
    //   ),
    // );
    animationController.dispose();
    flipCardAnimationController.dispose();
    // if (widget.learningBloc == null) _learningBloc.dispose();
    if (_timer != null) {
      _timer.cancel();
    }

    super.dispose();
  }

  Future<Null> _swipeAnimation() async {
    try {
      await animationController.forward();
    } on TickerCanceled {}
  }

  void swipeRight() {
    if (swipeFlag == 0) {
      setState(() {
        swipeFlag = 1;
      });
      _swipeAnimation();
    }
  }

  void swipeLeft() {
    if (swipeFlag == 1) {
      setState(() {
        swipeFlag = 0;
      });
      _swipeAnimation();
    }
  }

  _resetFlipAnimationController() {
    try {
      flipCardAnimationController.reset();
    } catch (e) {}
  }

  dismissCardLeft(Question question) {
    setState(() {
      activeQuestion = null;
      questions.remove(question);
      selectedAnswerId = '';
    });
    if (questions.length > 0) {
      // _learningBloc.add(StartQuizTimer(
      //   questions[questions.length - 1].assignedTimeInSeconds,
      // ));
    }
    _resetFlipAnimationController();
  }

  dismissCardRight(Question question) {
    setState(() {
      activeQuestion = null;
      questions.remove(question);
      selectedAnswerId = '';
    });
    // _learningBloc.add(StartQuizTimer(
    //   questions[questions.length - 1].assignedTimeInSeconds,
    // ));
    _resetFlipAnimationController();
  }

  // int elapsedTime;
  // int remainingTime;
  // int questionTime;

  Question activeQuestion;
  String selectedAnswerId = '';

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    // questions.shuffle();

    double initialBottom = 15.0;
    int itemsLength = questions.length;
    double backCardPosition = initialBottom +
        (itemsLength - 1) /**length of questions list */ * 10 +
        10;
    double backCardWidth = -10.0;

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.background,
      key: _scaffoldKey,
      // appBar:
      //     PreferredSize(child: Container(), preferredSize: Size.fromHeight(2)),
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              child: Text(
                'COVID-19 Self checkup',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                'Select only that apply',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppTheme.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   height: 30,
            //   child: QuizProgressBar(
            //     learningBloc: _learningBloc,
            //   ),
            // ),
            Expanded(
              child: questions.length > 0
                  ? Container(
                      child: new Stack(
                        alignment: AlignmentDirectional.center,
                        children: questions.map((question) {
                          if (questions.indexOf(question) == itemsLength - 1) {
                            activeQuestion = question;
                            return new ActiveFlashCard(
                              deviceWidth: deviceWidth,
                              deviceHeight: deviceHeight,
                              bottom: bottom.value,
                              right: right.value,
                              left: 0.0,
                              cardWidth: backCardWidth + 10,
                              rotation: rotate.value,
                              skew: rotate.value < -10 ? 0.1 : 0.0,
                              swipeFlag: swipeFlag,
                              question: question,
                              dismissCardLeft: dismissCardLeft,
                              dismissCardRight: dismissCardRight,
                              animationController: flipCardAnimationController,
                              // learningBloc: _learningBloc,
                              selectedAnswerId: selectedAnswerId,
                              onAnswerCallBack: (answerId) {
                                setState(() {
                                  selectedAnswerId = answerId;
                                });
                              },
                              scaffoldKey: _scaffoldKey,
                            );
                          } else {
                            backCardPosition = backCardPosition - 10;
                            backCardWidth = backCardWidth + 10;

                            return InActiveFlashCard(
                              bottom: backCardPosition,
                              cardWidth: backCardWidth,
                            );
                          }
                        }).toList(),
                      ),
                    )
                  : !areQuestionsAvailable
                      ? Container(
                          width: double.infinity,
                          // height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'No questions available',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppTheme.nearlyDarkBlue,
                                          fontSize: 29,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          // height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        'Test Results',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppTheme.primaryColorDark,
                                          fontSize: 29,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // _buildResultText(
                                    //   label: 'Total No. of Questions:',
                                    //   result: _learningBloc.noOfQuestions,
                                    // ),
                                    // _buildResultText(
                                    //   label: 'Passed: ',
                                    //   result: _learningBloc.correctAnswers,
                                    // ),
                                    // _buildResultText(
                                    //   label: 'Failed: ',
                                    //   result: _learningBloc.failedAnswers,
                                    // ),
                                    // _buildResultText(
                                    //     label: 'Timed out: ',
                                    //     result: _learningBloc.timedOutAnswers),
                                    // _buildResultText(
                                    //     label: 'Comment: ', result: ''),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 45, right: 10),
                                    //   child: Text(
                                    //     '${getResultComment(getPercentageMark(_learningBloc.noOfQuestions, _learningBloc.correctAnswers))}',
                                    //     style: TextStyle(
                                    //         color: AppTheme.nearlyDarkBlue,
                                    //         fontSize: 17,
                                    //         fontWeight: FontWeight.w600),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
            ),

            Button(
              text: questions.length > 0 ? 'Next' : 'Finish',
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
                if (questions.length > 0) {
                  assert(activeQuestion != null);
                  if (selectedAnswerId != '' && selectedAnswerId != null) {
                    dismissCardLeft(activeQuestion);
                  } else {
                    _scaffoldKey.currentState.hideCurrentSnackBar();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select answer first to continue'),
                            Icon(Icons.error),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return false;
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            // Container(
            //   // color: Colors.red,
            //   padding: const EdgeInsets.only(
            //     left: 50,
            //     right: 50,
            //     top: 0,
            //   ),
            //   // margin: const EdgeInsets.only(top: 5),
            //   child: StreamBuilder(
            //     stream: _learningBloc.quizTimeStream,
            //     builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            //       return Button(
            //         text: questions.length > 0 ? 'Next' : 'Finish',
            //         onTap: () {
            //           //
            //           if (questions.length > 0) {
            //             assert(activeQuestion != null);
            //             if (selectedAnswerId != '' || snapshot.data == 0)
            //               dismissCardLeft(activeQuestion);
            //           } else {
            //             Navigator.pop(context);
            //           }
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  double getPercentageMark(int totalQn, int correctAns) {
    return ((correctAns / totalQn) * 100);
  }

  String getResultGradeRemark(double percentMark) {
    if (percentMark >= 90)
      return 'Excellent';
    else if (percentMark >= 70 && percentMark < 90)
      return 'Very Good';
    else if (percentMark >= 50 && percentMark < 70)
      return 'Good Trial';
    else if (percentMark < 50) return 'Failed';
  }

  String getResultComment(double percentMark) {
    if (percentMark >= 90)
      return 'Keep it up';
    else if (percentMark >= 70 && percentMark < 90)
      return 'Do more exercises to hit the Target';
    else if (percentMark >= 50 && percentMark < 70)
      return 'Double your efforts';
    else if (percentMark < 50)
      return 'You need to Review the topic, You can do better';
  }

  _buildResultText({String label, result}) => Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  // color: AppTheme.nearlyDarkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              '${result.toString()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: AppTheme.nearlyDarkBlue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}
