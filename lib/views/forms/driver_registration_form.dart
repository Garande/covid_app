import 'dart:io';

import 'package:async/async.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/driver.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid_app/models/vehicle_type.dart';

class DriverRegistrationForm extends StatefulWidget {
  final AppUser appUser;

  const DriverRegistrationForm({Key key, this.appUser}) : super(key: key);
  @override
  _DriverRegistrationFormState createState() => _DriverRegistrationFormState();
}

class _DriverRegistrationFormState extends State<DriverRegistrationForm>
    with SingleTickerProviderStateMixin {
  TextEditingController permitController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  // TextEditingController addressController = TextEditingController();

  AuthenticationBloc _authenticationBloc;

  MovementsBloc _movementsBloc;

  AnimationController _loadingAnimationController;
  Animation _loadingAnimation;
  bool isLoading = false;

  List<VehicleType> _vehicleTypes = [];

  dynamic selectedValue = null;

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

    // fetchVehicleTypes();
  }

  void fetchUser() async {
    appUser = await _authenticationBloc.getCurrentUser();
    setState(() {});
    // populateFields();
  }

  AsyncMemoizer _memoizer = AsyncMemoizer<List<VehicleType>>();

  Future<List<VehicleType>> fetchVehicleTypes() {
    return _memoizer.runOnce(() => _movementsBloc.fetchVehicleTypes());
  }

  AppUser appUser;
  File image;

  @override
  void dispose() {
    _movementsBloc?.close();
    super.dispose();
  }

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
            Navigator.pop(context);
          }
        },
        child: Stack(
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
                          controller: permitController,
                          hintValue: 'Permit No',
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
                          controller: plateController,
                          hintValue: 'Plate Number',
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

                        FutureBuilder<List<VehicleType>>(
                          future: fetchVehicleTypes(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: LoadingIndicator(),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.hasError) {
                              return Container();
                            }

                            _vehicleTypes = snapshot.data;

                            printLog(_vehicleTypes[0].label);

                            return AppWidgets().getDropdownField(
                              hintValue: 'Vehicle Type',
                              value: selectedValue,
                              prefixWidget: Padding(
                                padding: const EdgeInsets.only(left: 9),
                                child: Image.asset(
                                  'assets/images/icons/person.png',
                                  scale: 3,
                                ),
                              ),
                              onChanged: (data) {
                                setState(() {
                                  selectedValue = data;
                                });
                              },
                              items: snapshot.data.map((vehicleType) {
                                return new DropdownMenuItem<String>(
                                  value: vehicleType.id,
                                  child: new Text(
                                    vehicleType.label,
                                    style:
                                        AppTheme.textFieldTitlePrimaryColored,
                                  ),
                                );
                              }).toList(),
                              style: AppTheme.textFieldTitlePrimaryColored,
                            );
                          },
                        ),

                        SizedBox(height: 14.0),
                        Button(
                          paddingInsets: EdgeInsets.symmetric(
                            horizontal: 0,
                          ),
                          text: 'Save',
                          onTap: () {
                            Driver driver = new Driver();
                            driver.userId = appUser.userId;
                            driver.permitNo = permitController.text;
                            driver.permitUrl = null;
                            driver.plateNumber = plateController.text;
                            driver.vehicleOnBoardCount = 0;
                            driver.vehicleType = selectedValue;
                            appUser.role = AccountTypes.DRIVER;

                            _movementsBloc.add(UpdateDriver(appUser, driver));
                            // _movementsBloc.saveDriverProfile();
                            // _authenticationBloc.saveUserProfile(appUser);
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
