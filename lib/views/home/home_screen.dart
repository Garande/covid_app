import 'package:async/async.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/blocs/corona/corona_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/models/corona_total_count.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/board/barcode_event_scan_screen.dart';
import 'package:covid_app/views/board/barcode_scan_screen.dart';
import 'package:covid_app/views/forms/driver_registration_form.dart';
import 'package:covid_app/views/history/history_screen.dart';
import 'package:covid_app/views/test/welcome_self_test.dart';
import 'package:covid_app/views/widgets/button.dart';
import 'package:covid_app/views/widgets/card_button.dart';
import 'package:covid_app/views/widgets/card_main.dart';
import 'package:covid_app/views/widgets/counter.dart';
import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:covid_app/views/widgets/fab.dart';
import 'package:covid_app/views/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final controller = ScrollController();
  double offset = 0;

  CoronaBloc _coronaBloc;
  AuthenticationBloc _authenticationBloc;

  AppUser appUser;
  // CoronaTotalCount coronaTotalCount;

  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    _coronaBloc = CoronaBloc();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    fetchData();
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  fetchData() async {
    appUser = await _authenticationBloc.getCurrentUser();
    // coronaTotalCount = await _coronaBloc.fetchAllTotalCount();
  }

  bool hasFetched = false;

  AsyncMemoizer _memoizer = AsyncMemoizer<CoronaTotalCount>();

  Future<CoronaTotalCount> fetchTotalCount() {
    return _memoizer.runOnce(() => _coronaBloc.fetchAllTotalCount());
  }

  // llkl

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                ////////////////
                ///
                Stack(
                  children: [
                    PageHeader(
                      image: "assets/images/icons/Drcorona.svg",
                      message: 'All you need\n is stay at home.',
                      offset: offset,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 160,
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                FutureBuilder<CoronaTotalCount>(
                    future: fetchTotalCount(),
                    builder: (context, snapshot) {
                      hasFetched = false;
                      CoronaTotalCount coronaTotalCount;
                      // if (snapshot.hasData) {
                      coronaTotalCount = snapshot.data;
                      hasFetched = true;
                      // }
                      if (coronaTotalCount == null) {
                        coronaTotalCount = CoronaTotalCount(
                            confirmed: 1445556,
                            deaths: 9889449,
                            recovered: 323233);
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // if (appUser == null || appUser.role == null)
                            //   Button(
                            //     text: 'Register your Ride',
                            //     onTap: () {
                            //       Navigator.push(
                            //         context,
                            //         new MaterialPageRoute(
                            //           builder: (context) =>
                            //               DriverRegistrationForm(),
                            //         ),
                            //       );
                            //     },
                            //     paddingInsets: EdgeInsets.symmetric(
                            //       horizontal: 0,
                            //       vertical: 0,
                            //     ),
                            //   ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Case Update\n",
                                        style: AppTheme.titleTextStyle,
                                      ),
                                      if (coronaTotalCount != null)
                                        TextSpan(
                                          text:
                                              "Newest update ${hasFetched ? Helper.formatDateMonth(new DateTime.now()) : Helper.formatDateMonth(new DateTime.now().subtract(Duration(days: 1)))}",
                                          style: TextStyle(
                                            color: AppTheme.textLightColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "See details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            if (!snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.waiting)
                              Center(
                                child: CircularProgressIndicator(),
                              )
                            else if (snapshot.error != null)
                              Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 16),
                                child: Center(
                                  child:
                                      Text('Error fetching total count data'),
                                ),
                              )
                            else
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  boxShadow: AppTheme.boxShadow,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  color: Colors.white,
                                ),
                                child: Container(
                                  // height: 100,
                                  constraints: BoxConstraints(
                                    maxHeight: 130,
                                  ),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Counter(
                                        color: AppTheme.warningColor,
                                        number: coronaTotalCount.confirmed,
                                        title: "Infected",
                                      ),
                                      Counter(
                                        color: AppTheme.dangerColor,
                                        number: coronaTotalCount.deaths,
                                        title: "Deaths",
                                      ),
                                      Counter(
                                        color: AppTheme.successColor,
                                        number: coronaTotalCount.recovered,
                                        title: "Recovered",
                                      ),
                                    ],
                                  ),
                                ),

                                // return Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //   children: [

                                //   ],
                                // );
                              ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
          _buildOverlayBackground(),
        ],
      ),
      floatingActionButton: ExpandedAnimationFab(
        items: [
          FabItem(
            "Self Test",
            Icons.assistant,
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => WelcomeSelfTestScreen(),
                ),
              );
            },
          ),
          FabItem(
            "Scan 2 Attend",
            Icons.add_business,
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => BarcodeEventScanScreen(),
                ),
              );
            },
          ),
          FabItem(
            "Register Event",
            Icons.add_business,
            onPress: () {
              _animationController.reverse();
              // Navigator.of(context).push(
              //   new MaterialPageRoute(
              //     builder: (context) => WelcomeSelfTestScreen(),
              //   ),
              // );
            },
          ),
          FabItem(
            "Scan 2 Ride",
            Icons.airport_shuttle,
            onPress: () {
              _animationController.reverse();
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => BarcodeScanScreen(),
                ),
              );
            },
          ),
          FabItem(
            "Register Ride",
            Icons.airport_shuttle_sharp,
            onPress: () {
              _animationController.reverse();
              // Navigator.of(context).push(
              //   new MaterialPageRoute(
              //     builder: (context) => WelcomeSelfTestScreen(),
              //   ),
              // );
            },
          ),
          FabItem(
            "History",
            Icons.article,
            onPress: () {
              _animationController.reverse();
              // Navigator.of(context).push(
              //   new MaterialPageRoute(
              //     builder: (context) => HistoryScreen(),
              //   ),
              // );
            },
          ),
        ],
        onPress: () {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        },
        animation: _animation,
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
            ),
          ),
        );
      },
    );
  }
}
