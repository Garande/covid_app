import 'dart:io';

import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/file_select_modal.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatefulWidget {
  AppUser appUser;
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm>
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
      populateFields();
    } else
      fetchUser();
  }

  void fetchUser() async {
    appUser = await _authenticationBloc.getCurrentUser();
    setState(() {});
    populateFields();
  }

  AppUser appUser;
  File image;

  List gender = ["Male", "Female", "Other"];
  String select;

  void selectFile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FileSelectModal(
        onCameraTap: (file) {
          Navigator.of(context).pop();
          setState(() {
            image = file;
          });
          // selectDriverImage(file);
        },
        onFolderTap: (file) {
          Navigator.of(context).pop();
          setState(() {
            image = file;
          });
        },
      ),
    );
  }

  void populateFields() {
    if (appUser != null) {
      setState(() {
        nameController.text = appUser.name;
        ninController.text = appUser.nationalIdNo;
        addressController.text = appUser.address;
        select = appUser.gender;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text('Edit Account'),
        backgroundColor: AppTheme.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: BlocListener(
        cubit: _movementsBloc,
        listener: (BuildContext context, MovementsState state) {
          if (state is Uploading) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Uploading...'),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
            setState(() {
              isLoading = true;
              _loadingAnimationController.forward();
            });
          }

          if (state is UploadException) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.dangerColor,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.message),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
            if (_loadingAnimationController.isCompleted)
              _loadingAnimationController.reverse();
            isLoading = false;
            setState(() {});
          }

          if (state is UploadComplete) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.successColor,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profile updated successfuly'),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
            if (_loadingAnimationController.isCompleted)
              _loadingAnimationController.reverse();
            isLoading = false;
            setState(() {});
            // Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _renderProfileWidget(screenWidth),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }

  //renderProfileWidget
  Widget _renderProfileWidget(double screnWidth) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 25, bottom: 25, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: image == null
                              ? Image.network(
                                  appUser != null ? appUser.photoUrl : '',
                                  width: 120,
                                  height: 120,
                                )
                              : Image.file(
                                  image,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: GestureDetector(
                              onTap: () {
                                selectFile();
                                // getImage();
                              },
                              child: Container(
                                height: 30.0,
                                width: 30.0,
                                child: Icon(
                                  Icons.edit,
                                  color: AppTheme.white,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 34.0,
                    ),
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
                    SizedBox(
                      height: 25.0,
                    ),

                    //gender textField
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select Gender',
                          style: AppTheme.textFieldTitlePrimaryColored.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        //Use the above widget where you want the radio button
                        Container(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              addRadioButton(0, 'Male'),
                              addRadioButton(1, 'Female'),
                              addRadioButton(2, 'Others'),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Button(
                      paddingInsets: EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      text: 'Save',
                      onTap: () {
                        appUser.name = nameController.text;
                        appUser.nationalIdNo = ninController.text;
                        appUser.address = addressController.text;
                        appUser.gender = select;
                        _movementsBloc.add(UpdateProfile(image, appUser));
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
          // if (isLoading) spinkit,
        ],
      ),
    );
  }

  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: AppTheme.primaryColor,
          value: gender[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(
          title,
          style: AppTheme.subTitleText,
        )
      ],
    );
  }
}
