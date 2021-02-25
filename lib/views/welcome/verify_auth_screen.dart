import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';

class PhoneAuthVerify extends StatefulWidget {
  // final Color cardBackgroundColor = Color(0xFFFCA967);
  Color cardBackgroundColor = AppTheme.nearlyWhite;
  String appName = "Verify Phone";

  final Function verifyOtp;
  final Function resendOtp;
  final Function skipVerification;
  final Function navigateBack;

  final String sentOtp;
  final String logoPath;
  final String phoneNumber;

  PhoneAuthVerify({
    Key key,
    this.verifyOtp,
    this.resendOtp,
    this.sentOtp,
    this.logoPath,
    this.skipVerification,
    @required this.phoneNumber,
    @required this.navigateBack,
  }) : super(key: key);

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  TextEditingController textController4 = TextEditingController();
  TextEditingController textController5 = TextEditingController();
  TextEditingController textController6 = TextEditingController();
  String code = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: MyCustomClipper(clipType: ClipType.bottom),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [
                        AppTheme.getPrimaryColor(),
                        AppTheme.getPrimaryDarkColor(),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 55.0, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: 34,
                          child: RawMaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            onPressed: widget.navigateBack,
                            child: Icon(Icons.arrow_back_ios,
                                size: 15.0, color: Colors.white),
                            shape: CircleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // BEGIN:: LOGO SECTION
                  // Padding(
                  //   padding: EdgeInsets.only(top: 75.0),
                  //   child: Image.asset(
                  //     'assets/images/logo-light.png',
                  //     height: 68,
                  //   ),
                  // ),
                  // BEGIN CARD SECTION
                  Container(
                    padding: EdgeInsets.only(top: 60),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Center(
                              // padding: const EdgeInsets.symmetric(
                              //   horizontal: 20,
                              // ),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30.0),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      10.0,
                                    ),
                                  ),
                                  boxShadow: AppTheme.boxShadow,
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width - 50,
                                // height: 340.0,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      'VERIFY',
                                      style: AppTheme.displayTextBoldColoured,
                                    ),
                                    Container(
                                      width: 50,
                                      height: 2,
                                      color: AppTheme.getPrimaryColor(),
                                    ),
                                    SizedBox(height: 25.0),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Column(
                                        children: [
                                          RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Please enter the verification code that was sent to ',
                                                  style: TextStyle(
                                                    color: AppTheme.darkText,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '${widget.phoneNumber}',
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .getPrimaryColor(),
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              getField("1", focusNode1,
                                                  textController1),
                                              SizedBox(width: 5.0),
                                              getField("2", focusNode2,
                                                  textController2),
                                              SizedBox(width: 5.0),
                                              getField("3", focusNode3,
                                                  textController3),
                                              SizedBox(width: 5.0),
                                              getField("4", focusNode4,
                                                  textController4),
                                              SizedBox(width: 5.0),
                                              getField("5", focusNode5,
                                                  textController5),
                                              SizedBox(width: 5.0),
                                              getField("6", focusNode6,
                                                  textController6),
                                              SizedBox(width: 5.0),
                                            ],
                                          ),
                                          SizedBox(height: 20.0),
                                          Text(
                                            'If you didn\'t receive the code, Please tap resend to get the code again',
                                            textAlign: TextAlign.justify,
                                            style: AppTheme.subTitleTextColored,
                                          ),
                                          SizedBox(height: 20.0),
                                          FlatButton(
                                            onPressed: widget.resendOtp,
                                            child: Text(
                                              'Resend',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w800,
                                                color:
                                                    AppTheme.getPrimaryColor(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                String pin = textController1.text.trim() +
                                    textController2.text.trim() +
                                    textController3.text.trim() +
                                    textController4.text.trim() +
                                    textController5.text.trim() +
                                    textController6.text.trim();
                                widget.verifyOtp(pin);
                              },
                              child:
                                  signupSubmitButton(iconPath: 'login_submit'),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget signupSubmitButton({String iconPath}) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        boxShadow: AppTheme.iconBoxShadow,
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(
          'assets/images/getStartedImages/${iconPath}.png',
          width: 45,
          height: 45,
        ),
      ),
    );
  }

  Widget _getColumnBody() => Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: widget.navigateBack,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(widget.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.darkText,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),

          // AppName:
          SizedBox(height: 20.0),
          Center(
            child: Container(
              width: _width * 8 / 10,
              // color: Colors.redAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // SizedBox(width: 20.0),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Please enter the verification code that was sent to ',
                                style: TextStyle(
                                  color: AppTheme.darkText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '${widget.phoneNumber}',
                                style: TextStyle(
                                  color: AppTheme.getPrimaryColor(),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20.0),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      getField("1", focusNode1, textController1),
                      SizedBox(width: 5.0),
                      getField("2", focusNode2, textController2),
                      SizedBox(width: 5.0),
                      getField("3", focusNode3, textController3),
                      SizedBox(width: 5.0),
                      getField("4", focusNode4, textController4),
                      SizedBox(width: 5.0),
                      getField("5", focusNode5, textController5),
                      SizedBox(width: 5.0),
                      getField("6", focusNode6, textController6),
                      SizedBox(width: 5.0),
                    ],
                  ),
                  SizedBox(height: _fixedPadding * 1.5),
                  Button(
                    height: 45.0,
                    paddingInsets: const EdgeInsets.only(left: 0, right: 0),
                    width: MediaQuery.of(context).size.width,
                    text: 'Verify Code',
                    onTap: () {
                      String pin = textController1.text.trim() +
                          textController2.text.trim() +
                          textController3.text.trim() +
                          textController4.text.trim() +
                          textController5.text.trim() +
                          textController6.text.trim();
                      widget.verifyOtp(pin);
                    },
                  ),
                  SizedBox(height: _fixedPadding * .7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: widget.resendOtp,
                        child: Text(
                          'Resend',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.getPrimaryColor(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );

  Widget getField(String key, FocusNode fn, TextEditingController controller) =>
      Expanded(
        child: AppWidgets().getCustomEditTextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: key.contains("1") ? true : false,
          focusNode: fn,
          style: AppTheme.textFieldTitlePrimaryColored,
          onChanged: (String value) {
            value.trim();
            if (value.length == 1) {
              code += value;
              code.trim();
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).unfocus();
                  break;
              }
            } else {
              code = code.substring(0, code.length - 1);
              code.trim();
              // printLog(code);
            }
          },
          textAlign: TextAlign.center,
        ),
      );
}
