import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/welcome/sign_in.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UpdateUserProfile extends StatefulWidget {
  SignInScreenState parent;
  UpdateUserProfile(this.parent);
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  @override
  Widget build(BuildContext context) {
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
}
