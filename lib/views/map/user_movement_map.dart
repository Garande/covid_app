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
import 'package:covid_app/views/widgets/app_widget.dart';
import 'package:covid_app/views/widgets/button.dart';
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

  final String _markerImageUrl =
      'https://img.icons8.com/office/80/000000/marker.png';

  Future moveCamera(LatLng newLoc) async {
    final GoogleMapController controller = await _completer.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newLoc,
      zoom: 17.0,
      bearing: 45.0,
      tilt: 45.0,
    )));
  }

  @override
  void initState() {
    _movementsBloc = BlocProvider.of<MovementsBloc>(context);

    mapMarkerIcon = BitmapDescriptor.defaultMarker;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
    isFetchingMovements = true;
    initializeMapMarkerIcon();

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
    setState(() {});
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

      printLog('****************************************');
      printLog(_userMovements.length);

      int i = 0;
      _userMovements.forEach((_movement) {
        ++i;

        printLog('#############################');
        printLog(_movement.latitude);

        var random = Random();
        int rand = random.nextInt(100000000);
        printLog(_movement.id);
        _mapMarkers.add(
          MapMarker(
              icon: BitmapDescriptor.defaultMarker,
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
              onTap: () {
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
                  builder: (context) => OnTapUserMovementModal(
                    userMovement: _movement,
                    onUpdate: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              }),
        );
      });

      // printLog('KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK');
      // printLog(_mapMarkers.length);

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

class OnTapUserMovementModal extends StatefulWidget {
  final Function() onUpdate;
  final UserMovement userMovement;
  const OnTapUserMovementModal({
    this.userMovement,
    Key key,
    this.onUpdate,
  }) : super(key: key);

  @override
  _OnTapUserMovementModalState createState() => _OnTapUserMovementModalState();
}

class _OnTapUserMovementModalState extends State<OnTapUserMovementModal> {
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
              'Select Action',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 18),

            Container(
              height: MediaQuery.of(context).viewInsets.bottom + 130,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppWidgets().getCustomEditTextField(
                    hintValue: 'Enter Radius to Query',
                    prefixWidget: Padding(
                      padding: const EdgeInsets.only(left: 9),
                      child: Image.asset(
                        'assets/images/icons/hash.png',
                        scale: 3,
                      ),
                    ),
                    style: AppTheme.textFieldTitlePrimaryColored,
                    keyboardType: TextInputType.number,
                  ),
                  Button(
                    text: 'Show nearby users',
                    onTap: () {
                      // widget.onUpdate(selectedValue);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
