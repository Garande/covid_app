import 'package:country_code_picker/country_code_picker.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/Paths.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/drawer/navigation_home_screen.dart';
import 'package:covid_app/views/welcome/auth_screen.dart';
import 'package:covid_app/views/welcome/profile_update_screen.dart';
import 'package:covid_app/views/welcome/verify_auth_screen.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:path/path.dart';
// import 'package:path/path.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  // ignore: close_sinks
  AuthenticationBloc _authenticationBloc;

  TabController _tabController;

  User googleFirebaseUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _tabController = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.orangeAccent,
      // backgroundColor: AppTheme.nearlyWhite,
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(2),
      //   child: Row(children: [
      //     new TabBar(
      //       isScrollable: true,
      //       controller: _tabController,
      //       indicatorColor: Colors.transparent,
      //       tabs: <Tab>[
      //         // new Tab(child: Container()),
      //         new Tab(child: Container()),
      //         new Tab(child: Container()),
      //         new Tab(child: Container()),
      //       ],
      //     ),
      //   ]),
      // ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
          if (state is AuthInProgress) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Authenticating...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }

          if (state is ProfileUpdateInProgress) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Updating profile...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }

          if (state is OtpExceptionState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.message),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }

          if (state is AuthExceptionState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.message),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }

          if (state is GoogleAuthenticated) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Google Sign In Success'),
                      Icon(Icons.check),
                    ],
                  ),
                ),
              );
            setState(() {
              googleFirebaseUser = state.user;
            });

            // print('Am Authenticated');

            if (userPhoneNumber != null &&
                userPhoneNumber.isNotEmpty &&
                countryCodeTxt != null &&
                countryCodeTxt.isNotEmpty &&
                userId != null &&
                userId.isNotEmpty &&
                googleFirebaseUser != null) {
              BlocProvider.of<AuthenticationBloc>(context).add(SendOtpEvent(
                  phoneNumber: userPhoneNumber,
                  countryCode: countryCodeTxt,
                  userId: userId,
                  googleUser: googleFirebaseUser));
            } else {
              // print('==================================================');
              // print("Signing out");
              BlocProvider.of<AuthenticationBloc>(context).add(ClickedLogout());
            }

            // _tabController.animateTo(_tabController.index + 1);
          }

          if (state is OtpSentState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Waiting for Phone Verification'),
                      Icon(Icons.check),
                    ],
                  ),
                ),
              );

            // _tabController.animateTo(_tabController.index + 1);
            _tabController.animateTo(1);
          }

          if (state is OtpVerifiedState) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone verification success'),
                      Icon(Icons.check),
                    ],
                  ),
                ),
              );

            _tabController.animateTo(_tabController.index + 1);
          }

          if (state is PreFillData) {
            AppUser user = state.user;
            populateFields(user);
            _tabController.animateTo(2);
          }

          if (state is ProfileComplete) {
            if (_tabController.index == 2) {
              //Navigate to home screen
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => NavigationHomeScreen(),
                ),
              );
            }
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
          // return Container(
          //   color: Colors.redAccent,
          // );
          return Flex(
            children: <Widget>[
              Container(
                height: 0.0,
                child: Row(children: [
                  new TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    tabs: <Tab>[
                      // new Tab(child: Container()),
                      new Tab(child: Container()),
                      new Tab(child: Container()),
                      new Tab(child: Container()),
                    ],
                  ),
                ]),
              ),
              Expanded(
                child: new TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                    // _buildSignInWithGoogle(),
                    _buildSignInWithPhone(),
                    _buildVerifyPhone(),
                    _buildUpdateProfileInfo(),
                  ],
                ),
              ),
            ],
            direction: Axis.vertical,
          );
        }),
      ),
    );
  }

  bool isLoading = false;

  Widget _buildSignInWithGoogle() {
    return Scaffold(
      body: Container(
        color: AppTheme.nearlyWhite,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.nearlyWhite,
                  radius: 40.0,
                  child: Image.asset('assets/images/yb_logo2.png'),
                ),
                SizedBox(
                  height: 50,
                ),
                _signInButton(),
              ]),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 16, top: 8),
      child: Container(
        height: 44,
        // width: width,
        decoration: BoxDecoration(
          color: AppTheme.nearlyDarkBlue,
          gradient: LinearGradient(colors: [
            AppTheme.nearlyWhite,
            AppTheme.nearlyWhite,
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.5),
                offset: const Offset(4.0, 4.0),
                blurRadius: 8.0),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            highlightColor: Colors.transparent,
            onTap: () => BlocProvider.of<AuthenticationBloc>(context)
                .add(ClickedGooglSignIn()),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 30),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
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
  }

  String logoPath = Paths.appLogoPath;

  String phoneNumberTxt =
      ''; //phone number plain with no country code for database
  String countryCodeTxt = '';
  String countryCodeNameTxt = '';
  String userId = '';

  String userPhoneNumber; //phone number with the country code for firebase auth

  TextEditingController phoneEditingController = new TextEditingController();
  String countryDialCode = '+256';
  String countryNameCode = 'UG';

  Widget _buildSignInWithPhone() {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // BEGIN:: LOGO SECTION
                  Padding(
                    padding: EdgeInsets.only(top: 75.0),
                    child: Image.asset(
                      'assets/images/logo-light.png',
                      height: 68,
                    ),
                  ),
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
                                      'SIGN IN',
                                      style: AppTheme.displayTextBoldColoured,
                                    ),
                                    Container(
                                      width: 60,
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
                                          AppWidgets().getCustomEditTextField(
                                            hintValue: 'xxxxxxxxx',
                                            prefixWidget: countryCodeWidget(),
                                            controller: phoneEditingController,
                                            style: AppTheme
                                                .textFieldTitlePrimaryColored,
                                            keyboardType: TextInputType.number,
                                          ),
                                          SizedBox(height: 20.0),
                                          Text(
                                            'By tapping continue, you agree to Terms and Conditions and Privacy Policy of COVID APP',
                                            style: AppTheme.subTitleTextColored,
                                          ),
                                          SizedBox(height: 20.0),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // signIn(phoneEditingController.text,
                                //     countryDialCode, countryNameCode);

                                _tabController.animateTo(1);
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

    // return PhonePage(
    //   logoPath: logoPath,
    //   startAuth:
    // );
  }

  void signIn(var phoneNumber, var countryCode, var countryCodeName) {
    if (phoneNumber.toString().isNotEmpty) {
      countryCodeTxt = countryCode;
      phoneNumberTxt = (phoneNumber.toString()[0] == '0'
          ? phoneNumber.toString().substring(1)
          : phoneNumber.toString());

      countryCodeNameTxt = countryCodeName;
      userId = countryCodeNameTxt + phoneNumberTxt;

      phoneNumber = countryCode +
          (phoneNumber.toString()[0] == '0'
              ? phoneNumber.toString().substring(1)
              : phoneNumber.toString());
      // print(phoneNumber);
      // print(countryCodeName);

      userPhoneNumber = phoneNumber;

      BlocProvider.of<AuthenticationBloc>(context).add(ClickedGooglSignIn());
    } else {
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phone Number can not be empty...'),
                Icon(Icons.error),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
    }
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

  Widget countryCodeWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: CountryCodePicker(
        textStyle: AppTheme.textFieldTitle,
        onChanged: (value) {
          // _selectedCountryCode = value.dialCode;

          countryDialCode = value.dialCode;
          countryNameCode = value.code;
        },
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: 'UG',
        // favorite: '+256',
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
    );
  }

  String photoUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  AppUser currentUser;
  Future<void> populateFields(AppUser user) async {
    if (user != null) {
      setState(() {
        photoUrl = user.photoUrl;
        nameController.text = user.name;
        emailController.text = user.email;
        dobController.text = user.dob;
        genderController.text = user.gender;
        phoneController.text = user.phoneNumber;
        currentUser = user;
      });
    } else {
      AppUser userObject = await _authenticationBloc.getCurrentUser();
      setState(() {
        photoUrl = userObject.photoUrl;
        nameController.text = userObject.name;
        emailController.text = userObject.email;
        dobController.text = userObject.dob;
        genderController.text = userObject.gender;
        phoneController.text = userObject.phoneNumber;
        currentUser = userObject;
      });
    }
  }

  Widget _buildUpdateProfileInfo() {
    return UpdateUserProfile(this);
  }

  Widget _buildVerifyPhone() {
    return PhoneAuthVerify(
      logoPath: logoPath,
      verifyOtp: (code) => BlocProvider.of<AuthenticationBloc>(context).add(
          VerifyOtpEvent(
              otp: code,
              userId: userId,
              countryCode: countryCodeTxt,
              phoneNumber: phoneNumberTxt,
              googleUser: googleFirebaseUser)),
      resendOtp: () {
        _authenticationBloc.add(ResendOtpEvent());
      },
      phoneNumber: countryCodeTxt + phoneNumberTxt,
      navigateBack: () {
        _authenticationBloc.add(ClickedLogout());
        _tabController.animateTo(_tabController.index - 1);
      },
    );
  }

  void completeUserProfile() {
    currentUser.name = nameController.text;
    currentUser.dob = dobController.text;
    currentUser.gender = genderController.text;

    BlocProvider.of<AuthenticationBloc>(context)
        .add(SaveUserProfile(null, currentUser));
  }
}
