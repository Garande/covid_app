import 'dart:async';

import 'package:covid_app/blocs/authentication/countriesBloc.dart';
import 'package:covid_app/models/country.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PhonePage extends StatefulWidget {
  Color cardBackgroundColor = AppTheme.nearlyWhite;

  final String logoPath;
  final Function startAuth;

  PhonePage({Key key, this.logoPath, this.startAuth}) : super(key: key);
  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final countriesBloc = CountriesBloc();

  double _height, _width, _fixedPadding;

  TextEditingController _searchCountryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  int _selectedCountryIndex = 230;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Disposing _countriesSearchController
    _searchCountryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.020;

    return Scaffold(
      backgroundColor: AppTheme.nearlyWhite,
      body: SafeArea(
        child: Center(
          child: _getBody(),
        ),
      ),
    );
  }

  Widget _getBody() => Container(
        height: _height * 8 / 10,
        width: _width * 8 / 10,
        child: StreamBuilder(
          stream: countriesBloc.countries,
          builder: (context, var snap) {
            if (snap.hasData) {
              return _getColumnBody(snap.data) ?? Container();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.nearlyDarkBlue),
                ),
              );
            }
          },
        ),
      );

  Widget _getColumnBody(countries) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device

          // Padding(
          //   padding: EdgeInsets.all(_fixedPadding),
          //   child: AppWidgets.getLogo(
          //       logoPath: widget.logoPath, height: _height * 0.12),
          // ),

          // AppName:
          Text(
            'Sign in',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 0.5,
              color: AppTheme.darkText,
            ),
          ),

          SizedBox(
            height: 10,
          ),

          AppWidgets.phoneNumberWidget(
            controller: _phoneNumberController,
            code: countries[_selectedCountryIndex].dialCode,
            flag: countries[_selectedCountryIndex].flag,
            hintText: 'Enter Phone number',
            onPressed: showCountries,
            key: 'EnterPhone',
            fontSize: 19,
          ),

          // Padding(
          //   padding: EdgeInsets.only(
          //     left: 10,
          //     right: 10,
          //     bottom: _fixedPadding,
          //   ),
          //   child: Container(
          //     color: AppTheme.nearlyDarkBlue,
          //     width: MediaQuery.of(context).size.width,
          //     height: 1.4,
          //   ),
          // ),

          SizedBox(height: _fixedPadding * 1.5),

          Row(
            children: <Widget>[
              // SizedBox(width: 20.0),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'By signing in, you accept our ',
                        style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'conditions of use ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: 'and our ',
                        style: TextStyle(
                          color: AppTheme.darkText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'privacy policy',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 20.0),
            ],
          ),

          SizedBox(height: _fixedPadding * 1.5),

          Button(
            text: 'Continue',
            onTap: () {
              showPhoneNumberAlert(countries[_selectedCountryIndex].dialCode,
                  countries[_selectedCountryIndex].code);
            },
            paddingInsets: const EdgeInsets.only(
              left: 0,
              right: 0,
            ),
            width: MediaQuery.of(context).size.width,
            height: 45,
          )
        ],
      );

  showPhoneNumberAlert(dialCode, code) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Text(
              'Are you sure you want to continue\n with this number ${(dialCode + _phoneNumberController.value.text)}',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppTheme.fontName,
                color: AppTheme.darkText,
                fontSize: 17,
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.white,
              child: Text(
                'CLOSE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.grey.withOpacity(.6),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.startAuth(
                    _phoneNumberController.value.text, dialCode, code);
              },
              color: Colors.white,
              child: Text(
                'OK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.getPrimaryColor(),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showCountries() {
    showDialog(
        context: context,
        builder: (BuildContext context) => searchAndPickYourCountryHere(),
        barrierDismissible: false);
    _searchCountryController.addListener(searchCountries);
  }

//listener for country search
  searchCountries() async {
    String query = _searchCountryController.text;
    List<Country> searchResults = [];
    searchResults.clear();
    searchResults = await countriesBloc.searchCountry(query);
  }

  /*
   * Child for Dialog
   * Contents:
   *    SearchCountryTextFormField
   *    StreamBuilder
   *      - Shows a list of countries
   */
  Widget searchAndPickYourCountryHere() => WillPopScope(
        onWillPop: () => Future.value(true),
        child: Dialog(
          key: Key('SearchCountryDialog'),
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //  TextFormField for searching country
                AppWidgets.searchField(
                    controller: _searchCountryController,
                    hintText: 'Search your country'),

                //  Returns a list of Countries that will change according to the search query
                SizedBox(
                  height: 300.0,
                  child: StreamBuilder<List<Country>>(
                      //key: Key('Countries-StreamBuilder'),
                      stream: countriesBloc.searchResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data.length == 0
                              ? Center(
                                  child: Text('Your search found no results',
                                      style: TextStyle(fontSize: 16.0)),
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      AppWidgets.selectableWidget(
                                          displayText: "  " +
                                              snapshot.data[i].flag +
                                              "  " +
                                              snapshot.data[i].name +
                                              " (" +
                                              snapshot.data[i].dialCode +
                                              ")",
                                          object: snapshot.data[i],
                                          selectThisObject: (Country c) =>
                                              selectThisCountry(c)),
                                );
                        } else if (snapshot.hasError)
                          return Center(
                            child: Text('Seems, there is an error',
                                style: TextStyle(fontSize: 16.0)),
                          );
                        return Center(child: CircularProgressIndicator());
                      }),
                )
              ],
            ),
          ),
        ),
      );

  /*
   *  This callback is triggered when the user taps(selects) on any country from the available list in dialog
   *    Resets the search value
   *    Close the stream & sink
   *    Updates the selected Country and adds dialCode as prefix according to the user's selection
   */
  void selectThisCountry(Country country) {
    print(country);
    _searchCountryController.clear();
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 10)).whenComplete(() {
      setState(() {
        _selectedCountryIndex = countriesBloc.myCountries.indexOf(country);
      });
    });
  }
}
