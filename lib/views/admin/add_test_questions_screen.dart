import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AddTestQuestionsScreen extends StatefulWidget {
  @override
  _AddTestQuestionsScreenState createState() => _AddTestQuestionsScreenState();
}

class _AddTestQuestionsScreenState extends State<AddTestQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Test Question'),
        backgroundColor: AppTheme.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
