// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class ShowNoData extends StatelessWidget {
  final String title;
  final String pathImage;
  const ShowNoData({Key? key, required this.title, required this.pathImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showImage = ShowImage;
    var showTitle = ShowTitle;
    return Container(
      decoration: MyConstant().gradianLinearBackground(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 250,
              child: ShowImage(path: pathImage),
            ),
            ShowTitle(
              title: 'Empty Cart',
              textStyle: MyConstant().h1White_Style(),
            ),
          ],
        ),
      ),
    );
  }
}
