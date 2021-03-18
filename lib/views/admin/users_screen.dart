import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/utils/helper.dart';
import 'package:covid_app/views/admin/user_card_view.dart';
import 'package:covid_app/views/admin/user_profile_screen.dart';
import 'package:covid_app/views/widgets/cardContainer.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen>
    with TickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  AuthenticationBloc _authenticationBloc;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CardContainer(
            appBar: true,
            image: 'assets/images/account.png',
            children: <Widget>[
              SizedBox(height: screenSize.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                child: Text(
                  'Users',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: FutureBuilder<List<AppUser>>(
                          future: _authenticationBloc.fetchSystemUsers(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
                              return Center(
                                child: LoadingIndicator(),
                              );
                            }

                            if (!snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 50,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      'assets/images/empty_search.png',
                                      width: 150,
                                      height: 150,
                                    ),
                                    Center(
                                      child: Text(
                                        'No user found',
                                        style: AppTheme.titleTextStyle.copyWith(
                                          fontSize: 20,
                                          color: AppTheme.primaryColor
                                              .withOpacity(.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            List<AppUser> users = snapshot.data;

                            List<Widget> widgets = [];

                            users.forEach((user) {
                              widgets.add(
                                UserCardView(
                                  appUser: user,
                                  onTap: () {
                                    printLog('O TAP');
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(
                                          appUser: user,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            });
                            return Column(
                              children: widgets,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildOverlayBackground(),
        ],
      ),
    );
  }
}
