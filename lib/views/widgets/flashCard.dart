import 'dart:math' as math;

import 'package:covid_app/models/question.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/flipCard.dart';
import 'package:flutter/material.dart';

class FlashCard extends StatelessWidget {
  const FlashCard(
      {Key key,
      @required this.cardWidth,
      this.onExplanationClick,
      this.widgets})
      : super(key: key);
  final double cardWidth;
  final Function onExplanationClick;
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.of(context).size.height;
    double _deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: new Card(
        color: Colors.transparent,
        elevation: 4.0,
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: _deviceWidth / 1.2 + cardWidth,
          height: _deviceHeight / 1.7,
          decoration: new BoxDecoration(
            color: AppTheme.nearlyWhite,
            borderRadius: new BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: new BorderRadius.all(
              Radius.circular(10.0),
            ),
            clipBehavior: Clip.hardEdge,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets != null && widgets.length != 0 ? widgets : [],
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveFlashCard extends StatefulWidget {
  ActiveFlashCard({
    Key key,
    this.bottom,
    this.right,
    this.left,
    this.cardWidth,
    this.rotation,
    this.skew,
    this.swipeFlag,
    this.dismissCardLeft,
    this.dismissCardRight,
    this.question,
    this.onCardClick,
    @required this.deviceHeight,
    @required this.deviceWidth,
    this.animationController,
    // this.learningBloc,
    this.onAnswerCallBack,
    this.selectedAnswerId,
    @required this.scaffoldKey,
  }) : super(key: key);
  final double bottom;
  final double right;
  final double left;
  final double cardWidth;
  final double rotation;
  final double skew;
  final int swipeFlag;
  final Question question;
  final String selectedAnswerId;

  final Function(Question question) dismissCardLeft;
  final Function(Question question) dismissCardRight;
  final Function onCardClick;
  final Function(String answerId) onAnswerCallBack;

  final double deviceHeight;
  final double deviceWidth;

  final AnimationController animationController;

  // final LearningBloc learningBloc;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ActiveFlashCardState createState() => _ActiveFlashCardState();
}

class _ActiveFlashCardState extends State<ActiveFlashCard>
    with TickerProviderStateMixin {
  bool isTimeOut = false;

  @override
  Widget build(BuildContext context) {
    Color correctColor = Colors.green;
    Color correctFillColor = correctColor.withOpacity(0.3);
    Color incorrectColor = Colors.red;
    Color incorrectFillColor = incorrectColor.withOpacity(0.2);
    Color unsetColor = Colors.white;
    Color neutralColor = AppTheme.primaryColor;

    Color unsetBorderColor = Colors.grey;

    return Positioned(
      bottom: 60.0 + widget.bottom,
      right: widget.swipeFlag == 0
          ? widget.right != 0.0
              ? widget.right
              : null
          : null,
      left: widget.swipeFlag == 1
          ? widget.right != 0.0
              ? widget.right
              : null
          : null,
      child: new Dismissible(
        confirmDismiss: (direction) async {
          await Future<dynamic>.delayed(const Duration(milliseconds: 50));
          if (widget.selectedAnswerId != '' &&
              widget.selectedAnswerId != null) {
            return true;
          } else {
            widget.scaffoldKey.currentState.hideCurrentSnackBar();
            widget.scaffoldKey.currentState.showSnackBar(
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
        },
        key: new Key(new math.Random().nextInt(1000000).toString()),
        crossAxisEndOffset: -0.3,
        onResize: () {},
        onDismissed: (DismissDirection dismissDirection) {
          if (dismissDirection == DismissDirection.endToStart) {
            widget.dismissCardLeft(widget.question);
          } else {
            widget.dismissCardRight(widget.question);
          }
        },
        child: Transform(
          alignment: widget.swipeFlag == 0
              ? Alignment.bottomRight
              : Alignment.bottomLeft,
          transform: new Matrix4.skewX(widget.skew),
          child: new RotationTransition(
            turns: new AlwaysStoppedAnimation(
              widget.swipeFlag == 0
                  ? widget.rotation / 360
                  : -widget.rotation / 360,
            ),
            child: Hero(
              tag: 'QuizCard',
              child: FlipCard(
                flipAxis: FlipAxis.horizontal,
                height: 40,
                width: 20,
                onTap: () {},
                animationController: widget.animationController,
                willHandleCallBackWithChild: true,
                frontChild: FlashCard(
                  cardWidth: widget.cardWidth,
                  widgets: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 25),
                      child: Column(
                        children: [
                          _buildTextWidget(widget.question.question),
                        ],
                        // DeltaParser.parseDeltaContent(
                        //   widget.question.questionDelta,
                        // ),
                      ),
                    ),
                    // Text(
                    //   widget.question.question,
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildAnswers(
                          correctColor: correctColor,
                          correctFillColor: correctFillColor,
                          neutralColor: neutralColor,
                          incorrectColor: incorrectColor,
                          incorrectFillColor: incorrectFillColor,
                          unsetColor: unsetColor,
                          unsetBorderColor: unsetBorderColor,
                          options: widget.question.options,
                          answerId: widget.question.answerId,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    isTimeOut || widget.selectedAnswerId.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              // print('Oyeeeeeeeee');
                              try {
                                widget.animationController.forward();
                              } catch (e) {}
                            },
                            child: widget.question.explanation != null &&
                                    widget.question.explanation != ""
                                ? Container(
                                    height: 40,
                                    width: 150.0,
                                    child: Center(
                                      child: Text(
                                        'Explanation?',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.darkText
                                              .withOpacity(0.8),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        : SizedBox(),
                  ],
                ),
                backChild: GestureDetector(
                  onTap: () {
                    try {
                      widget.animationController.reverse();
                    } catch (e) {}
                  },
                  child: FlashCard(
                    cardWidth: widget.cardWidth,
                    widgets: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            _buildTextWidget(widget.question.explanation),
                          ],

                          // DeltaParser.parseDeltaContent(
                          //   widget.question.explanation,
                          // ),
                        ),
                        // child: Text(
                        //   widget.question.answerDetails != null
                        //       ? widget.question.answerDetails
                        //       : '',
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTextWidget(String text) {
    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnswerButton({
    Color incorrectFillColor,
    Color incorrectColor,
    Color correctFillColor,
    Color correctColor,
    Color unsetColor,
    Color unsetBorderColor,
    Color neutralColor,
    QuizOption option,
    int index,
    String answerId,
  }) =>
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 8),
        child: Container(
          // height: 45.0,
          width: double.infinity,
          decoration: BoxDecoration(
              color: isTimeOut
                  ? option.id == answerId
                      ? correctFillColor
                      : incorrectFillColor
                  : option.id == widget.selectedAnswerId &&
                          (answerId == null || answerId == '')
                      ? neutralColor.withOpacity(0.2)
                      : option.id == widget.selectedAnswerId &&
                              widget.selectedAnswerId == answerId
                          ? correctFillColor
                          : option.id == widget.selectedAnswerId
                              ? incorrectFillColor
                              : widget.selectedAnswerId.isNotEmpty &&
                                      option.id == answerId
                                  ? correctFillColor
                                  : unsetColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              border: Border.all(
                width: 2,
                color: isTimeOut
                    ? option.id == answerId
                        ? correctColor
                        : incorrectColor
                    : option.id == widget.selectedAnswerId &&
                            (answerId == null || answerId == '')
                        ? neutralColor
                        : option.id == widget.selectedAnswerId &&
                                widget.selectedAnswerId == answerId
                            ? correctColor
                            : option.id == widget.selectedAnswerId
                                ? incorrectColor
                                : widget.selectedAnswerId.isNotEmpty &&
                                        option.id == answerId
                                    ? correctColor
                                    : unsetBorderColor,
              )),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (widget.selectedAnswerId.isEmpty) {
                    // widget.selectedAnswerId = option.id;
                    widget.onAnswerCallBack(option.id);
                    // widget.selectedAnswerId = option.id;
                  }
                });
                // widget.learningBloc.add(StopQuizTimer());
                // widget.learningBloc.add(
                //   SubmitQuizAnswer(
                //     AnswerStatus.unMarked,
                //     correctAnswerId: answerId,
                //     selectedAnswerId: option.id,
                //   ),
                // );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 10, top: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _getAlphabet(index) + '.  ',
                            style: TextStyle(
                                color: AppTheme.nearlyBlack,
                                fontWeight: FontWeight.w700),
                          ),
                          // TextSpan(
                          //   text: option.answer,
                          //   style: TextStyle(
                          //       color: AppTheme.nearlyBlack,
                          //       fontWeight: FontWeight.w400),
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextWidget(option.answer),
                            ]

                            // DeltaParser.parseDeltaContent(
                            //   option.answerDelta,
                            // ),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  _buildAnswers({
    Color correctColor,
    Color correctFillColor,
    Color incorrectColor,
    Color incorrectFillColor,
    Color unsetColor,
    Color unsetBorderColor,
    Color neutralColor,
    List<QuizOption> options,
    String answerId,
  }) {
    // options.shuffle();
    return Column(
      children: options
          .map((option) => _buildAnswerButton(
                correctColor: correctColor,
                correctFillColor: correctFillColor,
                incorrectColor: incorrectColor,
                incorrectFillColor: incorrectFillColor,
                unsetColor: unsetColor,
                unsetBorderColor: unsetBorderColor,
                neutralColor: neutralColor,
                option: option,
                index: options.indexOf(option),
                answerId: answerId,
              ))
          .toList(),
    );
  }

  _getAlphabet(int index) {
    List<String> optionAlphabets = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J'
    ];

    return optionAlphabets[index];
  }
}

class InActiveFlashCard extends StatelessWidget {
  const InActiveFlashCard({Key key, this.bottom, this.cardWidth})
      : super(key: key);
  final double bottom;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60.0 + bottom,
      child: Opacity(
        child: FlashCard(cardWidth: cardWidth),
        opacity: 0.4,
      ),
    );
  }
}
