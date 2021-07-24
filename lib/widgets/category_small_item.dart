// import 'dart:html';

import 'package:DriversMobile/actions/actions.dart';
import 'package:flutter/material.dart';
import '../libs.dart';
import 'package:provider/provider.dart';

class CategorySmallItem extends StatelessWidget {
  final Category category;
  final Color background;
  final Color color;
  const CategorySmallItem(
      {Key key, @required this.category, this.background, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.28,
      // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        children: [
          Icon(
            category.icon,
            size: 50,
            color: this.color,
          ),
          Text(
            Translation.translate(
                context.watch<UserDataProvider>().language, category.Name),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
