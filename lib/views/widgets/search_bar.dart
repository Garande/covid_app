import 'package:flutter/material.dart';
import 'package:covid_app/utils/app_theme.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    this.margin = const EdgeInsets.symmetric(horizontal: 28),
    this.placeHolder = "Search users...",
    @required this.searchEdittingController,
    this.onChanged,
    this.onSearch,
    this.onFinish,
  }) : super(key: key);

  final EdgeInsets margin;
  final String placeHolder;
  final TextEditingController searchEdittingController;
  final Function(String text) onChanged;
  final Function(String text) onSearch;
  final Function() onFinish;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      margin: margin,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search),
          SizedBox(width: 13),
          Expanded(
            child: TextFormField(
              controller: searchEdittingController,
              onChanged: onChanged,
              onFieldSubmitted: onSearch,
              onEditingComplete: onFinish,
              decoration: InputDecoration(
                hintText: placeHolder,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppTheme.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
