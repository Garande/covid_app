import 'package:covid_app/models/appUser.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker extends Clusterable {
  String id;
  double latitude;
  double longitude;
  BitmapDescriptor icon;
  InfoWindow infoWindow;
  AppUser appUser;
  Function onTap;
  // final bool isCluster;
  // final String clusterId;
  // final dynamic pointsSize;
  // final String childMarkerId;

  MapMarker({
    @required this.id,
    @required this.latitude,
    @required this.longitude,
    @required this.icon,
    this.infoWindow,
    this.appUser,
    this.onTap,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: latitude,
          longitude: longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
        markerId: MarkerId(id),
        position: LatLng(latitude, longitude),
        icon: icon,
        infoWindow: infoWindow,
        onTap: () {
          onTap();
        },
      );
}
