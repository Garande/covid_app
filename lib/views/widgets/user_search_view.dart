import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid_app/blocs/movements/movements_bloc.dart';
import 'package:covid_app/models/appUser.dart';
import 'package:covid_app/views/widgets/loading_indicator.dart';
import 'package:covid_app/views/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBottomModal extends StatefulWidget {
  final MovementsBloc movementsBloc;
  final Function(AppUser user, Color color) onUserSelected;

  const SearchBottomModal({Key key, this.onUserSelected, this.movementsBloc})
      : super(key: key);
  @override
  _SearchBottomModalState createState() => _SearchBottomModalState();
}

class _SearchBottomModalState extends State<SearchBottomModal> {
  TextEditingController searchFieldController = new TextEditingController();

  MovementsBloc _movementsBloc;

  @override
  void initState() {
    if (widget.movementsBloc != null) {
      _movementsBloc = widget.movementsBloc;
    } else {
      _movementsBloc = BlocProvider.of<MovementsBloc>(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getColor() {
    List<Color> colors = [
      AppTheme.instaRed,
      AppTheme.instaViolet,
      AppTheme.instaBlue,
      AppTheme.instaDkYellow,
      AppTheme.instaLtYellow,
      AppTheme.beige,
      AppTheme.black,
      AppTheme.blue,
      AppTheme.brown,
      AppTheme.darkBrown,
      AppTheme.indigo,
      AppTheme.lightBlue,
      AppTheme.lightBrown,
      AppTheme.lightCyan,
      AppTheme.lightGreen,
      // AppTheme.lighterGrey,
      AppTheme.lightPink,
      AppTheme.lightPurple,
      AppTheme.lightRed,
      AppTheme.lightTeal,
      AppTheme.lightYellow,
      AppTheme.lilac,
      AppTheme.pink,
      AppTheme.purple,
      AppTheme.red,
      AppTheme.teal,
      AppTheme.yellow,
      AppTheme.violet,
    ];

    var random = new Random();
    var randomInt = random.nextInt(colors.length);

    return colors[randomInt];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 26),
      decoration: BoxDecoration(
        color: Color(0xFFFDFDFD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
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
          SearchBar(
            margin: EdgeInsets.all(0),
            searchEdittingController: searchFieldController,
            onChanged: (text) {
              _movementsBloc.searchUser(text);
            },
          ),
          Expanded(
            child: getSearchResults(),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 18),
        ],
      ),
    );
  }

  Widget getSearchResults() {
    return StreamBuilder<List<AppUser>>(
        stream: _movementsBloc.searchResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LoadingIndicator(),
            );
          }

          if (snapshot.data.length <= 0) {
            return Center(
              child: Text(
                'No results found',
                style: AppTheme.title,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              AppUser data = snapshot.data[index];
              Color color = getColor();
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      data.name != null ? data.name : '',
                      style: AppTheme.title,
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data.phoneNumber != null ? data.phoneNumber : '',
                          style: AppTheme.subtitle,
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                      ],
                    ),
                    leading: Container(
                      height: 40,
                      width: 40,
                      child: data.photoUrl != null
                          ? CachedNetworkImage(
                              imageUrl: data.photoUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(
                                Icons.error_outline,
                                color: Colors.redAccent,
                              ),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: color,
                              ),
                              child: Center(
                                child: Text(
                                  data.name.toUpperCase().substring(0, 2),
                                  style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    trailing: Icon(
                      Icons.search,
                      color: AppTheme.grey.withOpacity(0.5),
                    ),
                    onTap: () {
                      widget.onUserSelected(data, color);
                    },
                  ),
                  Divider(),
                ],
              );
            },
          );
        });
  }
}
