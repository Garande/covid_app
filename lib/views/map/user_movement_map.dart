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
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMovementMap extends StatefulWidget {
  final AppUser appUser;

  const UserMovementMap({Key key, this.appUser}) : super(key: key);
  @override
  _UserMovementMapState createState() => _UserMovementMapState();
}

class _UserMovementMapState extends State<UserMovementMap>
    with TickerProviderStateMixin {
  // AppUser appUser;
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

  MovementsBloc _movementsBloc;

  BitmapDescriptor mapMarkerIcon;

  bool isFetchingMovements = false;

  Completer<GoogleMapController> _completer = Completer();

  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _movementsBloc = BlocProvider.of<MovementsBloc>(context);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    isFetchingMovements = true;

    _animationController.forward();
    fetchMovements();
  }

  @override
  void dispose() {
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
    try {
      DateTime today = new DateTime.now();
      DateTime lastTwoWeeks = today.subtract(new Duration(days: 14));
      List<UserMovement> _userMovements =
          await _movementsBloc.fetchUserMovementsForRange(
        userId: widget.appUser.userId,
        dateTime1: lastTwoWeeks,
        dateTime2: today,
      );
      printLog('============================#########============');
      printLog(_userMovements.length);
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

      _animationController.reverse();

      setState(() {
        _userMarkers = _mapMarkers;
        isFetchingMovements = false;
      });

      _initMarkers();
    } catch (e) {
      printLog(e);
      setState(() {
        _animationController.reverse();
        isFetchingMovements = false;
      });
    }
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
          _buildOverlayBackground(),
        ],
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
              child: Center(
                child: isFetchingMovements ? LoadingIndicator() : Container(),
              ),
            ),
          ),
        );
      },
    );
  }
}
