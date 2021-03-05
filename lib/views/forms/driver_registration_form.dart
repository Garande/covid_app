import 'dart:io';

import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverRegistrationForm extends StatefulWidget {
  final AppUser appUser;

  const DriverRegistrationForm({Key key, this.appUser}) : super(key: key);
  @override
  _DriverRegistrationFormState createState() => _DriverRegistrationFormState();
}

class _DriverRegistrationFormState extends State<DriverRegistrationForm>
    with SingleTickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  AuthenticationBloc _authenticationBloc;

  MovementsBloc _movementsBloc;

  AnimationController _loadingAnimationController;
  Animation _loadingAnimation;
  bool isLoading = false;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _movementsBloc = MovementsBloc();
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 260,
      ),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _loadingAnimationController,
    );
    _loadingAnimation =
        Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    if (widget.appUser != null) {
      appUser = widget.appUser;
      // populateFields();
    } else
      fetchUser();
  }

  void fetchUser() async {
    appUser = await _authenticationBloc.getCurrentUser();
    setState(() {});
    // populateFields();
  }

  AppUser appUser;
  File image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Registration'),
        backgroundColor: AppTheme.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          _buildForm(context),
          isLoading
              ? AnimatedBuilder(
                  animation: _loadingAnimation,
                  builder: (_, __) {
                    return IgnorePointer(
                      ignoring: _loadingAnimation.value == 0,
                      child: Container(
                        color: Colors.black.withOpacity(
                          _loadingAnimation.value * 0.5,
                        ),
                        child: Center(
                          child: LoadingIndicator(),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  // final String userId;
  // final String vehicleType;
  // final String permitNo;
  // final String permitUrl;
  // final String plateNumber;
  // final String status;
  // final String vehicleStatus;
  // final String vehicleOnBoardCount;

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 25, bottom: 25, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // SizedBox(
                        //   height: 34.0,
                        // ),
                        AppWidgets().getCustomEditTextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: nameController,
                          hintValue: 'Name',
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Image.asset(
                              'assets/images/icons/person.png',
                              scale: 3,
                            ),
                          ),
                          style: AppTheme.textFieldTitlePrimaryColored,
                        ),
                        SizedBox(height: 25.0),
                        AppWidgets().getCustomEditTextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: ninController,
                          hintValue: 'National Id No. (NIN)',
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Image.asset(
                              'assets/images/icons/person.png',
                              scale: 3,
                            ),
                          ),
                          style: AppTheme.textFieldTitlePrimaryColored,
                        ),
                        SizedBox(height: 25.0),
                        AppWidgets().getCustomEditTextField(
                          keyboardType: TextInputType.emailAddress,
                          hintValue: 'Address',
                          controller: addressController,
                          prefixWidget: Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Image.asset(
                              'assets/images/icons/person.png',
                              scale: 3,
                            ),
                          ),
                          style: AppTheme.textFieldTitlePrimaryColored,
                        ),
                        SizedBox(height: 14.0),
                        Button(
                          paddingInsets: EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          text: 'Save',
                          onTap: () {
                            // appUser.name = nameController.text;
                            // appUser.nationalIdNo = ninController.text;
                            // appUser.address = addressController.text;
                            // appUser.gender = select;
                            // _movementsBloc.add(UpdateProfile(image, appUser));
                          },
                        ),
                      ],
                    ),
                  ),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: AppTheme.boxShadow,
                    color: AppTheme.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
