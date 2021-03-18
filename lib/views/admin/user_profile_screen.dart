import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/corona/corona_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/models/user_summary.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:covid_app/views/map/user_movement_map.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/avatar.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/cardContainer.dart';
import 'package:covid_app/views/widgets/fab.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> testResults = [
  CovidResult.SYMPTOMATIC,
  CovidResult.POSITIVE,
  CovidResult.NEGATIVE
];

class UserProfileScreen extends StatefulWidget {
  final AppUser appUser;

  const UserProfileScreen({Key key, this.appUser}) : super(key: key);
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  AuthenticationBloc _authenticationBloc;

  CoronaBloc _coronaBloc = CoronaBloc();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  UserSummary userSummary;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CardContainer(
            appBar: true,
            image: 'assets/images/account.png',
            children: <Widget>[
              SizedBox(height: screenSize.height * 0.03),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileCard(context),
                        _buildAddressCard(context),
                        _buildCovidSummary(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          _buildOverlayBackground(),
        ],
      ),
      floatingActionButton: ExpandedAnimationFab(
        items: [
          FabItem(
            "Update Covid Test",
            Icons.assistant,
            onPress: () {
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                backgroundColor: Color(0xFFFDFDFD),
                context: context,
                isScrollControlled: true,
                builder: (context) => CovidResultUpdateModal(
                  onUpdate: (value) {
                    var summary = userSummary;
                    if (summary == null) {
                      summary = new UserSummary();
                      summary.creationDateTimeMillis =
                          new DateTime.now().millisecondsSinceEpoch;
                      summary.userId = widget.appUser.userId;
                    }
                    summary.officialCovidTestStatus = value;
                    summary.lastUpdateDateTimeMillis =
                        new DateTime.now().millisecondsSinceEpoch;
                    _coronaBloc.updateUserSummary(summary);
                    Navigator.pop(context);
                    setState(() {
                      _animationController.reverse();
                    });

                    // startTrip(codeController.text);
                  },
                ),
              );
            },
          ),
          FabItem(
            "View Movement History",
            Icons.map_outlined,
            onPress: () {
              _animationController.reverse();
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (context) => UserMovementMap(
                    appUser: widget.appUser,
                  ),
                ),
              );
            },
          ),
          FabItem(
            "View Activity History",
            Icons.article,
            onPress: () {
              _animationController.reverse();
            },
          ),
          FabItem(
            "Clear User Data",
            Icons.delete,
            onPress: () {
              _animationController.reverse();
            },
          ),
        ],
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
        animation: _animation,
      ),
    );
  }

  Widget _buildOverlayBackground() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return IgnorePointer(
          ignoring: _animation.value == 0,
          child: InkWell(
            onTap: () => _animationController.reverse(),
            child: Container(
              color: Colors.black.withOpacity(_animation.value * 0.5),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Avatar(
                    photoUrl: widget.appUser.photoUrl,
                    size: 74,
                    borderRadius: BorderRadius.circular(12.0)),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.appUser.name,
                      style: AppTheme.displayTextBoldColoured,
                    ),
                    Text(
                      widget.appUser.phoneNumber,
                      style: AppTheme.subTitleText,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: AppTheme.boxShadow,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          boxShadow: AppTheme.boxShadow,
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 25.0, bottom: 15.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Bio',
                style: AppTheme.displayTextOne,
              ),
              SizedBox(height: 30.0),
              Row(
                children: [
                  Text(
                    'Email: ',
                    style: AppTheme.displayTextBoldColoured,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.appUser.email,
                      style: AppTheme.displayTextBoldColoured.copyWith(
                        color: AppTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Text(
                    'Address: ',
                    style: AppTheme.displayTextBoldColoured,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.appUser.address != null
                          ? widget.appUser.address
                          : 'none',
                      style: AppTheme.displayTextBoldColoured.copyWith(
                        color: AppTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: [
                  Text(
                    'NIN: ',
                    style: AppTheme.displayTextBoldColoured,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      widget.appUser.nationalIdNo != null
                          ? widget.appUser.nationalIdNo
                          : 'none',
                      style: AppTheme.displayTextBoldColoured.copyWith(
                        color: AppTheme.primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCovidSummary(BuildContext context) {
    return FutureBuilder<UserSummary>(
        future: _coronaBloc.fetchUserSummary(widget.appUser.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingIndicator(),
            );
          }

          userSummary = snapshot.data;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: AppTheme.boxShadow,
                  color: Colors.white,
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 25.0, bottom: 25.0, right: 20.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Covid-19 Test Summary',
                            style: AppTheme.displayTextOne,
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                'Official: ',
                                style: AppTheme.displayTextBoldColoured,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                (userSummary != null &&
                                        userSummary.officialCovidTestStatus !=
                                            null)
                                    ? userSummary.officialCovidTestStatus
                                    : 'none',
                                style:
                                    AppTheme.displayTextBoldColoured.copyWith(
                                  color: AppTheme.primaryColorDark,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            children: [
                              Text(
                                'Self Test: ',
                                style: AppTheme.displayTextBoldColoured,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                (userSummary != null &&
                                        userSummary.selfCovidTestStatus != null)
                                    ? userSummary.selfCovidTestStatus
                                    : 'none',
                                style:
                                    AppTheme.displayTextBoldColoured.copyWith(
                                  color: AppTheme.primaryColorDark,
                                ),
                              ),
                            ],
                          ),
                        ]))),
          );
        });
  }
}

class CovidResultUpdateModal extends StatefulWidget {
  final Function(String result) onUpdate;
  const CovidResultUpdateModal({
    Key key,
    this.onUpdate,
  }) : super(key: key);

  @override
  _CovidResultUpdateModalState createState() => _CovidResultUpdateModalState();
}

class _CovidResultUpdateModalState extends State<CovidResultUpdateModal> {
  String selectedValue;
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 3,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: Color(0xFFF4F5F4),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Select COVID Test Result',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 18),

            Container(
              height: MediaQuery.of(context).viewInsets.bottom + 100,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppWidgets().getDropdownField(
                    hintValue: 'Test Result',
                    value: selectedValue,
                    prefixWidget: Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Image.asset(
                        'assets/images/icons/hash.png',
                        scale: 3,
                      ),
                    ),
                    onChanged: (data) {
                      setState(() {
                        selectedValue = data;
                      });
                    },
                    items: testResults.map((value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(
                          value,
                          style: AppTheme.textFieldTitlePrimaryColored,
                        ),
                      );
                    }).toList(),
                    style: AppTheme.textFieldTitlePrimaryColored,
                  ),
                ],
              ),
            ),
            Button(
              text: 'Update',
              onTap: () {
                widget.onUpdate(selectedValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
