import 'dart:io';

import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ninController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    appUser = await _authenticationBloc.getCurrentUser();
    setState(() {});
  }

  AppUser appUser;
  File image;

  List gender = ["Male", "Female", "Other"];
  String select;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text('Edit Account'),
        backgroundColor: AppTheme.primaryColor,

        // leading: GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _renderProfileWidget(screenWidth),
                  // AppWidgets().getCustomEditTextField(
                  //   hintValue: 'Name',
                  //   controller: nameController,
                  //   prefixWidget: Image.asset(
                  //     'assets/images/icons/person.png',
                  //     scale: 3,
                  //   ),
                  //   keyboardType: TextInputType.text,
                  //   style: AppTheme.textFieldTitle,
                  // ),
                  // SizedBox(height: 15.0),
                  // AppWidgets().getCustomEditTextField(
                  //   hintValue: 'National Id No. (NIN)',
                  //   controller: ninController,
                  //   prefixWidget: Image.asset(
                  //     'assets/images/icons/person.png',
                  //     scale: 3,
                  //   ),
                  //   keyboardType: TextInputType.text,
                  //   style: AppTheme.textFieldTitle,
                  // ),
                  // SizedBox(height: 15.0),
                  // AppWidgets().getCustomEditTextField(
                  //   hintValue: 'Address',
                  //   controller: addressController,
                  //   prefixWidget: Image.asset(
                  //     'assets/images/icons/person.png',
                  //     scale: 3,
                  //   ),
                  //   keyboardType: TextInputType.text,
                  //   style: AppTheme.textFieldTitle,
                  // ),
                  // SizedBox(height: 15.0),
                  // Padding(
                  //   // padding: const EdgeInsets.all(8.0),
                  //   // child: Button(
                  //   //   text: 'Register',
                  //   //   onTap: () {},
                  //   // ),
                  // ),
                ],
              ),
            )
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
                      controller: nameController,
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
                      controller: nameController,
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
                        Row(
                          children: <Widget>[
                            addRadioButton(0, 'Male'),
                            addRadioButton(1, 'Female'),
                            addRadioButton(2, 'Others'),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 14.0),
                    Button(
                      paddingInsets: EdgeInsets.symmetric(
                        horizontal: 0,
                      ),
                      text: 'Save',
                      onTap: () {},
                    ),
                    //save changes button
                    // GestureDetector(
                    //     onTap: () async {
                    //       /*print(widget.authUser.userId);*/
                    //       // setState(() {
                    //       //   isLoading = true;
                    //       // });
                    //       // AuthUser user = AuthUser(
                    //       //     status: widget.authUser.status,
                    //       //     userId: widget.authUser.userId,
                    //       //     name: editProfileNameController.text.isNotEmpty
                    //       //         ? editProfileNameController.text
                    //       //         : widget.authUser.name,
                    //       //     email: editProfileEmailController.text.isNotEmpty
                    //       //         ? editProfileEmailController.text
                    //       //         : widget.authUser.email,
                    //       //     phone: editProfilePhoneController.text.isNotEmpty
                    //       //         ? editProfilePhoneController.value.text
                    //       //         : widget.authUser.phone,
                    //       //     meetingCode: widget.authUser.meetingCode,
                    //       //     imageUrl: widget.authUser.imageUrl,
                    //       //     gender: select,
                    //       //     role: widget.authUser.role,
                    //       //     joinDate: widget.authUser.joinDate,
                    //       //     lastLogin: widget.authUser.lastLogin);

                    //       // updatedUser = await Repository()
                    //       //     .updateUserProfile(user, _image);
                    //       // setState(() {
                    //       //   isLoading = false;
                    //       // });
                    //       // if (updatedUser != null) {
                    //       //   authService.updateUser(updatedUser);
                    //       //   widget.profileUpdatedCallback();
                    //       //   if (this.mounted) {
                    //       //     setState(() {});
                    //       //   }
                    //       // }
                    //     },
                    //     child: HelpMe()
                    //         .submitButton(screnWidth, AppContent.saveChanges))
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
