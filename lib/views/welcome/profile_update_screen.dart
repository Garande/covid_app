import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/welcome/sign_in.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UpdateUserProfile extends StatefulWidget {
  SignInScreenState parent;
  UpdateUserProfile(this.parent);
  AppUser appUser;
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  List gender = ["Male", "Female", "Other"];
  String select;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: AppTheme.white,
      appBar: AppBar(
        title: Text('Update Account Information'),
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
          // isLoading
          //     ? AnimatedBuilder(
          //         animation: _loadingAnimation,
          //         builder: (_, __) {
          //           return IgnorePointer(
          //             ignoring: _loadingAnimation.value == 0,
          //             child: Container(
          //               color: Colors.black.withOpacity(
          //                 _loadingAnimation.value * 0.5,
          //               ),
          //               child: Center(
          //                 child: LoadingIndicator(),
          //               ),
          //             ),
          //           );
          //         },
          //       )
          //     : Container(),
        ],
      ),
    );

    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            child: Container(
              // color: AppTheme.nearlyDarkBlue.withOpacity(0.5),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            // color: Colors.redAccent,
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              // fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 30, 20, 20),
                          // height: 300,
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange[100],
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                AppWidgets.textField(
                                  hintText: 'Name',
                                  controller: widget.parent.nameController,
                                  inputType: TextInputType.text,
                                  icon: Icon(Icons.person),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AppWidgets.textField(
                                  hintText: 'Email',
                                  controller: widget.parent.emailController,
                                  inputType: TextInputType.emailAddress,
                                  icon: Icon(Icons.mail),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AppWidgets.textField(
                                  hintText: 'Phone Number',
                                  controller: widget.parent.phoneController,
                                  inputType: TextInputType.phone,
                                  icon: Icon(Icons.phone),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                AppWidgets.textField(
                                  hintText: 'Date of Birth',
                                  controller: widget.parent.dobController,
                                  inputType: TextInputType.phone,
                                  icon: Icon(Icons.calendar_today),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    MaterialButton(
                                      splashColor: AppTheme.getPrimaryColor(),
                                      onPressed: () {
                                        widget.parent.completeUserProfile();
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Complete',
                                            style: TextStyle(
                                              color: AppTheme.getPrimaryColor(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: AppTheme.getPrimaryColor(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // color: Colors.white54,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Material(
                            child: widget.parent.photoUrl != null &&
                                    widget.parent.photoUrl != ''
                                ? CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppTheme.nearlyDarkBlue),
                                      ),
                                      width: 80.0,
                                      height: 80.0,
                                      padding: EdgeInsets.all(15.0),
                                    ),
                                    imageUrl: widget.parent.photoUrl,
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 80.0,
                                    color: AppTheme.nearlyWhite.withOpacity(.8),
                                  ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                            borderRadius: BorderRadius.circular(12),
                            child: //image == null
                                // ?
                                Image.network(
                              widget.parent.photoUrl != null
                                  ? widget.parent.photoUrl
                                  : '',
                              width: 120,
                              height: 120,
                            )
                            // : Image.file(
                            //     image,
                            //     width: 120,
                            //     height: 120,
                            //     fit: BoxFit.cover,
                            //   ),
                            ),
                        // Positioned(
                        //   top: 0.0,
                        //   right: 0.0,
                        //   child: GestureDetector(
                        //       onTap: () {
                        //         // selectFile();
                        //         // getImage();
                        //       },
                        //       child: Container(
                        //         height: 30.0,
                        //         width: 30.0,
                        //         child: Icon(
                        //           Icons.edit,
                        //           color: AppTheme.white,
                        //         ),
                        //         decoration: BoxDecoration(
                        //           color: AppTheme.primaryColor,
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(20)),
                        //         ),
                        //       )),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 34.0,
                    ),
                    AppWidgets().getCustomEditTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: widget.parent.nameController,
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
                      controller: widget.parent.ninController,
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
                      controller: widget.parent.addressController,
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
                      text: 'Complete',
                      onTap: () {
                        widget.parent.completeUserProfile(gender: select);
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
