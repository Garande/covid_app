import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/card_main.dart';
import 'package:covid_app/views/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  // llkl

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
