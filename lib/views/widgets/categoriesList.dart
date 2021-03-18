import 'package:covid_app/utils/app_theme.dart';
import 'package:covid_app/views/widgets/categoryCard.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/views/admin/users_screen.dart';

class CategoryList extends StatelessWidget {
  CategoryList({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      padding: EdgeInsets.only(left: 28, right: 28, bottom: 30),
      itemCount: categories.length,
      itemBuilder: (context, index) => CategoryCard(
        categories[index],
        onPress: () {
          categories[index].onPress(context);
        },
      ),
    );
  }

  final List<Category> categories = [
    Category(
        name: "Users",
        color: AppTheme.teal,
        onPress: (context) {
          //
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => UsersScreen(),
            ),
          );
        }),
    Category(
      name: "Drivers",
      color: AppTheme.brown,
      onPress: (context) {},
    ),
    Category(
      name: "Vehicle Types",
      color: AppTheme.blue,
      onPress: (context) {},
    ),
    Category(
      name: "Patients",
      color: AppTheme.red,
      onPress: (context) {},
    ),
    Category(
      name: "Covid Tips",
      color: AppTheme.purple,
      onPress: (context) {},
    ),
    Category(
      name: "Communities",
      color: AppTheme.yellow,
      onPress: (context) {},
    ),
  ];
}

class Category {
  final Color color;
  final String name;
  final Function(BuildContext context) onPress;

  const Category({
    @required this.color,
    @required this.name,
    @required this.onPress,
  });
}
