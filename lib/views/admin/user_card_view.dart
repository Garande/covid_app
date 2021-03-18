import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/avatar.dart';
import 'package:flutter/material.dart';

class UserCardView extends StatelessWidget {
  final AppUser appUser;
  final VoidCallback onTap;

  const UserCardView({this.appUser, this.onTap});

  Widget _buildCard(BuildContext context, {String title, String description}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 28,
        right: 28,
        top: 10,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 100,
          maxWidth: MediaQuery.of(context).size.width - 50,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          final itemHeight = constraints.maxHeight;
          final itemWidth = constraints.maxWidth;
          return Stack(
            children: <Widget>[
              _buildShadow(itemWidth),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.all(0),
                color: AppTheme.white,
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                elevation: 0,
                highlightElevation: 2,
                disabledColor: AppTheme.white,
                onPressed: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Avatar(
                                photoUrl: appUser.photoUrl,
                                size: 80,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ..._buildDecorations(itemHeight),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildDecorations(double itemHeight) {
    return [
      Positioned(
        top: -itemHeight * 0.616,
        left: -itemHeight * 0.53,
        child: CircleAvatar(
          radius: itemHeight * 1.03 / 2,
          backgroundColor: Colors.grey.withOpacity(0.12),
        ),
      ),
      Positioned(
        top: -itemHeight * 0.16,
        right: -itemHeight * 0.25,
        child: Image.asset(
          'assets/images/account.png',
          width: itemHeight * 1.388,
          height: itemHeight * 1.388,
          color: Colors.grey.withOpacity(0.12),
        ),
      ),
    ];
  }

  Widget _buildShadow(double itemWidth) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: itemWidth * 0.82,
        height: 5,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(0, 2),
              blurRadius: 15,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      context,
      title: appUser.name,
      description: appUser.phoneNumber,
    );
  }
}
