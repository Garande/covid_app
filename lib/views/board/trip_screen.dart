import 'package:covid_app/models/trip_summary.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class TripScreen extends StatefulWidget {
  final TripSummary tripSummary;

  const TripScreen({Key key, this.tripSummary}) : super(key: key);
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Screen'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Center(
        child: Text(widget.tripSummary.trip.passengerName),
      ),
    );
  }
}
