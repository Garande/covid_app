import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/card_button.dart';
import 'package:covid_app/views/widgets/card_container.dart';
import 'package:covid_app/views/widgets/categoriesList.dart';
import 'package:covid_app/views/widgets/page_header.dart';
import 'package:covid_app/views/widgets/search_bar.dart';
import 'package:covid_app/views/widgets/user_search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  final controller = ScrollController();
  double offset = 0;

  AppUser appUser;

  MovementsBloc _movementsBloc;

  TextEditingController searchController = new TextEditingController();

  AppUser _selectedUser;

  @override
  void initState() {
    _movementsBloc = BlocProvider.of<MovementsBloc>(context);
    super.initState();
    controller.addListener(onScroll);
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchBottomModal(
        movementsBloc: _movementsBloc,
        onUserSelected: (appUser, color) {
          Navigator.of(context).pop();
          Future.delayed(Duration(milliseconds: 10)).whenComplete(() {
            setState(() {
              searchController.text = appUser.name;
              // _selectedUser = school;
              // schoolColor = color;
              // animationController.reset();
              // schoolClasses =
            });
          });

          // Navigator.of(context).pop();
          // setState(() {
          //   _selectedSchool = school;
          // });
        },
      ),
    );
  }

  Widget _buildCard() {
    final screenSize = MediaQuery.of(context).size;

    return CardContainer(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(32.0),
        // ),
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      children: <Widget>[
        SizedBox(height: screenSize.height * 0.144),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            "Welcome Admin,\nHow can I help you?",
            style: TextStyle(
              fontSize: 30,
              height: 0.9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.049),
        GestureDetector(
          child: Container(
            color: Colors.transparent,
            child: IgnorePointer(
              // ignore: missing_required_param
              child: SearchBar(
                placeHolder: 'Search Users...',
              ),
            ),
          ),
          onTap: _showSearchModal,
        ),
        SizedBox(height: screenSize.height * 0.051),
        // ignore: missing_required_param
        CategoryList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: _buildCard(),
    );

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
                              onTap: () {},
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
                              onTap: () {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
