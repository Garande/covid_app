import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/common/empty_meeting_history.png',
              width: 146,
              height: 146,
            ),
            // Padding(
            //   padding:
            //   const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            //   child: Text(
            //     AppContent.loginToAccessHistory,
            //     style: CustomTheme.displayTextOne,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ));
  }
}
