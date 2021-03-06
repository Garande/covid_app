import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/address.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/trip.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/constants.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class SingleUserTripScreen extends StatefulWidget {
  final MovementsBloc movementsBloc;
  final Trip trip;
  final AppUser appUser;

  const SingleUserTripScreen(
      {Key key, this.movementsBloc, this.trip, this.appUser})
      : super(key: key);
  @override
  _SingleUserTripScreenState createState() => _SingleUserTripScreenState();
}

class _SingleUserTripScreenState extends State<SingleUserTripScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> animation;

  AppUser peerUser;

  double logoOpacity = 0.0;
  double textOpacity = 0.0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    fetchPeerUser();
    setData();
    super.initState();
  }

  void fetchPeerUser() async {
    String peerId;
    if (widget.trip.userId == widget.appUser.userId) {
      peerId = widget.trip.peerId;
    } else {
      peerId = widget.trip.userId;
    }

    printLog('GDKJKJSLKSJSLK');
    printLog(peerId);
    if (peerId != null) {
      AppUser _appUser =
          await widget.movementsBloc.userDataRepository.getUserByUserId(peerId);

      setState(() {
        peerUser = _appUser;
      });
    }
  }

  Future<void> setData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      logoOpacity = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      textOpacity = 1.0;
    });
    _animationController.forward();
    // await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    // setState(() {
    //   opacity3 = 1.0;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildUserAvatar(),
          SizedBox(height: 20),
          _buildUserInformation(),
          SizedBox(
            height: 20,
          ),
          _buildUserLocationStart(),
          _buildAnimatedButton(),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(color: AppTheme.lightColor),
        child: peerUser != null && peerUser.photoUrl != null
            ? CachedNetworkImage(
                imageUrl: peerUser != null ? peerUser.photoUrl : '',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              )
            : Center(
                child: Text(
                  peerUser != null && peerUser.name != null
                      ? peerUser.name[0]
                      : 'G',
                  style: AppTheme.textFieldTitlePrimaryColored.copyWith(
                    fontSize: 29,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildUserInformation() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          peerUser != null && peerUser.name != null
              ? peerUser.name
              : widget.trip.passengerName != null
                  ? widget.trip.passengerName
                  : '',
          textAlign: TextAlign.center,
          style: AppTheme.textFieldTitlePrimaryColored.copyWith(
            fontSize: 22,
          ),
        )
      ],
    );
  }

  Location location = Location();
  Future<LocationData> getLatestUserLocation() async {
    var _userLocation = await location.getLocation();
    return _userLocation;
  }

  Widget _buildUserLocationStart() {
    return Container();
  }

  Widget _buildAnimatedButton() {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCirc,
      ),
      child: Button(
        text: 'End Trip',
        onTap: () async {
          Trip newTrip = widget.trip;
          newTrip.lastUpdateDateTimeMillis =
              new DateTime.now().millisecondsSinceEpoch;
          newTrip.status = TripStatus.ENDED_TRIP;
          printLog('END RTIP');
          printLog(newTrip.toJson());
          var locationData = await getLatestUserLocation();
          newTrip.addressTo = new Address(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              accuracy: locationData.accuracy,
              creationDateTimeMillis:
                  new DateTime.now().millisecondsSinceEpoch);
          widget.movementsBloc.endTrip(newTrip);
        },
        width: 200.0,
      ),
    );
  }
}
