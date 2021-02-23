import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final List<Slide> slides = [];
  List<Widget> tabs = new List();

  List introContent = [
    {
      "title": "Welcome To",
      "image": "assets/images/getStartedImages/intro_slide_one.png",
      "desc": "Start or join a video meeting on the go"
    },
    {
      "title": "Message Your Team",
      "image": "assets/images/getStartedImages/intro_slide_one.png",
      "desc": "Send text, voice message and share file"
    },
    {
      "title": "Get MeetAiring",
      "image": "assets/images/getStartedImages/intro_slide_one.png",
      "desc": "Work anywhere, with anyone, one any device"
    }
  ];

  @override
  void initState() {
    for (int i = 0; i < introContent.length; i++) {
      Slide slide = Slide(
        title: introContent[i]['title'],
        description: introContent[i]['desc'],
        marginTitle: EdgeInsets.only(
          top: 100.0,
          bottom: 50.0,
        ),
        maxLineTextDescription: 2,
        styleTitle: AppTheme.title,
        backgroundColor: Colors.white,
        marginDescription: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
        styleDescription: AppTheme.body,
        foregroundImageFit: BoxFit.fitWidth,
      );

      slide.pathImage = introContent[i]['image'];
      slides.add(slide);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      shouldHideStatusBar: true,
      colorActiveDot: AppTheme.getPrimaryColor(),
      isShowSkipBtn: true,
      isShowPrevBtn: true,
      slides: slides,
      backgroundColorAllSlides: Colors.white,
      styleNameDoneBtn: AppTheme.subTitleTextColored,
      styleNameSkipBtn: AppTheme.subTitleTextColored,
      listCustomTabs: this.renderCustomTabs(),
      nameNextBtn: "NEXT",
      namePrevBtn: "PREV",
      nameDoneBtn: "SIGNUP",
      onDonePress: () {},
    );
  }

  List<Widget> renderCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: 60.0, top: 60.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  currentSlide.title,
                  style: currentSlide.styleTitle,
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              Container(
                child: Text(
                  currentSlide.description,
                  style: currentSlide.styleDescription,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 100.0),
              ),
              Container(
                child: GestureDetector(
                    child: Image.asset(
                  currentSlide.pathImage,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.contain,
                )),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                child: InkWell(
                  onTap: () {},
                  child: Button(
                    text: 'Get Started',
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return tabs;
  }
}
