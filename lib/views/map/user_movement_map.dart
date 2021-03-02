import 'dart:async';
import 'dart:math';

import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/map_marker.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/services/location_service.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/utils/map_helper.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMovementMap extends StatefulWidget {
  @override
  _UserMovementMapState createState() => _UserMovementMapState();
}

class _UserMovementMapState extends State<UserMovementMap> {
  AppUser appUser;
  Fluster<MapMarker> fluster;
  Fluster<MapMarker> _clusterManager;

  LocationService locationService = LocationService();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// Initial map zoom
  double _currentZoom = 15;

  /// Map state
  bool _isLoadingMap = false;

  /// Markers state
  bool _isLoadingMarkers = false;

  // makers
  List<MapMarker> movementMarkers = [];
  final Set<Marker> markers = Set();

  LatLng initialLatLng = LatLng(0.3470375, 32.6159797);

  MovementsBloc _movementsBloc = MovementsBloc();

  BitmapDescriptor mapMarkerIcon;

  Completer<GoogleMapController> _completer = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _movementsBloc.close();
    super.dispose();
  }

  void initializeMapMarkerIcon() {
    mapMarkerIcon = BitmapDescriptor.defaultMarker;
  }

  void initializeLocation() {
    // locationService.locationStream.first.
  }

  void _initMarkers() async {
    _clusterManager = await MapHelper.initClusterManager(
        _userMarkers, _minClusterZoom, _maxClusterZoom);

    await _updateMarkers();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      MapHelper.clusterColor,
      MapHelper.clusterTextColor,
      60,
    );

    markers
      ..clear()
      ..addAll(updatedMarkers);
  }

  List<MapMarker> _userMarkers;

  void fetchMovements() async {
    List<UserMovement> _userMovements =
        await _movementsBloc.fetchUserMovements(appUser.userId);
    _userMovements
        .sort((a, b) => a.creationDateTimeMillis - b.creationDateTimeMillis);
    List<MapMarker> _mapMarkers = [];

    int i = 0;
    _userMovements.forEach((_movement) {
      ++i;
      var random = Random();
      int rand = random.nextInt(10000000000);
      _mapMarkers.add(
        MapMarker(
          icon: mapMarkerIcon,
          latitude: _movement.latitude,
          longitude: _movement.longitude,
          id: rand.toString(),
          infoWindow: InfoWindow(
            title: Helper.formatDateWithTime(
              new DateTime.fromMillisecondsSinceEpoch(
                  _movement.creationDateTimeMillis),
            ),
            snippet: 'A$i',
          ),
        ),
      );
    });

    setState(() {
      _userMarkers = _mapMarkers;
    });

    _initMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: initialLatLng,
                zoom: _currentZoom,
              ),
              onMapCreated: (controller) {
                _completer.complete(controller);
                _initMarkers();
              },
              onCameraMove: (position) => _updateMarkers(position.zoom),
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              markers: markers,
              compassEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
