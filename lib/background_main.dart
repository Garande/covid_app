import 'package:covid_app/services/location_service.dart';
import 'package:flutter/material.dart';

void backgroundMain() {
  WidgetsFlutterBinding.ensureInitialized();

  LocationService().listenToUserLocation();
}
