import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip_summary.dart';
import 'package:covid_app/views/board/single_user_trip_screen.dart';
// import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripScreen extends StatefulWidget {
  final List<TripSummary> tripSummaries;

  const TripScreen({Key key, this.tripSummaries}) : super(key: key);
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  MovementsBloc _movementsBloc;
  AppUser appUser;

  @override
  void initState() {
    _movementsBloc = BlocProvider.of<MovementsBloc>(context);
    fetchUser();
    super.initState();
  }

  fetchUser() async {
    appUser = await _movementsBloc.getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CardContainer(
            path: 'assets/images/agent-travel.png',
            appBar: true,
            children: <Widget>[
          SizedBox(
            height: 34,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Text(
              "Travel Mode",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0),
                child: appUser != null
                    ? SingleUserTripScreen(
                        appUser: appUser,
                        trip: widget.tripSummaries[0].trip,
                        movementsBloc: _movementsBloc,
                      )
                    : Container(),
              ),
            ),
          ),
        ]));

    //   appBar: AppBar(
    //     title: Text('Trip Screen'),
    //     backgroundColor: AppTheme.primaryColor,
    //   ),
    //   body: Center(
    //     child: Text(widget.tripSummaries[0].trip != null
    //         ? widget.tripSummaries[0].trip.userId
    //         : 'Null'),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {},
    //     backgroundColor: AppTheme.primaryColorDark,
    //   ),
    // );
  }
}
