import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip.dart';

class TripSummary {
  final AppUser appUser;
  final AppUser peerUser;
  final Trip trip;

  TripSummary(this.appUser, this.peerUser, this.trip);
}
