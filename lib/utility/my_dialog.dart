// ignore_for_file: prefer_const_constructors, prefer_void_to_null

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shoppingmallpea2/utility/my_constant.dart';
import 'package:shoppingmallpea2/widgets/show_image.dart';
import 'package:shoppingmallpea2/widgets/show_title.dart';

class MyDialog {
  final Function()? funcAction;
  MyDialog({this.funcAction});

  Future<Null> alertLocationService(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(title: title, textStyle: MyConstant().h2_Style()),
          subtitle:
              ShowTitle(title: message, textStyle: MyConstant().h3_Style()),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                exit(0);
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2_Style(),
          ),
          subtitle: ShowTitle(
            title: message,
            textStyle: MyConstant().h3_Style(),
          ),
        ),
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          )
        ],
      ),
    );
  }

  Future<Null> actionDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(
            title: title,
            textStyle: MyConstant().h2_Style(),
          ),
          subtitle: ShowTitle(
            title: message,
            textStyle: MyConstant().h3_Style(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: funcAction,
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancle'),
          )
        ],
      ),
    );
  }

  Future<Null> showProgressDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
              // ignore: prefer_const_constructors
              child: Center(
                // ignore: prefer_const_constructors
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
              onWillPop: () async {
                return false;
              },
            ));
  }
}
