import 'package:covid_app/blocs/corona/corona_bloc.dart';
import 'package:covid_app/models/corona_total_count.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/board/barcode_scan_screen.dart';
import 'package:covid_app/views/widgets/card_button.dart';
import 'package:covid_app/views/widgets/card_main.dart';
import 'package:covid_app/views/widgets/counter.dart';
import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:covid_app/views/widgets/page_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final controller = ScrollController();
  double offset = 0;

  CoronaBloc _coronaBloc;
  // CoronaTotalCount coronaTotalCount;

  @override
  void initState() {
    _coronaBloc = CoronaBloc();
    fetchData();
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  fetchData() async {
    // coronaTotalCount = await _coronaBloc.fetchAllTotalCount();
  }

  bool hasFetched = false;

  // llkl

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SingleChildScrollView(
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
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            CardButton(
                              image: AssetImage(
                                  'assets/images/icons/heartbeat.png'),
                              color: AppTheme.lightGreen,
                              children: [
                                Text(
                                  'Pair 2 Ride',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.getPrimaryColor(),
                                  ),
                                ),
                              ],
                              onTap: () {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (context) => BarcodeScanScreen(),
                                  ),
                                );
                              },
                            ),
                            CardButton(
                              image: AssetImage(
                                  'assets/images/icons/blooddrop.png'),
                              color: AppTheme.lightYellow,
                              children: [
                                Text(
                                  'Trips',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.getPrimaryColor(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            FutureBuilder<CoronaTotalCount>(
                future: _coronaBloc.fetchAllTotalCount(),
                builder: (context, snapshot) {
                  hasFetched = false;
                  CoronaTotalCount coronaTotalCount = CoronaTotalCount(
                      confirmed: 1445556, deaths: 9889449, recovered: 323233);
                  if (snapshot.hasData) {
                    coronaTotalCount = snapshot.data;
                    hasFetched = true;
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
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
                            snapshot.connectionState == ConnectionState.waiting)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (snapshot.error != null)
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Center(
                              child: Text('Error fetching total count data'),
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
    );

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              height: 228.5 + statusBarHeight,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                  colors: [
                    // AppTheme.black,
                    AppTheme.getPrimaryColor(),
                    AppTheme.getPrimaryDarkColor(),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),

          // BODY
          Padding(
            padding: EdgeInsets.all(30.0),
            child: ListView(
              children: <Widget>[
                // Header - Greetings and Avatar
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Good Morning,\nPatient",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    CircleAvatar(
                        radius: 26.0,
                        backgroundImage: AssetImage(
                            'assets/images/icons/profile_picture.png'))
                  ],
                ),

                SizedBox(height: 50),

                // Main Cards - Heartbeat and Blood Pressure
                Container(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      CardMain(
                        image: AssetImage('assets/images/icons/heartbeat.png'),
                        title: "Hearbeat",
                        value: "66",
                        unit: "bpm",
                        color: AppTheme.lightGreen,
                      ),
                      CardMain(
                        image: AssetImage('assets/images/icons/blooddrop.png'),
                        title: "Blood Pressure",
                        value: "66/123",
                        unit: "mmHg",
                        color: AppTheme.lightYellow,
                      )
                    ],
                  ),
                ),

                // Section Cards - Daily Medication
                SizedBox(height: 50),

                Text(
                  "YOUR DAILY MEDICATIONS",
                  style: AppTheme.textFieldTitlePrimaryColored,
                ),

                SizedBox(height: 20),

                Container(
                    height: 125,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        // CardSection(
                        //   image: AssetImage('assets/icons/capsule.png'),
                        //   title: "Metforminv",
                        //   value: "2",
                        //   unit: "pills",
                        //   time: "6-7AM",
                        //   isDone: false,
                        // ),
                        // CardSection(
                        //   image: AssetImage('assets/icons/syringe.png'),
                        //   title: "Trulicity",
                        //   value: "1",
                        //   unit: "shot",
                        //   time: "8-9AM",
                        //   isDone: true,
                        // )
                      ],
                    )),

                SizedBox(height: 50),

                // Scheduled Activities
                Text(
                  "SCHEDULED ACTIVITIES",
                  style: AppTheme.textFieldTitlePrimaryColored,
                ),

                SizedBox(height: 20),

                Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      // CardItems(
                      //   image: Image.asset(
                      //     'assets/icons/Walking.png',
                      //   ),
                      //   title: "Walking",
                      //   value: "750",
                      //   unit: "steps",
                      //   color: Constants.lightYellow,
                      //   progress: 30,
                      // ),
                      // CardItems(
                      //   image: Image.asset(
                      //     'assets/icons/Swimming.png',
                      //   ),
                      //   title: "Swimming",
                      //   value: "30",
                      //   unit: "mins",
                      //   color: Constants.lightBlue,
                      //   progress: 0,
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
